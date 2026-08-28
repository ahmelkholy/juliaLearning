---
id: A14
aliases:
  - "حل النظام بالتحليل أفضل من المعكوس"
  - "Factorization over inverse"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/linear-algebra
  - julia/numerics
lesson: 2
source: lessons/02_arrays_and_numerics.jl
up: "[[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]"
cssclasses:
  - rtl-note
---

# حل النظام بالتحليل أفضل من المعكوس

## الفكرة

لحل `A*x=b` استخدم العامل `\` أو تحليلًا مناسبًا، ولا تحسب `inv(A)*b` عادةً.

## لماذا تهم؟

التحليل يستغل بنية المصفوفة، يقلل العمل، ويملك سلوكًا عدديًا أفضل. ويمكن إعادة استعماله لعدة أطراف يمنى.

## مثال Julia

```julia
using LinearAlgebra

A = [4.0 1.0; 1.0 3.0]
b1 = [1.0, 2.0]
b2 = [2.0, -1.0]

F = cholesky(Symmetric(A))
x1 = F \ b1
x2 = F \ b2

println(norm(A * x1 - b1))
println(norm(A * x2 - b2))
```

## كيف تقرأ المثال؟

`Symmetric(A)` يعلن البنية، و`cholesky` يستغل كون المصفوفة موجبة التعريف. الكائن `F` ليس المصفوفة الأصلية بل تحليل قابل لإعادة الاستخدام.

> [!example] تجربة قصيرة
> قارن `A \ b1` مع `F \ b1` في النتيجة. ثم جرّب مصفوفة غير موجبة التعريف واقرأ خطأ Cholesky.

> [!question]- سؤال استرجاع
> ما الفائدة الإضافية من حفظ factorization بدل استعمال `A \ b` كل مرة؟

> [!success]- الإجابة
> يمكن إعادة التحليل نفسه لعدة أطراف يمنى بدل حسابه من جديد، مع الاستفادة من بنية المصفوفة.

## روابط ذات معنى

- الخريطة: [[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]
- الدرس المصدر: [[lessons/L02-arrays-and-generic-numerics.idea|L02 - المصفوفات والحسابات العامة]]
- [[notes/A13-adjoint-differs-from-transpose.idea|A13 - المرافق المنقول يختلف عن النقل]]
- [[notes/A45-matrix-free-operators-reduce-memory.idea|A45 - المؤثر دون مصفوفة يقلل الذاكرة]]
- [[notes/A46-conjugate-gradient-requires-positive-definite-operator.idea|A46 - Conjugate Gradient يحتاج مؤثرا موجبا]]

