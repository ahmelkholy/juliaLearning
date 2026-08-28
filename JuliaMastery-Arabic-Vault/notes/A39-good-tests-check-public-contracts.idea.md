---
id: A39
aliases:
  - "الاختبار الجيد يفحص العقد العام"
  - "Behavioral tests"
  - "Public contract testing"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/testing
  - julia/design
lesson: 8
source: test/runtests.jl
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# الاختبار الجيد يفحص العقد العام

## الفكرة

اختبر ما تعد به الواجهة: النتيجة، والنوع، والـ invariant، والحواف، والفشل المقصود. لا تربط الاختبار بتفاصيل تنفيذ قابلة للتغيير.

## لماذا تهم؟

الاختبار السلوكي يسمح بإعادة بناء الداخل من دون كسر suite ما دام العقد ثابتًا. اختبار helper داخلي قد يمنع refactor بلا قيمة للمستخدم.

## مثال Julia

```julia
using Test

positive_square(x) =
    x >= 0 ? x^2 :
    throw(ArgumentError("x must be nonnegative"))

@testset "public contract" begin
    @test positive_square(3) == 9
    @test positive_square(0) == 0
    @test positive_square(2.0f0) === 4.0f0
    @test_throws ArgumentError positive_square(-1)
end
```

## كيف تقرأ المثال؟

توجد حالة طبيعية، وحد، ونوع عددي، وفشل مقصود. لا يفحص الاختبار اسم متغير أو عدد خطوات داخل الدالة.

> [!example] تجربة قصيرة
> غيّر تنفيذ `positive_square` إلى `x*x` مع بقاء الشرط. يجب أن تستمر الاختبارات في النجاح.

> [!question]- سؤال استرجاع
> ما الذي يجعل الاختبار مقاومًا لـ refactor؟

> [!success]- الإجابة
> ارتباطه بالسلوك والعقد العام بدل ترتيب الخطوات أو helpers الداخلية.

## روابط ذات معنى

- الخريطة: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس المصدر: [[lessons/L08-errors-resources-and-testing.idea|L08 - الأخطاء والموارد والاختبارات]]
- [[notes/A36-small-public-apis-reduce-coupling.idea|A36 - واجهة عامة صغيرة تقلل الاقتران]]
- [[notes/A37-narrow-catch-blocks-do-not-hide-errors.idea|A37 - catch الضيقة لا تخفي الأخطاء]]
- [[notes/A40-numerical-tolerances-follow-algorithm-accuracy.idea|A40 - التسامح العددي مشتق من دقة الخوارزمية]]

