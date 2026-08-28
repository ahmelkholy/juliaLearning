---
id: A15
aliases:
  - "الحساب العام لا يفرض Float64"
  - "Generic arithmetic"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/numerics
  - julia/types
lesson: 2
source: lessons/02_arrays_and_numerics.jl
up: "[[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]"
cssclasses:
  - rtl-note
---

# الحساب العام لا يفرض Float64

## الفكرة

الدالة العددية العامة تطلب العمليات التي تحتاجها ولا تقيد المدخل بـ `Float64` بلا سبب. تستعمل `zero` و`one` و`eltype` والترقية للحفاظ على اختيارات المستخدم.

## لماذا تهم؟

هذا يتيح العمل مع `Float32` و`BigFloat` و`Complex` وdual numbers وأنواع جديدة. العمومية هنا ليست تجميلًا؛ هي قدرة على تغيير الدقة والنموذج.

## مثال Julia

```julia
function horner(coefficients, x)
    isempty(coefficients) && return zero(x)
    accumulator = last(coefficients) * one(x)
    for coefficient in Iterators.reverse(coefficients[begin:end-1])
        accumulator = muladd(accumulator, x, coefficient)
    end
    return accumulator
end

println(horner([1, 2, 3], 2))
println(horner(BigFloat[1, 2, 3], big"0.25"))
println(horner(ComplexF64[1, 2], 1im))
```

## كيف تقرأ المثال؟

`one(x)` يهيئ الحساب بنوع متوافق مع `x`. المثال تعليمي؛ كود المستودع يستعمل الفهارس لتجنب نسخة slice في الحلقة.

> [!example] تجربة قصيرة
> مرّر معاملات `Float32` و`x::Float32`، ثم افحص `typeof` للنتيجة قبل إضافة أي تحويل يدوي.

> [!question]- سؤال استرجاع
> متى يكون تقييد وسيط بـ `Vector{Float64}` مبررًا؟

> [!success]- الإجابة
> عندما تحتاج الخوارزمية فعلًا ذلك التخزين والنوع المحددين، لا لمجرد اعتقاد أن annotation تسرّع الكود.

## روابط ذات معنى

- الخريطة: [[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]
- الدرس المصدر: [[lessons/L02-arrays-and-generic-numerics.idea|L02 - المصفوفات والحسابات العامة]]
- [[notes/A06-promotion-preserves-generic-arithmetic.idea|A06 - الترقية تحافظ على الحساب العام]]
- [[notes/A12-eachindex-respects-container-indexing.idea|A12 - eachindex يحترم فهرسة الحاوية]]
- [[notes/A40-numerical-tolerances-follow-algorithm-accuracy.idea|A40 - التسامح العددي مشتق من دقة الخوارزمية]]

