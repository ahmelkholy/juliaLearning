---
id: X02
aliases:
  - "مقارنة النسخ والعرض والتخصيص"
type: exercise
status: queued
difficulty: مبتدئ
xp: 120
estimated_time: 25 دقيقة
tags:
  - practice/exercise
  - julia
up: "[[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]"
cssclasses:
  - rtl-note
---

# مقارنة النسخ والعرض والتخصيص

> [!abstract] المهمة
> قِس الفرق بين أخذ عمود بنسخة وأخذه كـ view، ثم وثق فرق الملكية قبل الحديث عن السرعة.

## المتطلبات السابقة

- [[notes/A10-views-share-memory-slices-copy.idea|A10 - العرض يشارك الذاكرة والشريحة تنسخ]]
- [[notes/A19-warm-up-before-performance-measurement.idea|A19 - التسخين يسبق قياس الأداء]]
- [[notes/A20-mutating-functions-clarify-memory-ownership.idea|A20 - الدالة المعدلة توضح ملكية الذاكرة]]

## كود البداية

```julia
copy_column(A, j) = A[:, j]
view_column(A, j) = @view A[:, j]

function measure(A)
    copy_column(A, 2)  # warm-up
    view_column(A, 2)  # warm-up
    return (
        copy_bytes = @allocated copy_column(A, 2),
        view_bytes = @allocated view_column(A, 2),
    )
end

A = rand(1_000, 20)
println(measure(A))
```

## اختبارات القبول

```julia
using Test

A = reshape(collect(1:9), 3, 3)
copied = copy_column(A, 2)
viewed = view_column(A, 2)

copied[1] = -1
@test A[1, 2] == 4

viewed[1] = -2
@test A[1, 2] == -2
```

> [!hint]- تلميحات متدرجة
> 1. ضع القياس داخل دالة.
> 2. سخّن التوقيع نفسه قبل `@allocated`.
> 3. الـ view قد تخصص كائن view صغيرًا؛ المهم أنها لا تنسخ كل العناصر.

## أسئلة ما بعد الحل

- أي نتيجة تتعلق بالدلالات وأيها تتعلق بالأداء؟
- متى تكون النسخة هي القرار الصحيح رغم تخصيصها؟

## روابط

- الخريطة: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]
- [[lessons/L02-arrays-and-generic-numerics.idea|L02 - المصفوفات والحسابات العامة]]
- [[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]

