---
id: A31
aliases:
  - "مولد عشوائي لكل محاكاة يثبت النتائج"
  - "Deterministic threaded RNG"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/concurrency
  - julia/reproducibility
lesson: 6
source: lessons/06_concurrency.jl
up: "[[maps/M05-concurrency-and-reproducibility.idea|M05 - التزامن وقابلية إعادة الإنتاج]]"
cssclasses:
  - rtl-note
---

# مولد عشوائي لكل محاكاة يثبت النتائج

## الفكرة

اربط stream العشوائية بالعمل المنطقي، مثل simulation ذات seed محددة، لا بالخيط الذي ينفذها.

## لماذا تهم؟

الجدولة وعدد الخيوط قد يتغيران. مولد عالمي مشترك يسبب تنافسًا وترتيب سحب تابعًا للجدولة، ومولد لكل thread يربط النتيجة بالبنية الفيزيائية.

## مثال Julia

```julia
using Random: Xoshiro, randn
using Base.Threads

function ensemble(seeds)
    output = Vector{Float64}(undef, length(seeds))
    @threads for i in eachindex(seeds)
        rng = Xoshiro(seeds[i])
        output[i] = sum(randn(rng, 1_000))
    end
    return output
end

seeds = UInt64[11, 22, 33, 44]
println(ensemble(seeds) == ensemble(seeds))
```

## كيف تقرأ المثال؟

كل فهرس يعيد إنشاء مولد من seed الخاصة به. أي خيط يستطيع تنفيذ الفهرس من دون تغيير stream.

> [!example] تجربة قصيرة
> شغّل المثال بخيط واحد وبـ `--threads=auto` وقارن النتائج نفسها.

> [!question]- سؤال استرجاع
> ما الهوية التي يجب أن تملك seed: `threadid()` أم رقم simulation؟

> [!success]- الإجابة
> رقم أو هوية simulation المنطقية، لأن الخيط وجدول التنفيذ تفاصيل قابلة للتغيير.

## روابط ذات معنى

- الخريطة: [[maps/M05-concurrency-and-reproducibility.idea|M05 - التزامن وقابلية إعادة الإنتاج]]
- الدرس المصدر: [[lessons/L06-concurrency.idea|L06 - التزامن]]
- [[notes/A29-disjoint-output-ownership-removes-locks.idea|A29 - ملكية فهارس الخرج تغني عن القفل]]
- [[notes/A30-parallel-reductions-need-independent-chunks.idea|A30 - الاختزال المتوازي يحتاج أجزاء مستقلة]]
- [[notes/A39-good-tests-check-public-contracts.idea|A39 - الاختبار الجيد يفحص العقد العام]]

