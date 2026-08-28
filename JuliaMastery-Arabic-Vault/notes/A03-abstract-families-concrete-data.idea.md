---
id: A03
aliases:
  - "النوع المجرد عائلة والنوع الملموس بيانات"
  - "Abstract and concrete types"
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

# النوع المجرد عائلة والنوع الملموس بيانات

## الفكرة

النوع المجرد يجمع عائلة ذات معنى ولا يحدد تخطيط ذاكرة لكائن. النوع الملموس يحدد الحقول وتخطيطها ويمكن إنشاء قيم منه.

## لماذا تهم؟

استخدم النوع المجرد في العقود ونقاط التوزيع، واستخدم النوع الملموس لتخزين البيانات. الخلط بين الدورين يقود إلى حقول مبهمة أو شجرة وراثة لا تعبّر عن السلوك.

## مثال Julia

```julia
abstract type AbstractShape end

struct Circle{T<:Real} <: AbstractShape
    radius::T
end

println(isabstracttype(AbstractShape))
println(isconcretetype(Circle{Float64}))
println(typeof(Circle(2.0)))
```

## كيف تقرأ المثال؟

`AbstractShape` لا يمكن إنشاؤه مباشرة. أما `Circle{Float64}` فنوع ملموس كامل، بينما `Circle` وحده هو `UnionAll` يمثل عائلة من الأنواع الملموسة.

> [!example] تجربة قصيرة
> جرّب `isconcretetype(Circle)` ثم `isconcretetype(Circle{Int})`، واشرح اختلاف النتيجة.

> [!question]- سؤال استرجاع
> هل يستطيع النوع المجرد تخزين حقول أو إنشاء قيمة مباشرة منه؟

> [!success]- الإجابة
> لا؛ هو عقد وعائلة للتوزيع. التخزين والإنشاء من مسؤولية نوع ملموس.

## روابط ذات معنى

- الخريطة: [[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]
- الدرس المصدر: [[lessons/L01-dispatch-and-types.idea|L01 - التوزيع المتعدد والأنواع]]
- [[notes/A04-parametric-types-store-type-information.idea|A04 - الأنواع البارامترية تحمل معلومات في النوع]]
- [[notes/A16-parametric-fields-expose-types.idea|A16 - الحقل البارامتري يكشف النوع للمترجم]]
- [[notes/A21-small-interfaces-unlock-generic-behavior.idea|A21 - الواجهة الصغيرة تفتح سلوكا عاما]]

