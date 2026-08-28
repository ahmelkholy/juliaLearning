---
id: L02
aliases:
  - "الدرس 2: المصفوفات والحسابات العامة"
type: source-note
status: complete
tags:
  - course/lesson
  - course/lesson-02
  - julia
lesson: 2
source: lessons/02_arrays_and_numerics.jl
up: "[[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]"
cssclasses:
  - rtl-note
---

# الدرس 2: المصفوفات والحسابات العامة

> [!goal] هدف الدرس
> أن تميز النسخ من المشاركة، وتكتب حسابًا عامًا، وتربط ترتيب الحلقات بتخزين الذاكرة.

## قبل التشغيل

توقع أي عنصر من `matrix` يتغير بعد الكتابة في `viewed_column`، وهل يتغير `copied_column`.

## شبكة المفاهيم

- [[notes/A09-dense-matrices-are-column-major.idea|A09 - المصفوفات الكثيفة تخزن بالأعمدة]]
- [[notes/A10-views-share-memory-slices-copy.idea|A10 - العرض يشارك الذاكرة والشريحة تنسخ]]
- [[notes/A11-dotted-broadcast-fuses-operations.idea|A11 - البث المنقط يدمج العمليات]]
- [[notes/A12-eachindex-respects-container-indexing.idea|A12 - eachindex يحترم فهرسة الحاوية]]
- [[notes/A13-adjoint-differs-from-transpose.idea|A13 - المرافق المنقول يختلف عن النقل]]
- [[notes/A14-factorization-over-matrix-inverse.idea|A14 - حل النظام بالتحليل أفضل من المعكوس]]
- [[notes/A15-generic-arithmetic-does-not-force-float64.idea|A15 - الحساب العام لا يفرض Float64]]

## شغّل الدرس

من جذر المستودع:

```bash
julia --project=. lessons/02_arrays_and_numerics.jl
```

## مسار التنفيذ

يبدأ الدرس بـ Horner عامة، ثم دالة mutating ببث fused، ويعرض ترتيب التخزين والـ views، ويفرق بين adjoint وtranspose، وينهي بحل نظام عبر Cholesky.

## الكود الكامل

```julia
module Lesson02ArraysAndNumerics

using LinearAlgebra

# Polynomial coefficients run from the constant term to the highest power.
# Horner's method reduces multiplication, but the key idea is generic code: this
# function works with Complex, BigFloat, or any scalar that supports the operations.
function horner(coefficients, x)
    isempty(coefficients) && return zero(x)
    accumulator = last(coefficients) * one(x)
    for index in Iterators.reverse(eachindex(coefficients))[2:end]
        accumulator = muladd(accumulator, x, coefficients[index])
    end
    return accumulator
end

# `eachindex` is safe for matching elements without assuming a particular index
# layout. The dots fuse the expression and write into caller-owned memory.
function affine!(destination, x, scale, offset)
    axes(destination) == axes(x) || throw(DimensionMismatch("axes must match"))
    @. destination = muladd(scale, x, offset)
    return destination
end

quadratic_form(matrix, x) = dot(x, matrix * x)

function main()
    matrix = reshape(collect(1:12), 3, 4)

    # Julia stores dense matrices by column, so the first index changes fastest.
    @assert matrix[:, 1] == [1, 2, 3]
    @assert vec(matrix) == collect(1:12)

    copied_column = matrix[:, 2]
    viewed_column = @view matrix[:, 2]
    viewed_column[1] = -4
    @assert matrix[1, 2] == -4
    @assert copied_column[1] == 4

    x = range(-1.0, 1.0; length=8)
    destination = similar(collect(x))
    affine!(destination, x, 2.0, -1.0)
    @assert destination ≈ 2 .* x .- 1

    # The `'` operator is an adjoint and conjugates complex values; transpose does not.
    complex_vector = [1 + 2im, 3 - 4im]
    @assert complex_vector' * complex_vector == sum(abs2, complex_vector)
    @assert transpose(complex_vector) != complex_vector'

    symmetric = [4.0 1.0; 1.0 3.0]
    rhs = [1.0, 2.0]
    factorization = cholesky(Symmetric(symmetric))
    solution = factorization \ rhs
    @assert symmetric * solution ≈ rhs

    @assert horner([1, 2, 3], 2) == 17
    @assert quadratic_form(symmetric, rhs) == dot(rhs, symmetric * rhs)

    println("The view changed its parent array: ", matrix[1, 2])
    println("Solution from a factorization: ", solution)
    println("The same Horner function with BigFloat: ", horner(BigFloat[1, 2, 3], big"0.25"))
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
```

## تجارب مقصودة

- قارن `@allocated` لنسخة عمود وview داخل دالة بعد التسخين.
- مرّر `Float32` و`BigFloat` إلى `horner` وافحص نوع النتيجة.
- استعمل view بوصفها وجهة `affine!`.

> [!question]- اختبار استرجاع
> ما القرار الدلالي الذي يسبق قرار استعمال view؟

> [!success]- الإجابة
> هل تريد مشاركة الذاكرة فعلًا وتقبل أن يظهر التعديل في الحاوية الأم.

## الملاحة

- الخريطة الأعلى: [[maps/M02-arrays-and-memory.idea|M02 - المصفوفات والذاكرة]]
- الدرس التالي: [[lessons/L03-performance-and-type-inference.idea|L03 - الأداء واستدلال الأنواع]]

