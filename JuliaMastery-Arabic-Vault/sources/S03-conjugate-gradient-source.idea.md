---
id: S03
aliases:
  - "كود Conjugate Gradient"
type: source-note
status: complete
tags:
  - source/code
  - julia
source: src/iterative_solvers.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# كود Conjugate Gradient


## غرض الملف

هذا التطبيق الكامل لـ CG يوضح واجهة المؤثر، واختيار نوع الحساب، والتسامح، والخروج المبكر، وnumerical breakdown، وتقرير عدم التقارب.

## أسئلة توجه القراءة

1. لماذا تستعمل الخوارزمية `real(dot(...))`؟
2. ما الفرق بين رمي `ConvergenceError` وإعادة `converged=false`؟
3. كيف يعمل المؤثر callable من دون فرع داخل الحلقة؟

## الكود الكامل

```julia
# =============================================================================
# Conjugate Gradient, explained one stage at a time
# =============================================================================

# CG solves A*x=b when A is symmetric or Hermitian positive definite. A does not
# need to be stored as a matrix; any callable object that implements `operator(x)` works.

"""Report numerical breakdown instead of returning a misleading result."""
struct ConvergenceError <: Exception
    message::String
end

Base.showerror(io::IO, error::ConvergenceError) = print(io, error.message)

"""The solution together with its residual, iteration count, and convergence flag."""
struct CGResult{V,T<:Real}
    x::V
    residual_norm::T
    iterations::Int
    converged::Bool
end

# Dispatch keeps a type check out of the loop: a matrix uses multiplication and
# another callable uses `operator(x)`. This is the complete interface CG needs.
_apply_operator(operator::AbstractMatrix, x) = operator * x
_apply_operator(operator, x) = operator(x)

"""
    cg(operator, b; x0=nothing, rtol=nothing, atol=0, maxiter=nothing)

Solve `operator*x = b` with the Conjugate Gradient method. The loop's variable
names closely follow the mathematical algorithm.
"""
function cg(operator, b::AbstractVector; x0=nothing, rtol=nothing, atol=0, maxiter=nothing)
    # -------------------------------------------------------------------------
    # 1. Select the working number type and validate inputs
    # -------------------------------------------------------------------------
    number_type = float(eltype(b))
    real_type = typeof(real(zero(number_type)))
    relative_tolerance = isnothing(rtol) ? sqrt(eps(real_type)) : rtol
    maximum_iterations = isnothing(maxiter) ? 10 * length(b) : maxiter

    maximum_iterations >= 0 || throw(ArgumentError("maxiter must be nonnegative"))
    relative_tolerance >= 0 || throw(ArgumentError("rtol must be nonnegative"))
    atol >= 0 || throw(ArgumentError("atol must be nonnegative"))

    right_hand_side = number_type.(b)
    x = isnothing(x0) ? zeros(number_type, length(b)) : number_type.(x0)
    length(x) == length(b) || throw(DimensionMismatch("x0 and b must have equal length"))

    # -------------------------------------------------------------------------
    # 2. Compute the initial state
    # -------------------------------------------------------------------------
    residual = right_hand_side - _apply_operator(operator, x) # r = b - A*x
    direction = copy(residual)                                # Initially, p = r.
    residual_squared = real(dot(residual, residual))          # rᵀr
    residual_norm = sqrt(residual_squared)
    target = max(atol, relative_tolerance * norm(right_hand_side))

    # Return immediately when x0 already satisfies the requested tolerance.
    residual_norm <= target && return CGResult(x, residual_norm, 0, true)

    # -------------------------------------------------------------------------
    # 3. Main iteration
    # -------------------------------------------------------------------------
    for iteration in 1:maximum_iterations
        operator_direction = _apply_operator(operator, direction)
        denominator = real(dot(direction, operator_direction))

        # For a positive-definite operator, p'Ap must be positive.
        denominator > zero(denominator) ||
            throw(ConvergenceError("operator is not positive definite at iteration $iteration"))

        alpha = residual_squared / denominator
        @. x = x + alpha * direction
        @. residual = residual - alpha * operator_direction

        next_residual_squared = real(dot(residual, residual))
        residual_norm = sqrt(next_residual_squared)
        residual_norm <= target && return CGResult(x, residual_norm, iteration, true)

        beta = next_residual_squared / residual_squared
        @. direction = residual + beta * direction
        residual_squared = next_residual_squared
    end

    # Missing the tolerance is not always exceptional. Return the best available
    # result with `converged=false` so the caller can decide what to do.
    return CGResult(x, residual_norm, maximum_iterations, false)
end

# Try it yourself:
# 1. Run `cg` with a matrix, then with `x -> matrix * x`.
# 2. Pass `maxiter=1` and inspect `converged=false`.
# 3. Pass a non-positive-definite matrix and explain the `ConvergenceError`.
```

## روابط الفهم

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- [[notes/A45-matrix-free-operators-reduce-memory.idea|A45 - المؤثر دون مصفوفة يقلل الذاكرة]]
- [[notes/A46-conjugate-gradient-requires-positive-definite-operator.idea|A46 - Conjugate Gradient يحتاج مؤثرا موجبا]]
- [[notes/A47-relative-residual-measures-solution-quality.idea|A47 - المتبقي النسبي يقيس جودة الحل]]
- [[notes/A40-numerical-tolerances-follow-algorithm-accuracy.idea|A40 - التسامح العددي مشتق من دقة الخوارزمية]]

