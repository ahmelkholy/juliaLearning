---
id: A44
aliases:
  - "log-sum-exp يمنع الفيضان"
  - "LogSumExp"
  - "Stable logarithmic sum"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/numerics
  - julia/floating-point
lesson: 9
source: lessons/09_algorithm_design.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# log-sum-exp يمنع الفيضان

## الفكرة

لحساب `log(sum(exp(values)))` بأمان، اطرح أكبر قيمة قبل `exp` ثم أعدها بعد اللوغاريتم.

## لماذا تهم؟

`exp(1000)` يفيض رغم أن النتيجة اللوغاريتمية النهائية قابلة للتمثيل. التحويل يحافظ على القيمة الرياضية ويغير مقياس الأسس.

## مثال Julia

```julia
function stable_logsumexp(values)
    isempty(values) &&
        throw(ArgumentError("values cannot be empty"))
    m = maximum(values)
    m == Inf && return m
    m == -Inf && return m
    return m + log(sum(x -> exp(x - m), values))
end

println(stable_logsumexp([1000.0, 1001.0]))
println(1001 + log1p(exp(-1)))
```

## كيف تقرأ المثال؟

بعد طرح `1001` تصبح الأسس `-1` و`0` فلا يحدث overflow. معالجة infinity صريحة تمنع `Inf-Inf` من إنتاج `NaN`.

> [!example] تجربة قصيرة
> جرّب الصيغة المباشرة على القيم نفسها وقارنها بالدالة المستقرة.

> [!question]- سؤال استرجاع
> لماذا لا يغير طرح أكبر قيمة ثم إضافتها النتيجة الرياضية؟

> [!success]- الإجابة
> لأننا نفك `exp(m)` عاملًا مشتركًا: `log(exp(m)*sum(exp(x-m))) = m + log(...)`.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]
- [[notes/A42-compensated-summation-recovers-lost-parts.idea|A42 - الجمع المعوض يستعيد الأجزاء المفقودة]]
- [[notes/A43-welford-computes-online-variance.idea|A43 - خوارزمية Welford تحسب التباين على الإنترنت]]
- [[notes/A40-numerical-tolerances-follow-algorithm-accuracy.idea|A40 - التسامح العددي مشتق من دقة الخوارزمية]]

