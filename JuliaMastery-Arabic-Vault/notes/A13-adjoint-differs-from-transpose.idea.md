---
id: A13
aliases:
  - "المرافق المنقول يختلف عن النقل"
  - "Adjoint versus transpose"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/arrays
  - julia/linear-algebra
lesson: 2
source: lessons/02_arrays_and_numerics.jl
up: "[[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]"
cssclasses:
  - rtl-note
---

# المرافق المنقول يختلف عن النقل

## الفكرة

العامل `'` في Julia ينشئ adjoint: نقلًا مع مرافق مركب. `transpose` ينقل من دون تغيير إشارة الجزء التخيلي.

## لماذا تهم؟

في الجبر الخطي المركب، الضرب الداخلي الصحيح يستعمل المرافق. الخلط بين العمليتين ينتج معادلات مختلفة حتى لو تطابقتا للأعداد الحقيقية.

## مثال Julia

```julia
using LinearAlgebra

z = [1 + 2im, 3 - 4im]

println(z')
println(transpose(z))
println(z' * z)
println(sum(abs2, z))
```

## كيف تقرأ المثال؟

يجب أن يساوي `z' * z` مجموع مربعات القيم المطلقة ويكون عددًا حقيقيًا غير سالب. `transpose(z)` لا يحقق معنى الضرب الداخلي نفسه.

> [!example] تجربة قصيرة
> كرر المثال بمتجه حقيقي، ثم اشرح لماذا يختفي الفرق الظاهر.

> [!question]- سؤال استرجاع
> متى لا يجوز استبدال `'` بـ `transpose`؟

> [!success]- الإجابة
> عند وجود قيم مركبة إذا كانت العملية المطلوبة هي adjoint أو ضربًا داخليًا Hermitian.

## روابط ذات معنى

- الخريطة: [[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]
- الدرس المصدر: [[lessons/L02-arrays-and-generic-numerics.idea|L02 - المصفوفات والحسابات العامة]]
- [[notes/A14-factorization-over-matrix-inverse.idea|A14 - حل النظام بالتحليل أفضل من المعكوس]]
- [[notes/A46-conjugate-gradient-requires-positive-definite-operator.idea|A46 - Conjugate Gradient يحتاج مؤثرا موجبا]]
- [[notes/A47-relative-residual-measures-solution-quality.idea|A47 - المتبقي النسبي يقيس جودة الحل]]

