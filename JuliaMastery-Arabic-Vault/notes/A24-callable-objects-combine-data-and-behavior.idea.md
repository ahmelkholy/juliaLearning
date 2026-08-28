---
id: A24
aliases:
  - "الكائن القابل للاستدعاء يجمع البيانات والسلوك"
  - "Callable objects"
  - "Functors"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/interfaces
  - julia/design
lesson: 4
source: lessons/04_interfaces_and_iteration.jl
up: "[[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]"
cssclasses:
  - rtl-note
---

# الكائن القابل للاستدعاء يجمع البيانات والسلوك

## الفكرة

يصبح الكائن قابلًا للاستدعاء عند تعريف طريقة للأقواس على نوعه. يحمل parameters في حقول ملموسة ويستعمل بواجهة دالة خفيفة.

## لماذا تهم؟

النمط مناسب للنماذج والمؤثرات والـ callbacks ذات الحالة. يمنح المترجم نوعًا يحمل البيانات ويمنح المستخدم صياغة `model(x)`.

## مثال Julia

```julia
struct AffineMap{A,B}
    scale::A
    offset::B
end

(map::AffineMap)(x) =
    muladd(map.scale, x, map.offset)

transform = AffineMap(2.0, -1.0)

println(transform(3.0))
println(transform.([0.0, 1.0, 2.0]))
```

## كيف تقرأ المثال؟

الأقواس ليست حكرًا على `Function`. `transform` كائن من `AffineMap` لكنه يستجيب للنداء والبث كأي callable.

> [!example] تجربة قصيرة
> أضف حقلًا `calls::Ref{Int}` إلى نسخة mutable وسجّل عدد النداءات، ثم ناقش أثر الحالة mutable على التزامن.

> [!question]- سؤال استرجاع
> ما الذي يميّز callable object عن closure بسيطة في التصميم؟

> [!success]- الإجابة
> له نوع صريح وحقول مسماة يمكن التوزيع عليها وفحصها وتوثيقها، مع بقاء واجهة الاستدعاء بسيطة.

## روابط ذات معنى

- الخريطة: [[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]
- الدرس المصدر: [[lessons/L04-interfaces-and-iteration.idea|L04 - الواجهات والتكرار]]
- [[notes/A21-small-interfaces-unlock-generic-behavior.idea|A21 - الواجهة الصغيرة تفتح سلوكا عاما]]
- [[notes/A41-algorithm-objects-replace-central-branches.idea|A41 - كائن الخوارزمية يستبدل الفروع المركزية]]
- [[notes/A45-matrix-free-operators-reduce-memory.idea|A45 - المؤثر دون مصفوفة يقلل الذاكرة]]

