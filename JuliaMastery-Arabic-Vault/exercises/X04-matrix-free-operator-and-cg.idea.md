---
id: X04
aliases:
  - "بناء مؤثر وحل نظام دون مصفوفة"
type: exercise
status: queued
difficulty: متوسط
xp: 220
estimated_time: 50 دقيقة
tags:
  - practice/exercise
  - julia
up: "[[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]"
cssclasses:
  - rtl-note
---

# بناء مؤثر وحل نظام دون مصفوفة

> [!abstract] المهمة
> مثّل مصفوفة قطرية موجبة بكائن callable، ثم حل النظام بـ CG وتحقق من residual من دون بناء Matrix.

## المتطلبات السابقة

- [[notes/A24-callable-objects-combine-data-and-behavior.idea|A24 - الكائن القابل للاستدعاء يجمع البيانات والسلوك]]
- [[notes/A45-matrix-free-operators-reduce-memory.idea|A45 - المؤثر دون مصفوفة يقلل الذاكرة]]
- [[notes/A46-conjugate-gradient-requires-positive-definite-operator.idea|A46 - Conjugate Gradient يحتاج مؤثرا موجبا]]
- [[notes/A47-relative-residual-measures-solution-quality.idea|A47 - المتبقي النسبي يقيس جودة الحل]]

## كود البداية

```julia
using LinearAlgebra
using JuliaMastery: cg

struct DiagonalOperator{V<:AbstractVector}
    diagonal::V
end

function (A::DiagonalOperator)(x::AbstractVector)
    # TODO: تحقق من الطول
    # TODO: أعد diagonal .* x
end

diagonal = collect(range(1.0, 2.0; length=10_000))
A = DiagonalOperator(diagonal)
b = ones(length(diagonal))

# TODO: result = cg(...)
```

## اختبارات القبول

```julia
using Test
using LinearAlgebra

result = cg(A, b; rtol=1e-10)

@test result.converged
@test norm(A(result.x) - b) / norm(b) < 1e-9
@test result.x ≈ 1.0 ./ diagonal
@test_throws DimensionMismatch A(ones(3))
```

> [!hint]- تلميحات متدرجة
> 1. لا تنشئ `Diagonal(diagonal)` في الحل الأساسي.
> 2. المؤثر الموجب يحتاج عناصر قطر موجبة.
> 3. واجهة CG callable هي `A(x)`.

## أسئلة ما بعد الحل

- ما تعقيد الذاكرة هنا مقارنة بمصفوفة كثيفة؟
- لماذا residual اختبار أفضل من النظر إلى أول عناصر الحل؟

## روابط

- الخريطة: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]
- [[sources/S03-conjugate-gradient-source.idea|S03 - كود Conjugate Gradient]]
- [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]
- [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]

