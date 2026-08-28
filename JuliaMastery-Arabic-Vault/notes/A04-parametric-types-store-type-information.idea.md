---
id: A04
aliases:
  - "الأنواع البارامترية تحمل معلومات في النوع"
  - "Parametric types"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/types
lesson: 1
source: lessons/01_dispatch_and_types.jl
up: "[[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]"
cssclasses:
  - rtl-note
---

# الأنواع البارامترية تحمل معلومات في النوع

## الفكرة

النوع البارامتري يجعل معلومات مثل نوع العدد أو البعد جزءًا من هوية النوع. يستطيع التوزيع والمترجم استعمال هذه المعلومات من دون تخزينها كحقول متكررة.

## لماذا تهم؟

يمثل `Point{N,T}` نقطة بعدد إحداثيات معلوم ونوع عناصر معلوم. يمنع التوقيع جمع نقطتين مختلفتي البعد، ويمنح المترجم tuple بطول ثابت.

## مثال Julia

```julia
struct Point{N,T<:Real}
    coordinates::NTuple{N,T}
end

Point(values::Vararg{T,N}) where {T<:Real,N} =
    Point{N,T}(values)

p2 = Point(1.0, 2.0)
p3 = Point(1, 2, 3)

println(typeof(p2))
println(typeof(p3))
```

## كيف تقرأ المثال؟

`N` قيمة صحيحة داخل النوع، و`T` نوع. لذلك `Point{2,Float64}` و`Point{3,Int}` نوعان ملموسان مختلفان.

> [!example] تجربة قصيرة
> أنشئ نقاطًا من `Float32` و`BigFloat` وافحص `typeof`. ثم اكتب دالة تقبل `Point{2}` فقط.

> [!question]- سؤال استرجاع
> ما المعلومتان اللتان تحفظهما `Point{N,T}` في النوع نفسه؟

> [!success]- الإجابة
> عدد الإحداثيات `N` ونوع الإحداثي `T`.

## روابط ذات معنى

- الخريطة: [[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]
- الدرس المصدر: [[lessons/L01-dispatch-and-types.idea|L01 - التوزيع المتعدد والأنواع]]
- [[notes/A03-abstract-families-concrete-data.idea|A03 - النوع المجرد عائلة والنوع الملموس بيانات]]
- [[notes/A06-promotion-preserves-generic-arithmetic.idea|A06 - الترقية تحافظ على الحساب العام]]
- [[notes/A16-parametric-fields-expose-types.idea|A16 - الحقل البارامتري يكشف النوع للمترجم]]

