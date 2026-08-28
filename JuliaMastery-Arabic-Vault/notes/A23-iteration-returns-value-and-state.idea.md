---
id: A23
aliases:
  - "بروتوكول التكرار يعيد القيمة والحالة"
  - "Iteration protocol"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/interfaces
  - julia/iteration
lesson: 4
source: lessons/04_interfaces_and_iteration.jl
up: "[[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]"
cssclasses:
  - rtl-note
---

# بروتوكول التكرار يعيد القيمة والحالة

## الفكرة

`iterate(sequence, state)` تعيد `(value, next_state)` أو `nothing` عند النهاية. الحالة تخص عملية التكرار ولا يجب أن تكون فهرسًا.

## لماذا تهم؟

يفصل البروتوكول كيفية إنتاج العنصر عن حلقات `for` و`collect`. يمكن تمثيل stream أو متتالية لا تعرف طولها مسبقًا.

## مثال Julia

```julia
struct HalvingSequence{T<:AbstractFloat}
    initial::T
    threshold::T
end

Base.IteratorSize(::Type{<:HalvingSequence}) =
    Base.SizeUnknown()
Base.eltype(::Type{HalvingSequence{T}}) where {T} = T

function Base.iterate(sequence::HalvingSequence,
                      state=sequence.initial)
    state < sequence.threshold && return nothing
    return (state, state / 2)
end

sequence = HalvingSequence(1.0, 0.1)
println(collect(sequence))
```

## كيف تقرأ المثال؟

القيمة الحالية هي أيضًا state التالية بعد قسمتها على اثنين. `SizeUnknown` يخبر `collect` ألا يطلب `length` قبل البدء.

> [!example] تجربة قصيرة
> غيّر العتبة إلى `0.01`، ثم اكتب حلقة `for` تطبع القيم من دون استدعاء `iterate` يدويًا.

> [!question]- سؤال استرجاع
> ما الإشارة التي تعلن انتهاء التكرار؟

> [!success]- الإجابة
> إعادة `nothing` من `iterate`.

## روابط ذات معنى

- الخريطة: [[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]
- الدرس المصدر: [[lessons/L04-interfaces-and-iteration.idea|L04 - الواجهات والتكرار]]
- [[notes/A21-small-interfaces-unlock-generic-behavior.idea|A21 - الواجهة الصغيرة تفتح سلوكا عاما]]
- [[notes/A22-building-a-custom-abstract-vector.idea|A22 - بناء AbstractVector مخصص]]
- [[notes/A24-callable-objects-combine-data-and-behavior.idea|A24 - الكائن القابل للاستدعاء يجمع البيانات والسلوك]]

