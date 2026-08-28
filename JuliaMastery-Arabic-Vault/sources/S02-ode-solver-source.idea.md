---
id: S02
aliases:
  - "كود محلل ODE"
type: source-note
status: complete
tags:
  - source/code
  - julia
source: src/ode.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# كود محلل ODE


## غرض الملف

هذا هو التطبيق الكامل لتصميم ODE: أنواع الخوارزميات، المسألة، النتيجة، نقاط التوسعة، وتجهيز النوع والحلقة العامة.

## أسئلة توجه القراءة

1. أين توجد invariants التي تمنع فترة زمنية غير صالحة؟
2. أي سطر يضمن وصول الزمن الأخير إلى `tf`؟
3. كيف تضيف Heun من دون تغيير هذا الملف؟

## الكود الكامل

```julia
# =============================================================================
# Stage 1: represent algorithms as data types
# =============================================================================

# Why make Euler and RK4 types instead of Symbols such as `:euler` and `:rk4`?
# Julia can select the correct method by dispatch without a large conditional.
abstract type AbstractStepper end

"""Euler's method: simple and inexpensive, with first-order accuracy."""
struct Euler{T<:Real} <: AbstractStepper
    dt::T

    function Euler(dt::T) where {T<:Real}
        isfinite(dt) || throw(ArgumentError("dt must be finite"))
        dt > zero(dt) || throw(ArgumentError("dt must be positive"))
        return new{T}(dt)
    end
end

"""Classical Runge-Kutta: four slope samples and fourth-order accuracy."""
struct RK4{T<:Real} <: AbstractStepper
    dt::T

    function RK4(dt::T) where {T<:Real}
        isfinite(dt) || throw(ArgumentError("dt must be finite"))
        dt > zero(dt) || throw(ArgumentError("dt must be positive"))
        return new{T}(dt)
    end
end

# This is the first public extension point. A new algorithm defines `step_size`.
step_size(algorithm::Euler) = algorithm.dt
step_size(algorithm::RK4) = algorithm.dt

# =============================================================================
# Stage 2: separate the problem from the solution method
# =============================================================================

"""
    ODEProblem(f, u0, (t0, tf), parameters=nothing)

Represent `du/dt = f(u, parameters, t)`. The problem does not know whether Euler
or RK4 will solve it, so the same problem can be tested with different algorithms.
"""
struct ODEProblem{F,U,T<:Real,P}
    f::F
    u0::U
    tspan::Tuple{T,T}
    parameters::P

    # The inner constructor is the final gate before object creation, so validate
    # invariants here. A default constructor might be more specific than an outer
    # method and bypass its checks.
    function ODEProblem(
        f::F,
        u0::U,
        tspan::Tuple{T,T},
        parameters::P,
    ) where {F,U,T<:Real,P}
        start_time, final_time = tspan
        isfinite(start_time) && isfinite(final_time) ||
            throw(ArgumentError("tspan endpoints must be finite"))
        final_time > start_time || throw(ArgumentError("tspan must satisfy tf > t0"))
        return new{F,U,T,P}(f, u0, tspan, parameters)
    end
end

function ODEProblem(
    f,
    u0,
    tspan::Tuple{T,S},
    parameters=nothing,
) where {T<:Real,S<:Real}
    # Promotion gives values such as 0 and 1.5 one common type in the tuple.
    start_time, final_time = promote(tspan...)
    return ODEProblem(f, u0, (start_time, final_time), parameters)
end

# =============================================================================
# Stage 3: define the result and its small interface
# =============================================================================

"""Saved times and states together with the algorithm that produced them."""
struct ODESolution{T,U,A<:AbstractStepper}
    t::Vector{T}
    u::Vector{U}
    algorithm::A
end

# Four small methods make the solution behave like a normal collection.
Base.length(solution::ODESolution) = length(solution.t)
Base.firstindex(::ODESolution) = 1
Base.lastindex(solution::ODESolution) = length(solution)
Base.getindex(solution::ODESolution, index::Integer) = solution.u[index]

function Base.iterate(solution::ODESolution, index=1)
    index > length(solution) && return nothing
    return ((solution.t[index], solution.u[index]), index + 1)
end

function Base.show(io::IO, solution::ODESolution)
    algorithm_name = nameof(typeof(solution.algorithm))
    print(io, "ODESolution(", length(solution), " states, algorithm=", algorithm_name, ")")
end

# =============================================================================
# Stage 4: define one step for each algorithm
# =============================================================================

"""
    step(f, state, parameters, time, dt, algorithm)

Advance the solution by one step. This is the second public extension point: a
new algorithm adds a method instead of modifying `solve`. Multiple dispatch is
part of the architecture here.
"""
step(f, state, parameters, time, dt, ::Euler) =
    state + dt * f(state, parameters, time)

function step(f, state, parameters, time, dt, ::RK4)
    half_dt = dt / 2
    k1 = f(state, parameters, time)
    k2 = f(state + half_dt * k1, parameters, time + half_dt)
    k3 = f(state + half_dt * k2, parameters, time + half_dt)
    k4 = f(state + dt * k3, parameters, time + dt)
    return state + (dt / 6) * (k1 + 2k2 + 2k3 + k4)
end

# Prepare state storage that is compatible with the step type. If u0 contains
# integers and dt is 0.1, storing results in `Vector{Int}` would be wrong.
# Multiplication by `one(dt)` promotes without forcing Float64 on BigFloat users.
_prepare_state(state::Number, dt) = state * one(dt)
_prepare_state(state::AbstractArray, dt) = state .* one(dt)
_prepare_state(state, _) = copy(state)

# =============================================================================
# Stage 5: a generic loop with no Euler- or RK4-specific details
# =============================================================================

"""
    solve(problem, algorithm; save_every=1)

Solve the problem with fixed steps. The final step may be shortened to reach `tf`
exactly.
"""
function solve(problem::ODEProblem, algorithm::AbstractStepper; save_every::Integer=1)
    save_every > 0 || throw(ArgumentError("save_every must be positive"))

    nominal_dt = step_size(algorithm)
    start_time, final_time = problem.tspan

    # Match the time type to the step type for the same reason as state preparation.
    time = start_time * one(nominal_dt)
    stop_time = final_time * one(nominal_dt)
    state = _prepare_state(problem.u0, nominal_dt)

    saved_times = typeof(time)[time]
    saved_states = typeof(state)[copy(state)]
    step_number = 0

    while time < stop_time
        # Use a shorter final step when the remaining interval is less than dt.
        actual_dt = min(nominal_dt, stop_time - time)
        state = step(
            problem.f,
            state,
            problem.parameters,
            time,
            actual_dt,
            algorithm,
        )
        time += actual_dt
        step_number += 1

        should_save = step_number % save_every == 0 || time == stop_time
        if should_save
            push!(saved_times, time)
            push!(saved_states, copy(state))
        end
    end

    return ODESolution(saved_times, saved_states, algorithm)
end

# Try it after understanding this file:
# 1. Create `Heun <: AbstractStepper` without modifying `solve`.
# 2. Define its `step_size` and `step` methods in an external file.
# 3. Verify that halving dt reduces the error by about a factor of four.
```

## روابط الفهم

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- [[notes/A48-ode-problem-is-separated-from-solver.idea|A48 - مسألة ODE منفصلة عن طريقة الحل]]
- [[notes/A49-extension-points-add-algorithms-without-changing-solve.idea|A49 - نقاط التوسعة تضيف خوارزمية دون تعديل solve]]
- [[notes/A50-euler-first-order-rk4-fourth-order.idea|A50 - Euler من الرتبة الأولى و RK4 من الرابعة]]
- [[notes/A53-copying-saved-states-prevents-aliasing.idea|A53 - نسخ الحالات المحفوظة يمنع aliasing]]
- [[notes/A54-short-final-step-reaches-final-time.idea|A54 - الخطوة الأخيرة القصيرة تصل إلى الزمن النهائي]]

