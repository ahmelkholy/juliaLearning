---
id: A42
aliases:
  - "الجمع المعوض يستعيد الأجزاء المفقودة"
  - "Compensated summation"
  - "Neumaier summation"
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

# الجمع المعوض يستعيد الأجزاء المفقودة

## الفكرة

الجمع المعوض يحتفظ بتصحيح للأجزاء منخفضة الرتبة التي تضيع عندما تجمع قيمًا مختلفة المقاييس في floating point.

## لماذا تهم؟

الجمع ليس تجميعيًا عدديًا: `(a+b)+c` قد يختلف عن `a+(b+c)`. خوارزمية Neumaier تقلل الخطأ، خصوصًا عندما تكون القيمة الجديدة أكبر من المجموع الحالي.

## مثال Julia

```julia
function neumaier_sum(values)
    T = float(eltype(values))
    total = zero(T)
    correction = zero(T)
    for raw in values
        value = convert(T, raw)
        next_total = total + value
        if abs(total) >= abs(value)
            correction += (total - next_total) + value
        else
            correction += (value - next_total) + total
        end
        total = next_total
    end
    return total + correction
end

values = [1.0e16, 1.0, -1.0e16]
println(sum(values))
println(neumaier_sum(values))
```

## كيف تقرأ المثال؟

الواحد يضيع في الجمع العادي بعد إضافته إلى `1e16`. التصحيح يسجل المعلومة التي لم تدخل في `total` ويضيفها في النهاية.

> [!example] تجربة قصيرة
> بدّل ترتيب القيم وقارن `sum` و`neumaier_sum`. سجّل أي ترتيب يسبب أكبر فرق.

> [!question]- سؤال استرجاع
> هل يجعل الجمع المعوض النتيجة دقيقة رمزيًا دائمًا؟

> [!success]- الإجابة
> لا؛ يبقى حساب floating point، لكنه يقلل فئة مهمة من أخطاء التقريب.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]
- [[notes/A30-parallel-reductions-need-independent-chunks.idea|A30 - الاختزال المتوازي يحتاج أجزاء مستقلة]]
- [[notes/A41-algorithm-objects-replace-central-branches.idea|A41 - كائن الخوارزمية يستبدل الفروع المركزية]]
- [[notes/A44-log-sum-exp-prevents-overflow.idea|A44 - log-sum-exp يمنع الفيضان]]

