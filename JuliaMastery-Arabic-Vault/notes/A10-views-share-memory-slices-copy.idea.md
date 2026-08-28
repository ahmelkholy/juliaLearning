---
id: A10
aliases:
  - "العرض يشارك الذاكرة والشريحة تنسخ"
  - "Views versus copies"
  - "Aliasing"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/arrays
  - julia/memory
lesson: 2
source: lessons/02_arrays_and_numerics.jl
up: "[[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]"
cssclasses:
  - rtl-note
---

# العرض يشارك الذاكرة والشريحة تنسخ

## الفكرة

`matrix[:, j]` ينشئ عادةً مصفوفة مستقلة، بينما `@view matrix[:, j]` ينشئ كائنًا يشير إلى الجزء نفسه من ذاكرة الأصل.

## لماذا تهم؟

الـ view تتجنب نسخة وتسمح بالتعديل المباشر، لكنها تنشئ aliasing: اسمان يصلان إلى الذاكرة نفسها. القرار يتعلق بالملكية والدلالات، لا بالأداء وحده.

## مثال Julia

```julia
matrix = reshape(collect(1:9), 3, 3)
copied = matrix[:, 2]
viewed = @view matrix[:, 2]

copied[1] = 100
viewed[2] = 200

println(matrix)
println(copied)
```

## كيف تقرأ المثال؟

تعديل `copied` لا يغير الأصل. تعديل `viewed` يظهر في `matrix` لأنهما يشتركان في التخزين.

> [!example] تجربة قصيرة
> افحص `parent(viewed)`، ثم مرّر view إلى دالة معدّلة ولاحظ الجزء الذي يتغير من الأصل.

> [!question]- سؤال استرجاع
> ما السؤال الذي يجب أن تطرحه قبل استبدال slice بـ view؟

> [!success]- الإجابة
> هل أريد مشاركة الذاكرة والملكية فعلًا، وهل يستطيع التعديل عبر أحد الاسمين تغيير ما يراه الآخر؟

## روابط ذات معنى

- الخريطة: [[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]
- الدرس المصدر: [[lessons/L02-arrays-and-generic-numerics.idea|L02 - المصفوفات والحسابات العامة]]
- [[notes/A09-dense-matrices-are-column-major.idea|A09 - المصفوفات الكثيفة تخزن بالأعمدة]]
- [[notes/A20-mutating-functions-clarify-memory-ownership.idea|A20 - الدالة المعدلة توضح ملكية الذاكرة]]
- [[notes/A53-copying-saved-states-prevents-aliasing.idea|A53 - نسخ الحالات المحفوظة يمنع aliasing]]

