---
id: A40
aliases:
  - "التسامح العددي مشتق من دقة الخوارزمية"
  - "Numerical tolerance"
  - "isapprox"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/testing
  - julia/numerics
lesson: 8
source: test/runtests.jl
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# التسامح العددي مشتق من دقة الخوارزمية

## الفكرة

اختيار `rtol` و`atol` قرار عددي يجب أن يتبع دقة الطريقة، وحجم الخطوة، ومقياس القيم، ونوع العدد.

## لماذا تهم؟

تسامح واسع يخفي bug، وتسامح أضيق من قدرة الخوارزمية يجعل الاختبار هشًا. المساواة الدقيقة نادرة الملاءمة لحساب floating point طويل.

## مثال Julia

```julia
using Test

exact = exp(-2)
first_order_approximation = 0.1352

@test isapprox(
    first_order_approximation,
    exact;
    rtol=0.002,
)

small = 1.0e-12
@test isapprox(small, 0.0; atol=2.0e-12)
```

## كيف تقرأ المثال؟

`rtol` يقيس الخطأ نسبة إلى المقياس، و`atol` يعطي أرضية قرب الصفر. يجب تبرير الأرقام من التحليل أو تجربة تقارب.

> [!example] تجربة قصيرة
> غيّر `first_order_approximation` قليلًا وحدد متى يفشل الاختبار. لا توسع tolerance قبل فهم مقدار الخطأ المتوقع.

> [!question]- سؤال استرجاع
> لماذا لا يكفي `rtol` وحده عندما تكون القيمة الصحيحة صفرًا؟

> [!success]- الإجابة
> لأن الخطأ النسبي إلى الصفر غير مفيد؛ تحتاج معيارًا مطلقًا مناسبًا.

## روابط ذات معنى

- الخريطة: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس المصدر: [[lessons/L08-errors-resources-and-testing.idea|L08 - الأخطاء والموارد والاختبارات]]
- [[notes/A39-good-tests-check-public-contracts.idea|A39 - الاختبار الجيد يفحص العقد العام]]
- [[notes/A47-relative-residual-measures-solution-quality.idea|A47 - المتبقي النسبي يقيس جودة الحل]]
- [[notes/A51-convergence-order-needs-step-sequence.idea|A51 - رتبة التقارب تقاس بسلسلة خطوات]]

