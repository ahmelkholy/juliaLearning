---
id: A07
aliases:
  - "Traits تفصل الصفة عن الوراثة"
  - "Holy traits"
  - "Trait dispatch"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/types
  - julia/interfaces
lesson: 1
source: lessons/01_dispatch_and_types.jl
up: "[[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]"
cssclasses:
  - rtl-note
---

# Traits تفصل الصفة عن الوراثة

## الفكرة

الـ trait دالة صغيرة تعيد علامة نوعية تصف صفة سلوكية. توزّع دالة أخرى على العلامة، فتختار السلوك من دون إجبار الصفة على الدخول في شجرة الوراثة.

## لماذا تهم؟

قد تشترك أنواع غير مرتبطة في كونها تملك حلًا مغلقًا أو تخزينًا متصلًا. trait تسمح لنوع خارجي بالانضمام بتعريف method واحدة وتتفادى Boolean flags المتناثرة.

## مثال Julia

```julia
abstract type EvaluationStyle end
struct ClosedForm <: EvaluationStyle end
struct Sampled <: EvaluationStyle end

evaluation_style(::Type) = Sampled()
evaluation_style(::Type{<:Number}) = ClosedForm()

describe(x) = describe(evaluation_style(typeof(x)), x)
describe(::ClosedForm, x) = "حل تحليلي للقيمة $(x)"
describe(::Sampled, _) = "تقييم عام بالعينات"

println(describe(2.0))
println(describe([1, 2, 3]))
```

## كيف تقرأ المثال؟

طريقة fallback تعطي `Sampled` لأي نوع، وطريقة أكثر تخصيصًا تختار `ClosedForm` للأعداد. طبقة `describe(x)` تحوّل الصفة إلى dispatch.

> [!example] تجربة قصيرة
> أنشئ نوعًا `PolynomialModel` واجعله `ClosedForm` بإضافة طريقة `evaluation_style` فقط.

> [!question]- سؤال استرجاع
> متى تكون trait أنسب من إضافة فرع Boolean داخل كل دالة؟

> [!success]- الإجابة
> عندما تمثل صفة سلوكية قابلة للتوسعة ولا تنتمي طبيعيًا إلى شجرة الوراثة.

## روابط ذات معنى

- الخريطة: [[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]
- الدرس المصدر: [[lessons/L01-dispatch-and-types.idea|L01 - التوزيع المتعدد والأنواع]]
- [[notes/A02-multiple-dispatch-uses-all-arguments.idea|A02 - التوزيع المتعدد يستخدم جميع أنواع الوسائط]]
- [[notes/A21-small-interfaces-unlock-generic-behavior.idea|A21 - الواجهة الصغيرة تفتح سلوكا عاما]]
- [[notes/A41-algorithm-objects-replace-central-branches.idea|A41 - كائن الخوارزمية يستبدل الفروع المركزية]]

