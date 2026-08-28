---
id: A30
aliases:
  - "الاختزال المتوازي يحتاج أجزاء مستقلة"
  - "Thread-safe reduction"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/concurrency
  - julia/numerics
lesson: 6
source: lessons/06_concurrency.jl
up: "[[maps/M05-concurrency-and-reproducibility.idea|M05 - التزامن وقابلية إعادة الإنتاج]]"
cssclasses:
  - rtl-note
---

# الاختزال المتوازي يحتاج أجزاء مستقلة

## الفكرة

في reduction متوازية، امنح كل chunk منطقية accumulator مستقلًا ثم اجمع النتائج الجزئية بعد انتهاء العمل.

## لماذا تهم؟

الكتابة في accumulator مشتركة تسبب race. وربط accumulator بـ `threadid()` قد يكون هشًا مع جدولة المهام. ملكية chunk ثابتة أوضح.

## مثال Julia

```julia
using Base.Threads

function chunked_sum(values)
    isempty(values) && return zero(eltype(values))
    chunks = min(length(values), max(1, 4 * nthreads()))
    partials = zeros(eltype(values), chunks)
    n = length(values)

    @threads for chunk in 1:chunks
        first_i = fld((chunk - 1) * n, chunks) + 1
        last_i = fld(chunk * n, chunks)
        total = zero(eltype(values))
        for i in first_i:last_i
            total += values[i]
        end
        partials[chunk] = total
    end
    return sum(partials)
end

println(chunked_sum(collect(1.0:1000.0)))
```

## كيف تقرأ المثال؟

الـ chunk، لا الخيط الفيزيائي، تملك slot في `partials`. الجمع النهائي قد يملك ترتيبًا مختلفًا عن الجمع التسلسلي.

> [!example] تجربة قصيرة
> قارن `chunked_sum` و`sum` على قيم floating point صعبة، واستعمل `≈` بدل توقع تطابق bitwise.

> [!question]- سؤال استرجاع
> لماذا قد تختلف آخر bits رغم عدم وجود race؟

> [!success]- الإجابة
> لأن floating-point addition غير تجميعية، وتقسيم الاختزال يغير ترتيب الجمع.

## روابط ذات معنى

- الخريطة: [[maps/M05-concurrency-and-reproducibility.idea|M05 - التزامن وقابلية إعادة الإنتاج]]
- الدرس المصدر: [[lessons/L06-concurrency.idea|L06 - التزامن]]
- [[notes/A29-disjoint-output-ownership-removes-locks.idea|A29 - ملكية فهارس الخرج تغني عن القفل]]
- [[notes/A31-one-rng-per-simulation-is-reproducible.idea|A31 - مولد عشوائي لكل محاكاة يثبت النتائج]]
- [[notes/A42-compensated-summation-recovers-lost-parts.idea|A42 - الجمع المعوض يستعيد الأجزاء المفقودة]]

