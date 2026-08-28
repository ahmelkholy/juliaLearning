---
id: L09
aliases:
  - "الدرس 9: تصميم الخوارزميات"
type: source-note
status: complete
tags:
  - course/lesson
  - course/lesson-09
  - julia
lesson: 9
source: lessons/09_algorithm_design.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# الدرس 9: تصميم الخوارزميات

> [!goal] هدف الدرس
> أن ترى كيف تتحول المعرفة العددية إلى أنواع وواجهات وعقود قابلة للاختبار.

## قبل التشغيل

احسب `[1e16, 1.0, -1e16]` من اليسار في floating point وتوقع فرق الجمع المعوض.

## شبكة المفاهيم

- [[notes/A41-algorithm-objects-replace-central-branches.idea|A41 - كائن الخوارزمية يستبدل الفروع المركزية]]
- [[notes/A42-compensated-summation-recovers-lost-parts.idea|A42 - الجمع المعوض يستعيد الأجزاء المفقودة]]
- [[notes/A43-welford-computes-online-variance.idea|A43 - خوارزمية Welford تحسب التباين على الإنترنت]]
- [[notes/A44-log-sum-exp-prevents-overflow.idea|A44 - log-sum-exp يمنع الفيضان]]
- [[notes/A45-matrix-free-operators-reduce-memory.idea|A45 - المؤثر دون مصفوفة يقلل الذاكرة]]
- [[notes/A46-conjugate-gradient-requires-positive-definite-operator.idea|A46 - Conjugate Gradient يحتاج مؤثرا موجبا]]
- [[notes/A47-relative-residual-measures-solution-quality.idea|A47 - المتبقي النسبي يقيس جودة الحل]]

## شغّل الدرس

من جذر المستودع:

```bash
julia --project=. lessons/09_algorithm_design.jl
```

## مسار التنفيذ

يجمع الدرس algorithm objects، وNeumaier، وWelford، وlog-sum-exp، ثم يبني Laplacian callable ويحلها بـ CG من دون مصفوفة كثيفة.

## الكود الكامل

```julia
module Lesson09AlgorithmDesign

using LinearAlgebra
using JuliaMastery: cg

# Represent an algorithm choice with a fieldless type. The operation name stays
# fixed while dispatch chooses the implementation, avoiding a growing Symbol switch.
abstract type SummationAlgorithm end
struct NativeSum <: SummationAlgorithm end
struct CompensatedSum <: SummationAlgorithm end

accurate_sum(values, ::NativeSum) = sum(values)

# Neumaier compensation recovers small terms lost during floating-point addition.
# It is more robust than basic Kahan summation when a new term exceeds the total.
function accurate_sum(values, ::CompensatedSum)
    T = float(eltype(values))
    total = zero(T)
    correction = zero(T)
    for raw_value in values
        value = convert(T, raw_value)
        next_total = total + value
        if abs(total) >= abs(value)
            correction += (total - next_total) + value
        else
            correction += (value - next_total) + total
        end
        total = next_total
    end
    return total + correction
end

# Welford's method computes variance online without storing samples and avoids
# cancellation in `E[x^2] - E[x]^2`. Immutable state also has clear ownership.
struct RunningVariance{T<:AbstractFloat}
    count::Int
    mean::T
    m2::T
end

RunningVariance(::Type{T}=Float64) where {T<:AbstractFloat} = RunningVariance(0, zero(T), zero(T))

function update(statistic::RunningVariance{T}, sample) where {T}
    value = convert(T, sample)
    count = statistic.count + 1
    delta = value - statistic.mean
    mean = statistic.mean + delta / count
    m2 = statistic.m2 + delta * (value - mean)
    return RunningVariance(count, mean, m2)
end

function sample_variance(statistic::RunningVariance)
    statistic.count >= 2 || throw(ArgumentError("at least two samples are required"))
    return statistic.m2 / (statistic.count - 1)
end

# Log-sum-exp subtracts the largest value before `exp` to avoid overflow. Handle
# infinity explicitly because `Inf - Inf` produces NaN.
function logsumexp(values)
    isempty(values) && throw(ArgumentError("values cannot be empty"))
    maximum_value = maximum(values)
    maximum_value == Inf && return maximum_value
    maximum_value == -Inf && return maximum_value
    return maximum_value + log(sum(value -> exp(value - maximum_value), values))
end

# This callable object represents a positive-definite tridiagonal matrix without
# building it. CG only needs `operator(x)`: a small interface with lower memory use.
struct ShiftedLaplacian{T<:Real}
    dimension::Int
    shift::T
end

function (operator::ShiftedLaplacian)(x::AbstractVector)
    length(x) == operator.dimension || throw(DimensionMismatch("operator dimension mismatch"))
    output = similar(x, promote_type(eltype(x), typeof(operator.shift)))
    @inbounds for index in eachindex(x)
        left = index == firstindex(x) ? zero(eltype(x)) : x[index - 1]
        right = index == lastindex(x) ? zero(eltype(x)) : x[index + 1]
        output[index] = (2 + operator.shift) * x[index] - left - right
    end
    return output
end

function main()
    difficult_values = [1.0e16, 1.0, -1.0e16]
    @assert accurate_sum(difficult_values, NativeSum()) == 0.0
    @assert accurate_sum(difficult_values, CompensatedSum()) == 1.0

    statistic = foldl(update, [1.0, 2.0, 3.0, 4.0]; init=RunningVariance())
    @assert statistic.mean ≈ 2.5
    @assert sample_variance(statistic) ≈ 5 / 3
    @assert logsumexp([1_000.0, 1_001.0]) ≈ 1_001 + log1p(exp(-1))

    operator = ShiftedLaplacian(200, 0.1)
    rhs = ones(200)
    result = cg(operator, rhs; rtol=1e-10, maxiter=400)
    @assert result.converged
    @assert norm(operator(result.x) - rhs) / norm(rhs) < 1e-9

    println("Native and compensated sums: ", (accurate_sum(difficult_values, NativeSum()), accurate_sum(difficult_values, CompensatedSum())))
    println("Online mean and variance: ", (statistic.mean, sample_variance(statistic)))
    println("CG iterations without a stored matrix: ", result.iterations)
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
```

## تجارب مقصودة

- بدّل ترتيب قيم الجمع الصعبة.
- ارفع بعد المؤثر إلى قيمة كبيرة وافحص الذاكرة.
- تحقق من CG عبر residual نسبي مستقل.

> [!question]- اختبار استرجاع
> ما الواجهة الوحيدة التي يحتاجها CG من المؤثر matrix-free؟

> [!success]- الإجابة
> تطبيق المؤثر على متجه وإعادة `A*x` بأبعاد ونوع متوافقين.

## الملاحة

- الخريطة الأعلى: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس التالي: [[lessons/L10-scientific-capstone.idea|L10 - المشروع العلمي الختامي]]

