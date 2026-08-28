---
id: A08
aliases:
  - "غموض الطرق يحل بتعريف التقاطع"
  - "Method ambiguity"
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

# غموض الطرق يحل بتعريف التقاطع

## الفكرة

يحدث الغموض عندما تنطبق طريقتان ولا تكون إحداهما أكثر تخصيصًا بالكامل من الأخرى. الحل هو تعريف طريقة للتقاطع المقصود، لا الاعتماد على ترتيب التعريف.

## لماذا تهم؟

الغموض يكشف أن API لم تحدد معنى تركيبة أنواع معينة. تعريف التقاطع يوثق القرار ويجعله مستقرًا عند إضافة طرق أخرى.

## مثال Julia

```julia
relation(::Real, ::Integer) = :right_discrete
relation(::Integer, ::Real) = :left_discrete

# من دون السطر التالي يكون relation(1, 2) غامضًا
relation(::Integer, ::Integer) = :both_discrete

println(relation(1.5, 2))
println(relation(1, 2.5))
println(relation(1, 2))
```

## كيف تقرأ المثال؟

عند `(Integer,Integer)` تكون الطريقة الأولى أخص في الوسيط الثاني، والثانية أخص في الأول؛ لا توجد فائزة. الطريقة الثالثة أخص في الاثنين.

> [!example] تجربة قصيرة
> علّق طريقة التقاطع وشغّل `relation(1, 2)`. اقرأ توقيعي المرشحين في رسالة الخطأ ثم أعدها.

> [!question]- سؤال استرجاع
> هل الطريقة المعرفة أخيرًا تفوز عند الغموض؟

> [!success]- الإجابة
> لا. ترتيب التعريف ليس قاعدة اختيار؛ يجب تعريف التقاطع أو إعادة تصميم التواقيع.

## روابط ذات معنى

- الخريطة: [[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]
- الدرس المصدر: [[lessons/L01-dispatch-and-types.idea|L01 - التوزيع المتعدد والأنواع]]
- [[notes/A01-methods-belong-to-functions.idea|A01 - الطرق تنتمي إلى الدوال]]
- [[notes/A02-multiple-dispatch-uses-all-arguments.idea|A02 - التوزيع المتعدد يستخدم جميع أنواع الوسائط]]
- [[notes/A34-using-import-export-define-api-boundaries.idea|A34 - using و import و export تحدد حدود API]]

