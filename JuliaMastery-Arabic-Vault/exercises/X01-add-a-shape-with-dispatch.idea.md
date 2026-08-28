---
id: X01
aliases:
  - "إضافة شكل جديد بالتوزيع"
type: exercise
status: queued
difficulty: مبتدئ
xp: 100
estimated_time: 20 دقيقة
tags:
  - practice/exercise
  - julia
up: "[[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]"
cssclasses:
  - rtl-note
---

# إضافة شكل جديد بالتوزيع

> [!abstract] المهمة
> أضف `Square` إلى عائلة الأشكال من دون تعديل `Circle` أو طرقها. أثبت أن التوسعة method جديدة لا فرع جديد.

## المتطلبات السابقة

- [[notes/A01-methods-belong-to-functions.idea|A01 - الطرق تنتمي إلى الدوال]]
- [[notes/A02-multiple-dispatch-uses-all-arguments.idea|A02 - التوزيع المتعدد يستخدم جميع أنواع الوسائط]]
- [[notes/A05-inner-constructors-protect-invariants.idea|A05 - المنشئ الداخلي يحمي ثوابت النوع]]

## كود البداية

```julia
abstract type Shape end

struct Circle{T<:Real} <: Shape
    radius::T
end

area(shape::Circle) = π * shape.radius^2

# TODO: عرّف Square مع invariant مناسب
# TODO: أضف area(::Square)
# TODO: أضف overlaps إن أردت
```

## اختبارات القبول

```julia
using Test

square = Square(3.0)
@test area(square) == 9.0
@test_throws ArgumentError Square(-1.0)
@test @which(area(square)) == which(area, (typeof(square),))
```

> [!hint]- تلميحات متدرجة
> 1. اجعل طول الضلع حقلًا بارامتري النوع.
> 2. ضع فحص عدم السلبية في inner constructor.
> 3. لا تضف `if shape isa Square` إلى `area`.

## أسئلة ما بعد الحل

- ما الذي تغير في جدول طرق `area`؟
- هل احتاج النوع القديم إلى معرفة النوع الجديد؟

## روابط

- الخريطة: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]
- [[lessons/L01-dispatch-and-types.idea|L01 - التوزيع المتعدد والأنواع]]
- [[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]

