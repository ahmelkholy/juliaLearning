---
id: A20
aliases:
  - "الدالة المعدلة توضح ملكية الذاكرة"
  - "Mutating functions"
  - "Bang convention"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/memory
  - julia/interfaces
lesson: 3
source: lessons/03_performance_and_inference.jl
up: "[[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]"
cssclasses:
  - rtl-note
---

# الدالة المعدلة توضح ملكية الذاكرة

## الفكرة

علامة `!` عرف يخبر القارئ أن الدالة قد تعدّل وسيطًا مرئيًا. الوجهة تُنشأ خارج kernel ثم يعاد استخدامها.

## لماذا تهم؟

فصل قرار التخصيص عن الحساب يوضح من يملك الذاكرة ويمنع وسائط مؤقتة غير متوقعة. العلامة ليست أمرًا للمترجم ولا ضمانًا آليًا؛ هي عقد تسمية يجب احترامه.

## مثال Julia

```julia
function affine!(destination, x, scale, offset)
    axes(destination) == axes(x) ||
        throw(DimensionMismatch("axes must match"))
    @. destination = muladd(scale, x, offset)
    return destination
end

x = collect(1.0:4.0)
out = similar(x)
affine!(out, x, 2.0, -1.0)

println(out)
println(x)
```

## كيف تقرأ المثال؟

الدالة تعدل `out` وتعيد الكائن نفسه لتسهيل chaining. لا تعدل `x`. يستطيع المستدعي إعادة استعمال `out` في نداءات كثيرة.

> [!example] تجربة قصيرة
> مرّر view بوصفها `destination` ولاحظ أي جزء من المصفوفة الأم يتغير.

> [!question]- سؤال استرجاع
> هل وجود `!` يجعل الدالة أسرع تلقائيًا؟

> [!success]- الإجابة
> لا. هو يوضح التعديل والملكية؛ السرعة تعتمد على الخوارزمية والتخصيص والتخزين والقياس.

## روابط ذات معنى

- الخريطة: [[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]
- الدرس المصدر: [[lessons/L03-performance-and-type-inference.idea|L03 - الأداء واستدلال الأنواع]]
- [[notes/A10-views-share-memory-slices-copy.idea|A10 - العرض يشارك الذاكرة والشريحة تنسخ]]
- [[notes/A11-dotted-broadcast-fuses-operations.idea|A11 - البث المنقط يدمج العمليات]]
- [[notes/A53-copying-saved-states-prevents-aliasing.idea|A53 - نسخ الحالات المحفوظة يمنع aliasing]]

