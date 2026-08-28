---
id: A47
aliases:
  - "المتبقي النسبي يقيس جودة الحل"
  - "Relative residual"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/numerics
  - julia/testing
lesson: 9
source: src/iterative_solvers.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# المتبقي النسبي يقيس جودة الحل

## الفكرة

للنظام `A*x=b`، المتبقي `r=b-A*x` يقيس مدى تحقق المعادلة. قسم معياره على `norm(b)` للحصول على مقياس نسبي عندما يكون `b` غير صفري.

## لماذا تهم؟

قد يبدو متجه الحل معقولًا بصريًا ولا يحقق النظام، وقد يكون residual مطلق صغيرًا أو كبيرًا فقط بسبب مقياس البيانات. القياس النسبي أوضح.

## مثال Julia

```julia
using LinearAlgebra
using JuliaMastery: cg

A = [4.0 1.0; 1.0 3.0]
b = [1.0, 2.0]
result = cg(A, b; rtol=1e-12)

relative_residual =
    norm(A * result.x - b) / norm(b)

println(relative_residual)
println(result.residual_norm)
```

## كيف تقرأ المثال؟

المحلّل يخزن معيار residual النهائي، لكن إعادة حسابه من الواجهة العامة تحقق النتيجة مستقلًا. قرب `b=0` تحتاج `atol` أو معالجة خاصة.

> [!example] تجربة قصيرة
> اضرب `b` في مليون وقارن residual المطلق والنسبي.

> [!question]- سؤال استرجاع
> لماذا لا يكفي اختبار `result.converged` وحده في اختبار مستقل؟

> [!success]- الإجابة
> لأن إعادة حساب residual تتحقق من العقد من خارج التنفيذ ولا تثق بعلامة داخلية فقط.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]
- [[notes/A40-numerical-tolerances-follow-algorithm-accuracy.idea|A40 - التسامح العددي مشتق من دقة الخوارزمية]]
- [[notes/A45-matrix-free-operators-reduce-memory.idea|A45 - المؤثر دون مصفوفة يقلل الذاكرة]]
- [[notes/A46-conjugate-gradient-requires-positive-definite-operator.idea|A46 - Conjugate Gradient يحتاج مؤثرا موجبا]]

