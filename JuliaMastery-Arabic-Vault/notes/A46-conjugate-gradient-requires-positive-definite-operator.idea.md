---
id: A46
aliases:
  - "Conjugate Gradient يحتاج مؤثرا موجبا"
  - "Conjugate Gradient"
  - "CG"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/numerics
  - julia/linear-algebra
lesson: 9
source: src/iterative_solvers.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# Conjugate Gradient يحتاج مؤثرا موجبا

## الفكرة

طريقة Conjugate Gradient تحل `A*x=b` عندما يكون المؤثر symmetric أو Hermitian positive definite.

## لماذا تهم؟

شرط positive definiteness يضمن أن `p'Ap` موجب للاتجاهات غير الصفرية، وهو أساس طول الخطوة والتقارب. استخدام CG خارج عقدها قد يؤدي إلى breakdown.

## مثال Julia

```julia
using LinearAlgebra
using JuliaMastery: cg

A = [4.0 1.0; 1.0 3.0]
b = [1.0, 2.0]

result = cg(A, b; rtol=1e-12)

println(result.x)
println(result.converged)
println(A * result.x - b)
```

## كيف تقرأ المثال؟

`CGResult` لا يعيد المتجه فقط؛ يحمل residual وعدد iterations وعلامة convergence. المصفوفة متناظرة وموجبة التعريف.

> [!example] تجربة قصيرة
> استبدل `A` بـ `-Matrix{Float64}(I,2,2)` واقرأ `ConvergenceError` التي تكشف كسر العقد.

> [!question]- سؤال استرجاع
> ما الكمية التي يجب أن تكون موجبة في كل iteration لمؤثر موجب التعريف؟

> [!success]- الإجابة
> `p' * A * p` لأي اتجاه بحث غير صفري.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]
- [[notes/A13-adjoint-differs-from-transpose.idea|A13 - المرافق المنقول يختلف عن النقل]]
- [[notes/A45-matrix-free-operators-reduce-memory.idea|A45 - المؤثر دون مصفوفة يقلل الذاكرة]]
- [[notes/A47-relative-residual-measures-solution-quality.idea|A47 - المتبقي النسبي يقيس جودة الحل]]

