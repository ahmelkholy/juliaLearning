---
id: S05
aliases:
  - "الحلول المرجعية المتقدمة"
type: source-note
status: complete
tags:
  - source/code
  - julia
source: solutions/advanced_solutions.jl
up: "[[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]"
cssclasses:
  - rtl-note
---

# الحلول المرجعية المتقدمة


> [!danger] تنبيه حرق الحل
> أغلق هذه الملاحظة إذا لم تحاول التمارين بعد. الفهم يأتي من قرارك الأول ثم المقارنة، لا من نسخ المرجع.

## غرض الملف

هذه ملاحظة spoiler تحتوي الحلول المرجعية كاملة. لا تستخدمها بوصفها جوابًا وحيدًا؛ قارن العقود والملكية والاستدلال بعد إكمال نسختك.

## أسئلة توجه القراءة

1. ما القرارات التي اتخذها الحل حول المدخل الفارغ وامتلاء CircularBuffer؟
2. هل تستطيع اقتراح تصميم مختلف يحافظ على العقد؟

## الكود الكامل

```julia
module AdvancedSolutions

using LinearAlgebra
import JuliaMastery
using JuliaMastery: AbstractStepper, ODEProblem, solve, step, step_size

function pairwise_sum(values::AbstractVector; cutoff::Integer=128)
    cutoff > 0 || throw(ArgumentError("cutoff must be positive"))
    isempty(values) && return zero(eltype(values))
    return _pairwise_sum(values, firstindex(values), lastindex(values), cutoff)
end

function _pairwise_sum(values, first_index, last_index, cutoff)
    length = last_index - first_index + 1
    if length <= cutoff
        accumulator = zero(eltype(values))
        @inbounds for index in first_index:last_index
            accumulator += values[index]
        end
        return accumulator
    end

    midpoint = first_index + length ÷ 2 - 1
    return _pairwise_sum(values, first_index, midpoint, cutoff) +
           _pairwise_sum(values, midpoint + 1, last_index, cutoff)
end

struct Heun{T<:Real} <: AbstractStepper
    dt::T

    function Heun(dt::T) where {T<:Real}
        isfinite(dt) && dt > zero(T) || throw(ArgumentError("dt must be positive and finite"))
        return new{T}(dt)
    end
end

JuliaMastery.step_size(algorithm::Heun) = algorithm.dt

function JuliaMastery.step(f, state, parameters, time, step_width, ::Heun)
    first_slope = f(state, parameters, time)
    predictor = state + step_width * first_slope
    second_slope = f(predictor, parameters, time + step_width)
    return state + (step_width / 2) * (first_slope + second_slope)
end

struct EigenResult{V,T,R<:Real}
    vector::V
    value::T
    residual_norm::R
    iterations::Int
    converged::Bool
end

apply_operator(operator::AbstractMatrix, vector) = operator * vector
apply_operator(operator, vector) = operator(vector)

function power_iteration(operator, initial; tolerance=1e-10, maxiter::Integer=1_000)
    tolerance >= 0 || throw(ArgumentError("tolerance must be nonnegative"))
    maxiter >= 0 || throw(ArgumentError("maxiter must be nonnegative"))
    norm(initial) > 0 || throw(ArgumentError("initial vector cannot be zero"))

    vector = float.(initial) / norm(initial)
    image = apply_operator(operator, vector)
    eigenvalue = dot(vector, image)
    residual_norm = norm(image - eigenvalue * vector)

    for iteration in 1:maxiter
        vector = image / norm(image)
        image = apply_operator(operator, vector)
        eigenvalue = dot(vector, image)
        residual_norm = norm(image - eigenvalue * vector)
        residual_norm <= tolerance &&
            return EigenResult(vector, eigenvalue, residual_norm, iteration, true)
    end

    return EigenResult(vector, eigenvalue, residual_norm, maxiter, false)
end

mutable struct CircularBuffer{T} <: AbstractVector{T}
    storage::Vector{T}
    first_slot::Int
    count::Int
end

function CircularBuffer{T}(capacity::Integer) where {T}
    capacity > 0 || throw(ArgumentError("capacity must be positive"))
    return CircularBuffer(Vector{T}(undef, capacity), 1, 0)
end

Base.size(buffer::CircularBuffer) = (buffer.count,)
Base.IndexStyle(::Type{<:CircularBuffer}) = IndexLinear()

function Base.getindex(buffer::CircularBuffer, index::Int)
    @boundscheck checkbounds(buffer, index)
    slot = mod1(buffer.first_slot + index - 1, length(buffer.storage))
    return @inbounds buffer.storage[slot]
end

function Base.push!(buffer::CircularBuffer{T}, value) where {T}
    converted_value = convert(T, value)
    capacity = length(buffer.storage)
    if buffer.count < capacity
        slot = mod1(buffer.first_slot + buffer.count, capacity)
        buffer.storage[slot] = converted_value
        buffer.count += 1
    else
        buffer.storage[buffer.first_slot] = converted_value
        buffer.first_slot = mod1(buffer.first_slot + 1, capacity)
    end
    return buffer
end

function main()
    @assert pairwise_sum(collect(1:100)) == 5_050

    problem = ODEProblem((state, _, _) -> -2state, 1.0, (0.0, 1.0))
    result = solve(problem, Heun(0.01))
    @assert isapprox(result.u[end], exp(-2); rtol=2e-4)

    matrix = [4.0 1.0; 1.0 2.0]
    eigen_result = power_iteration(matrix, [1.0, 1.0])
    @assert eigen_result.converged
    @assert norm(matrix * eigen_result.vector - eigen_result.value * eigen_result.vector) < 1e-9

    buffer = CircularBuffer{Float64}(3)
    foreach(value -> push!(buffer, value), 1:5)
    @assert collect(buffer) == [3.0, 4.0, 5.0]
    @assert sum(buffer) == 12.0

    println("Advanced reference solutions passed. Compare them with your design; do not memorize them.")
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
```

## روابط الفهم

- الخريطة: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]
- [[sources/S04-advanced-exercises-source.idea|S04 - كود التمارين المتقدمة الأصلي]]
- [[notes/A49-extension-points-add-algorithms-without-changing-solve.idea|A49 - نقاط التوسعة تضيف خوارزمية دون تعديل solve]]
- [[notes/A22-building-a-custom-abstract-vector.idea|A22 - بناء AbstractVector مخصص]]
- [[notes/A47-relative-residual-measures-solution-quality.idea|A47 - المتبقي النسبي يقيس جودة الحل]]

