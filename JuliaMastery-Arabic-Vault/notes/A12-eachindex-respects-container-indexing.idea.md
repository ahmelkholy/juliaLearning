---
id: A12
aliases:
  - "eachindex يحترم فهرسة الحاوية"
  - "eachindex"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/arrays
  - julia/interfaces
lesson: 2
source: lessons/02_arrays_and_numerics.jl
up: "[[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]"
cssclasses:
  - rtl-note
---

# eachindex يحترم فهرسة الحاوية

## الفكرة

`eachindex` تطلب من الحاويات مجال فهرسة مناسبًا بدل افتراض `1:length(x)`. وعند تمرير عدة حاويات تتحقق من إمكانية المرور المتوافق.

## لماذا تهم؟

ليست كل `AbstractArray` ملزمة بفهرسة خطية تبدأ من 1 بالطريقة التي تتخيلها. الكود العام يحترم الواجهة بدل ربط الخوارزمية بتخزين محدد.

## مثال Julia

```julia
function add_into!(destination, left, right)
    axes(destination) == axes(left) == axes(right) ||
        throw(DimensionMismatch("axes must match"))
    for index in eachindex(destination, left, right)
        destination[index] = left[index] + right[index]
    end
    return destination
end

out = zeros(3)
println(add_into!(out, 1:3, [10, 20, 30]))
```

## كيف تقرأ المثال؟

التحقق من `axes` يعبّر عن العقد، و`eachindex` يختار أسلوب المرور. لا تحتاج الخوارزمية إلى معرفة هل المدخل Vector أم view.

> [!example] تجربة قصيرة
> مرّر view من مصفوفة إلى الدالة، ثم افحص أن النتيجة صحيحة من دون تغيير جسم الحلقة.

> [!question]- سؤال استرجاع
> لماذا قد يكون `1:length(x)` أضيق من اللازم في دالة عامة؟

> [!success]- الإجابة
> لأنه يفترض شكل فهرسة محددًا، بينما `eachindex` يحترم فهرسة ونمط تخزين الحاوية.

## روابط ذات معنى

- الخريطة: [[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]
- الدرس المصدر: [[lessons/L02-arrays-and-generic-numerics.idea|L02 - المصفوفات والحسابات العامة]]
- [[notes/A11-dotted-broadcast-fuses-operations.idea|A11 - البث المنقط يدمج العمليات]]
- [[notes/A21-small-interfaces-unlock-generic-behavior.idea|A21 - الواجهة الصغيرة تفتح سلوكا عاما]]
- [[notes/A22-building-a-custom-abstract-vector.idea|A22 - بناء AbstractVector مخصص]]

