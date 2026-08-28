---
id: L03
aliases:
  - "الدرس 3: الأداء واستدلال الأنواع"
type: source-note
status: complete
tags:
  - course/lesson
  - course/lesson-03
  - julia
lesson: 3
source: lessons/03_performance_and_inference.jl
up: "[[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]"
cssclasses:
  - rtl-note
---

# الدرس 3: الأداء واستدلال الأنواع

> [!goal] هدف الدرس
> أن تفصل الاختيار الديناميكي عن kernel ملموسة، وتفحص الاستقرار النوعي، وتقيس بعد التسخين.

## قبل التشغيل

توقع أي نوع من `AbstractFieldKernel` و`ParametricKernel` يكشف نوع المتجه في `typeof`.

## شبكة المفاهيم

- [[notes/A16-parametric-fields-expose-types.idea|A16 - الحقل البارامتري يكشف النوع للمترجم]]
- [[notes/A17-type-stability-enables-inference.idea|A17 - الاستقرار النوعي يجعل النتيجة قابلة للاستدلال]]
- [[notes/A18-function-barriers-isolate-dynamic-decisions.idea|A18 - حاجز الدالة يعزل القرار الديناميكي]]
- [[notes/A19-warm-up-before-performance-measurement.idea|A19 - التسخين يسبق قياس الأداء]]
- [[notes/A20-mutating-functions-clarify-memory-ownership.idea|A20 - الدالة المعدلة توضح ملكية الذاكرة]]

## شغّل الدرس

من جذر المستودع:

```bash
julia --project=. lessons/03_performance_and_inference.jl
```

## مسار التنفيذ

يقارن الدرس حقلًا مجردًا بآخر بارامتري، ثم يضع قرار نوع البيانات أمام function barrier، ويعرض kernel مستقرة وحلقة مصفوفة توافق التخزين العمودي.

## الكود الكامل

```julia
module Lesson03PerformanceAndInference

# With an abstract field, the compiler may need to discover the concrete type at
# runtime. A parametric type records the vector's concrete type in the object type.
struct AbstractFieldKernel
    coefficients::AbstractVector
end

struct ParametricKernel{V<:AbstractVector}
    coefficients::V
end

(kernel::AbstractFieldKernel)(x) = sum(kernel.coefficients .* x)
(kernel::ParametricKernel)(x) = sum(kernel.coefficients .* x)

# A dynamic decision at the program boundary is fine. A function barrier passes
# its concrete result into a small kernel that the compiler can specialize.
function load_values(kind::Symbol, count::Integer)
    kind === :f32 && return fill(Float32(0.25), count)
    kind === :f64 && return fill(0.25, count)
    throw(ArgumentError("kind must be :f32 or :f64"))
end

sum_squares(kind, count) = sum_squares_kernel(load_values(kind, count))

function sum_squares_kernel(values)
    accumulator = zero(eltype(values))
    @inbounds @simd for index in eachindex(values)
        accumulator += abs2(values[index])
    end
    return accumulator
end

# Because storage is column-major, rows belong in the inner loop. This function
# mutates its input so memory allocation remains outside the numerical kernel.
function scale_columns!(matrix, scales)
    size(matrix, 2) == length(scales) || throw(DimensionMismatch("one scale per column required"))
    @inbounds for column in axes(matrix, 2)
        scale = scales[column]
        @simd for row in axes(matrix, 1)
            matrix[row, column] *= scale
        end
    end
    return matrix
end

function main()
    values = rand(10_000)
    abstract_kernel = AbstractFieldKernel(values)
    parametric_kernel = ParametricKernel(values)

    # The first call may compile code, so warm up the same method before measuring.
    abstract_kernel(values)
    parametric_kernel(values)
    abstract_bytes = @allocated abstract_kernel(values)
    parametric_bytes = @allocated parametric_kernel(values)

    @assert abstract_kernel(values) ≈ parametric_kernel(values)
    @assert sum_squares(:f32, 8) isa Float32
    @assert sum_squares(:f64, 8) isa Float64

    matrix = ones(4, 3)
    scale_columns!(matrix, [1.0, 2.0, 3.0])
    @assert matrix[:, 3] == fill(3.0, 4)

    println("Allocation with an abstract field: ", abstract_bytes, " bytes")
    println("Allocation with a parametric field: ", parametric_bytes, " bytes")
    println("Try this: @code_warntype sum_squares_kernel(rand(100))")
    println("For a serious benchmark, warm up the method and interpolate inputs with BenchmarkTools.")
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
```

## تجارب مقصودة

- شغّل `@code_warntype sum_squares_kernel(rand(100))`.
- أضف خيار `:big` إلى `load_values` من دون تعديل kernel.
- بدّل ترتيب حلقات `scale_columns!` ثم قس قياسًا عادلًا.

> [!question]- اختبار استرجاع
> لماذا لا ينبغي أخذ النداء الأول بوصفه زمن التنفيذ المستقر؟

> [!success]- الإجابة
> لأنه قد يشمل ترجمة method المتخصصة، وهي كلفة لا تتكرر بالطريقة نفسها.

## الملاحة

- الخريطة الأعلى: [[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]
- الدرس التالي: [[lessons/L04-interfaces-and-iteration.idea|L04 - الواجهات والتكرار]]

