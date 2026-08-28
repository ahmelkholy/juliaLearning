---
id: X07
aliases:
  - "تنفيذ power iteration بواجهة مؤثر"
type: exercise
status: queued
difficulty: متقدم
xp: 300
estimated_time: 75 دقيقة
tags:
  - practice/exercise
  - julia
up: "[[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]"
cssclasses:
  - rtl-note
---

# تنفيذ power iteration بواجهة مؤثر

> [!abstract] المهمة
> احسب dominant eigenpair لمصفوفة أو callable، وأعد تقرير convergence typed، وتعامل مع متجه البداية الصفري.

## المتطلبات السابقة

- [[notes/A24-callable-objects-combine-data-and-behavior.idea|A24 - الكائن القابل للاستدعاء يجمع البيانات والسلوك]]
- [[notes/A45-matrix-free-operators-reduce-memory.idea|A45 - المؤثر دون مصفوفة يقلل الذاكرة]]
- [[notes/A47-relative-residual-measures-solution-quality.idea|A47 - المتبقي النسبي يقيس جودة الحل]]

## كود البداية

```julia
using LinearAlgebra

struct EigenResult{V,T,R<:Real}
    vector::V
    value::T
    residual_norm::R
    iterations::Int
    converged::Bool
end

apply_operator(A::AbstractMatrix, x) = A * x
apply_operator(A, x) = A(x)

function power_iteration(A, initial;
                         tolerance=1e-10,
                         maxiter=1_000)
    # TODO: تحقق من المدخلات
    # TODO: طبّع initial
    # TODO: حدّث image وRayleigh quotient وresidual
    # TODO: أعد EigenResult
end
```

## اختبارات القبول

```julia
using Test
using LinearAlgebra

A = [4.0 1.0; 1.0 2.0]
matrix_result = power_iteration(A, [1.0, 1.0])
callable_result = power_iteration(x -> A*x, [1.0, 1.0])

@test matrix_result.converged
@test norm(A*matrix_result.vector -
           matrix_result.value*matrix_result.vector) < 1e-9
@test abs(callable_result.value - matrix_result.value) < 1e-10
@test_throws ArgumentError power_iteration(A, zeros(2))
```

> [!hint]- تلميحات متدرجة
> 1. `vector = image / norm(image)`.
> 2. استعمل Rayleigh quotient `dot(vector, image)`.
> 3. قارن المتجهات مع مراعاة sign أو phase، أو اختبر residual بدلها.

## أسئلة ما بعد الحل

- لماذا المتجه و`-vector` جوابان متكافئان؟
- ما الذي يجعل التقرير typed أفضل من tuple غير موثقة؟

## روابط

- الخريطة: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]
- [[sources/S04-advanced-exercises-source.idea|S04 - كود التمارين المتقدمة الأصلي]]
- [[sources/S05-advanced-solutions-source.idea|S05 - الحلول المرجعية المتقدمة]]
- [[notes/A46-conjugate-gradient-requires-positive-definite-operator.idea|A46 - Conjugate Gradient يحتاج مؤثرا موجبا]]

