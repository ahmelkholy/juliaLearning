---
id: A06
aliases:
  - "الترقية تحافظ على الحساب العام"
  - "Promotion"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/types
  - julia/numerics
lesson: 1
source: lessons/01_dispatch_and_types.jl
up: "[[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]"
cssclasses:
  - rtl-note
---

# الترقية تحافظ على الحساب العام

## الفكرة

الترقية `promote` أو `promote_type` تختار نوعًا مشتركًا متوافقًا عندما تتفاعل قيم من أنواع مختلفة، بدل تحويل كل شيء يدويًا إلى `Float64`.

## لماذا تهم؟

إجبار `Float64` يفقد `Float32` و`BigFloat` والأعداد المركبة وأنواع المستخدم. الترقية تتبع قواعد النظام العددي وتبقي الدالة عامة.

## مثال Julia

```julia
println(promote(1, 2.5))
println(promote_type(Int, Float32))
println(promote_type(Float64, BigFloat))

x, y = promote(1, big"0.25")
println((typeof(x), typeof(y), x + y))
```

## كيف تقرأ المثال؟

`promote` يحول القيم فعليًا، بينما `promote_type` يعيد النوع المشترك فقط. لا تفترض أن النوع المشترك دائمًا `Float64`.

> [!example] تجربة قصيرة
> جرّب `promote(1.0f0, 2)` ثم `promote(1.0, big"2")`، واكتب توقعك قبل التنفيذ.

> [!question]- سؤال استرجاع
> ما العيب التصميمي في كتابة `Float64(value)` داخل كل خوارزمية عامة؟

> [!success]- الإجابة
> تفرض دقة ونوعًا على المستخدم وتكسر العمل مع أنواع عددية أخرى؛ الترقية تختار نوعًا مشتركًا وفق القواعد.

## روابط ذات معنى

- الخريطة: [[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]
- الدرس المصدر: [[lessons/L01-dispatch-and-types.idea|L01 - التوزيع المتعدد والأنواع]]
- [[notes/A04-parametric-types-store-type-information.idea|A04 - الأنواع البارامترية تحمل معلومات في النوع]]
- [[notes/A15-generic-arithmetic-does-not-force-float64.idea|A15 - الحساب العام لا يفرض Float64]]
- [[notes/A50-euler-first-order-rk4-fourth-order.idea|A50 - Euler من الرتبة الأولى و RK4 من الرابعة]]

