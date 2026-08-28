---
id: A01
aliases:
  - "الطرق تنتمي إلى الدوال"
  - "Methods belong to functions"
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

# الطرق تنتمي إلى الدوال

## الفكرة

في Julia، الدالة العامة هي التي تجمع الطرق المختلفة. النوع لا «يمتلك» الطريقة كما يحدث عادةً في تصميم class-oriented؛ بل تضيف تطبيقًا جديدًا إلى اسم دالة مشترك.

## لماذا تهم؟

هذا يجعل إضافة سلوك لنوع جديد ممكنة من خارج ملف النوع، ويسمح لعملية واحدة بأن تعمل طبيعيًا على أنواع من مكتبات مختلفة. وهو الأساس الذي يبنى عليه التوزيع المتعدد.

## مثال Julia

```julia
abstract type Shape end
struct Circle <: Shape
    radius::Float64
end
struct Rectangle <: Shape
    width::Float64
    height::Float64
end

area(shape::Circle) = π * shape.radius^2
area(shape::Rectangle) = shape.width * shape.height

println(area(Circle(2.0)))
println(methods(area))
```

## كيف تقرأ المثال؟

الاسم `area` دالة واحدة، لكن له طريقتان بتوقيعين مختلفين. عند النداء لا تبحث Julia داخل `Circle`؛ بل تبحث في جدول طرق `area` عن أفضل توقيع.

> [!example] تجربة قصيرة
> أضف نوع `Square` وطريقة `area(::Square)` من دون لمس تعريف `Circle` أو `Rectangle`، ثم افحص `methods(area)`.

> [!question]- سؤال استرجاع
> إذا أضفت طريقة جديدة إلى `area`، فما الكيان الذي اتسع: النوع أم الدالة؟

> [!success]- الإجابة
> اتسعت الدالة العامة `area` بإضافة method جديدة؛ لم يتغير تعريف النوع.

## روابط ذات معنى

- الخريطة: [[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]
- الدرس المصدر: [[lessons/L01-dispatch-and-types.idea|L01 - التوزيع المتعدد والأنواع]]
- [[notes/A02-multiple-dispatch-uses-all-arguments.idea|A02 - التوزيع المتعدد يستخدم جميع أنواع الوسائط]]
- [[notes/A08-resolve-method-ambiguity-at-intersection.idea|A08 - غموض الطرق يحل بتعريف التقاطع]]
- [[notes/A36-small-public-apis-reduce-coupling.idea|A36 - واجهة عامة صغيرة تقلل الاقتران]]

