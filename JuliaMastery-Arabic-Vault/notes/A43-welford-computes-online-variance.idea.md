---
id: A43
aliases:
  - "خوارزمية Welford تحسب التباين على الإنترنت"
  - "Welford variance"
  - "Online statistics"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/numerics
  - julia/statistics
lesson: 9
source: lessons/09_algorithm_design.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# خوارزمية Welford تحسب التباين على الإنترنت

## الفكرة

Welford تحدّث العدد والمتوسط ومجموع الانحرافات `m2` عينة بعينة، من دون حفظ كل البيانات ومن دون الصيغة غير المستقرة `E[x²]-E[x]²`.

## لماذا تهم؟

طرح عددين كبيرين متقاربين يسبب cancellation. التحديث المتدرج أكثر استقرارًا ويعمل على streams.

## مثال Julia

```julia
struct RunningVariance{T<:AbstractFloat}
    count::Int
    mean::T
    m2::T
end

RunningVariance(::Type{T}=Float64) where {T<:AbstractFloat} =
    RunningVariance(0, zero(T), zero(T))

function update(s::RunningVariance{T}, sample) where {T}
    x = convert(T, sample)
    count = s.count + 1
    delta = x - s.mean
    mean = s.mean + delta / count
    m2 = s.m2 + delta * (x - mean)
    return RunningVariance(count, mean, m2)
end

s = foldl(update, [1.0, 2.0, 3.0, 4.0];
          init=RunningVariance())
println((s.mean, s.m2 / (s.count - 1)))
```

## كيف تقرأ المثال؟

كل عينة تحدّث الحالة immutable. قسمة `m2` على `count-1` تعطي sample variance عندما يوجد على الأقل عنصران.

> [!example] تجربة قصيرة
> أدخل القيم واحدة واحدة واطبع `mean` و`m2` بعد كل تحديث لتتبع المعادلة.

> [!question]- سؤال استرجاع
> ما ميزتا Welford مقارنة بحفظ العينات ثم استعمال `E[x²]-E[x]²`؟

> [!success]- الإجابة
> تعمل بذاكرة ثابتة على stream، وتتجنب cancellation الشديد في طرح كميتين كبيرتين.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]
- [[notes/A42-compensated-summation-recovers-lost-parts.idea|A42 - الجمع المعوض يستعيد الأجزاء المفقودة]]
- [[notes/A44-log-sum-exp-prevents-overflow.idea|A44 - log-sum-exp يمنع الفيضان]]
- [[notes/A31-one-rng-per-simulation-is-reproducible.idea|A31 - مولد عشوائي لكل محاكاة يثبت النتائج]]

