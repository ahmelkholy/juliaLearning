---
id: A45
aliases:
  - "المؤثر دون مصفوفة يقلل الذاكرة"
  - "Matrix-free operator"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/numerics
  - julia/linear-algebra
  - julia/interfaces
lesson: 9
source: lessons/09_algorithm_design.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# المؤثر دون مصفوفة يقلل الذاكرة

## الفكرة

يمكن تمثيل عملية `A*x` بكائن callable من دون بناء مصفوفة `A`. الخوارزمية تطلب واجهة تطبيق المؤثر فقط.

## لماذا تهم؟

لمصفوفة مبنية من stencil أو PDE قد يكون التخزين الكثيف `O(n²)` غير ضروري، بينما التطبيق المباشر يحتاج `O(n)` ذاكرة.

## مثال Julia

```julia
struct ShiftedLaplacian{T<:Real}
    dimension::Int
    shift::T
end

function (A::ShiftedLaplacian)(x::AbstractVector)
    length(x) == A.dimension ||
        throw(DimensionMismatch("dimension mismatch"))
    y = similar(x, promote_type(eltype(x), typeof(A.shift)))
    for i in eachindex(x)
        left = i == firstindex(x) ? zero(eltype(x)) : x[i-1]
        right = i == lastindex(x) ? zero(eltype(x)) : x[i+1]
        y[i] = (2 + A.shift) * x[i] - left - right
    end
    return y
end

A = ShiftedLaplacian(5, 0.1)
println(A(ones(5)))
```

## كيف تقرأ المثال؟

الكائن يخزن البعد والإزاحة فقط. عند النداء يحسب أثر المصفوفة ثلاثية القطر عنصرًا عنصرًا.

> [!example] تجربة قصيرة
> ارفع البعد إلى مليون وافحص أن إنشاء المؤثر نفسه لا يبني مصفوفة مليون في مليون.

> [!question]- سؤال استرجاع
> ما الواجهة الدنيا التي يحتاجها محلّل iterative من هذا المؤثر؟

> [!success]- الإجابة
> أن يستطيع تطبيقه على متجه والحصول على `A*x` بنوع وأبعاد متوافقة.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]
- [[notes/A24-callable-objects-combine-data-and-behavior.idea|A24 - الكائن القابل للاستدعاء يجمع البيانات والسلوك]]
- [[notes/A46-conjugate-gradient-requires-positive-definite-operator.idea|A46 - Conjugate Gradient يحتاج مؤثرا موجبا]]
- [[notes/A47-relative-residual-measures-solution-quality.idea|A47 - المتبقي النسبي يقيس جودة الحل]]

