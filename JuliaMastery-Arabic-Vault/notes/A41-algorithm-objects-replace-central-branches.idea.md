---
id: A41
aliases:
  - "كائن الخوارزمية يستبدل الفروع المركزية"
  - "Algorithm objects"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/design
  - julia/dispatch
  - julia/numerics
lesson: 9
source: lessons/09_algorithm_design.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# كائن الخوارزمية يستبدل الفروع المركزية

## الفكرة

مثّل اختيار الخوارزمية بنوع، واجعل اسم العملية ثابتًا، ثم وزّع على كائن الخوارزمية بدل switch كبيرة على Symbol أو String.

## لماذا تهم؟

إضافة خوارزمية تصبح إضافة نوع وطريقة، لا تعديل دالة مركزية. ويمكن لكائن الخوارزمية حمل parameters موثقة ومتحققة.

## مثال Julia

```julia
abstract type SumAlgorithm end
struct NativeSum <: SumAlgorithm end
struct CompensatedSum <: SumAlgorithm end

accurate_sum(values, ::NativeSum) = sum(values)

function accurate_sum(values, ::CompensatedSum)
    total = zero(float(eltype(values)))
    correction = zero(total)
    for raw in values
        value = float(raw)
        next_total = total + value
        correction += (total - next_total) + value
        total = next_total
    end
    return total + correction
end

values = [1.0e16, 1.0, -1.0e16]
println(accurate_sum(values, NativeSum()))
println(accurate_sum(values, CompensatedSum()))
```

## كيف تقرأ المثال؟

الطريقتان تشتركان في `accurate_sum`. المثال المبسط يشرح pattern؛ ملاحظة الجمع المعوض تعرض صيغة Neumaier الأدق.

> [!example] تجربة قصيرة
> أضف `PairwiseSum` بوصفها نوعًا جديدًا من دون تعديل الطريقتين الموجودتين.

> [!question]- سؤال استرجاع
> ما المشكلة التي يتجنبها algorithm object مقارنة بـ `if algorithm == :native`؟

> [!success]- الإجابة
> يتجنب فرعًا مركزيًا ينمو مع كل خيار، ويجعل التوسعة method جديدة مستقلة.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]
- [[notes/A02-multiple-dispatch-uses-all-arguments.idea|A02 - التوزيع المتعدد يستخدم جميع أنواع الوسائط]]
- [[notes/A42-compensated-summation-recovers-lost-parts.idea|A42 - الجمع المعوض يستعيد الأجزاء المفقودة]]
- [[notes/A49-extension-points-add-algorithms-without-changing-solve.idea|A49 - نقاط التوسعة تضيف خوارزمية دون تعديل solve]]

