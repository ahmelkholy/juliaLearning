---
id: A02
aliases:
  - "التوزيع المتعدد يستخدم جميع أنواع الوسائط"
  - "Multiple dispatch"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/types
  - julia/dispatch
lesson: 1
source: lessons/01_dispatch_and_types.jl
up: "[[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]"
cssclasses:
  - rtl-note
---

# التوزيع المتعدد يستخدم جميع أنواع الوسائط

## الفكرة

اختيار الطريقة في Julia يمكن أن يعتمد على أنواع جميع الوسائط، لا على وسيط أول مميز. لذلك تكون العملية التي تمثل تفاعلًا بين كائنين في مكان طبيعي واحد.

## لماذا تهم؟

عمليات مثل التقاطع، والضرب، وحل مسألة بخوارزمية، لا تنتمي منطقيًا إلى طرف واحد. التوزيع المتعدد يزيل فروع `isa` من قلب الخوارزمية ويجعل التوسعة إضافةً لا تعديلًا.

## مثال Julia

```julia
abstract type Shape end
struct Circle <: Shape end
struct Box <: Shape end

overlaps(::Circle, ::Circle) = "اختبار مسافة المركزين"
overlaps(::Box, ::Box) = "اختبار فصل المجالات"
overlaps(::Shape, ::Shape) = "خوارزمية عامة"

println(overlaps(Circle(), Box()))
println(overlaps(Box(), Box()))
```

## كيف تقرأ المثال؟

النداء الأول يطابق الطريقة العامة فقط، والثاني يطابق العامة والمتخصصة لكن Julia تختار الأكثر تخصيصًا.

> [!example] تجربة قصيرة
> أضف `overlaps(::Circle, ::Box)` ثم لاحظ أن ترتيب تعريف الطرق لا يغيّر الاختيار.

> [!question]- سؤال استرجاع
> لماذا لا نحتاج إلى `if left isa Circle && right isa Box` داخل `overlaps`؟

> [!success]- الإجابة
> لأن جدول الطرق يعبّر عن التركيبات، ويختار dispatch الطريقة المطابقة قبل دخول جسمها.

## روابط ذات معنى

- الخريطة: [[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]
- الدرس المصدر: [[lessons/L01-dispatch-and-types.idea|L01 - التوزيع المتعدد والأنواع]]
- [[notes/A01-methods-belong-to-functions.idea|A01 - الطرق تنتمي إلى الدوال]]
- [[notes/A41-algorithm-objects-replace-central-branches.idea|A41 - كائن الخوارزمية يستبدل الفروع المركزية]]
- [[notes/A49-extension-points-add-algorithms-without-changing-solve.idea|A49 - نقاط التوسعة تضيف خوارزمية دون تعديل solve]]

