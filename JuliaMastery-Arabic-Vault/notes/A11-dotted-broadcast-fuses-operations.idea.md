---
id: A11
aliases:
  - "البث المنقط يدمج العمليات"
  - "Broadcast fusion"
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

# البث المنقط يدمج العمليات

## الفكرة

النقطة تجعل الدالة أو العامل يعمل عنصرًا بعنصر. سلسلة العمليات المنقطة يمكن أن تندمج في حلقة واحدة بدل إنشاء وسيط لكل خطوة.

## لماذا تهم؟

التعبير المدمج أوضح من حلقة يدوية بسيطة ويقلل التخصيصات المؤقتة. الصيغة `.=` تكتب في وجهة موجودة.

## مثال Julia

```julia
x = range(-1.0, 1.0; length=5)
destination = similar(collect(x))

@. destination = muladd(2.0, x, -1.0)

println(destination)
println(2 .* x .- 1)
```

## كيف تقرأ المثال؟

`@.` يضيف النقاط إلى العمليات المناسبة داخل التعبير. `destination = ...` يعيد ربط الاسم، أما `destination .= ...` فيعدل الذاكرة الموجودة.

> [!example] تجربة قصيرة
> استبدل التعبير بـ `temporary = 2 .* x` ثم `destination .= temporary .- 1` وقارن التخصيص داخل دالة بعد التسخين.

> [!question]- سؤال استرجاع
> ما الفرق الدلالي بين `=` و`.=` عند التعامل مع مصفوفة وجهة؟

> [!success]- الإجابة
> `=` يربط الاسم بقيمة جديدة؛ `.=` يبث القيم إلى عناصر الحاوية الموجودة ويعدلها.

## روابط ذات معنى

- الخريطة: [[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]
- الدرس المصدر: [[lessons/L02-arrays-and-generic-numerics.idea|L02 - المصفوفات والحسابات العامة]]
- [[notes/A10-views-share-memory-slices-copy.idea|A10 - العرض يشارك الذاكرة والشريحة تنسخ]]
- [[notes/A12-eachindex-respects-container-indexing.idea|A12 - eachindex يحترم فهرسة الحاوية]]
- [[notes/A20-mutating-functions-clarify-memory-ownership.idea|A20 - الدالة المعدلة توضح ملكية الذاكرة]]

