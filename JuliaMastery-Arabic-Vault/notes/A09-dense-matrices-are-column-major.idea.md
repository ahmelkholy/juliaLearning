---
id: A09
aliases:
  - "المصفوفات الكثيفة تخزن بالأعمدة"
  - "Column-major arrays"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/arrays
  - julia/performance
lesson: 2
source: lessons/02_arrays_and_numerics.jl
up: "[[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]"
cssclasses:
  - rtl-note
---

# المصفوفات الكثيفة تخزن بالأعمدة

## الفكرة

المصفوفة الكثيفة في Julia مخزنة column-major: عناصر العمود الواحد متجاورة، والفهرس الأول يتغير أسرع في الذاكرة.

## لماذا تهم؟

ترتيب الحلقات الذي يعبر الذاكرة بالتتابع يستفيد من cache ويقلل الانتظار. في حلقة ثنائية اجعل الصف غالبًا في الداخل والعمود في الخارج.

## مثال Julia

```julia
function column_major_sum(matrix)
    total = zero(eltype(matrix))
    for column in axes(matrix, 2)
        for row in axes(matrix, 1)
            total += matrix[row, column]
        end
    end
    return total
end

matrix = reshape(collect(1:12), 3, 4)
println(matrix[:, 1])
println(vec(matrix))
println(column_major_sum(matrix))
```

## كيف تقرأ المثال؟

`vec(matrix)` يعيد ترتيب التخزين نفسه: العمود الأول ثم الثاني. الحلقة تطابق هذا الترتيب.

> [!example] تجربة قصيرة
> اكتب نسختين على مصفوفة كبيرة: row في الداخل ثم column في الداخل. سخّن الدالتين وقارن الزمن بوسيلة قياس مناسبة.

> [!question]- سؤال استرجاع
> أي فهرس يتغير أسرع في ذاكرة مصفوفة Julia الكثيفة؟

> [!success]- الإجابة
> الفهرس الأول، ولذلك تكون عناصر العمود الواحد متجاورة.

## روابط ذات معنى

- الخريطة: [[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]
- الدرس المصدر: [[lessons/L02-arrays-and-generic-numerics.idea|L02 - المصفوفات والحسابات العامة]]
- [[notes/A10-views-share-memory-slices-copy.idea|A10 - العرض يشارك الذاكرة والشريحة تنسخ]]
- [[notes/A19-warm-up-before-performance-measurement.idea|A19 - التسخين يسبق قياس الأداء]]
- [[notes/A20-mutating-functions-clarify-memory-ownership.idea|A20 - الدالة المعدلة توضح ملكية الذاكرة]]
