---
id: M03
aliases:
  - خريطة الأداء
type: moc
tags:
  - moc
  - julia/performance
up: "[[maps/M00-julia-mastery-map.idea|M00 - خريطة إتقان Julia]]"
cssclasses:
  - rtl-note
---

# الأداء والمترجم

## الفكرة المركزية

Julia سريعة عندما تصل أنواع ملموسة إلى kernel واضحة. القياس يأتي بعد صحة الخوارزمية وبعد فصل وقت الترجمة عن وقت التنفيذ.

## عقد الخريطة

- [[notes/A16-parametric-fields-expose-types.idea|A16 - الحقل البارامتري يكشف النوع للمترجم]]
- [[notes/A17-type-stability-enables-inference.idea|A17 - الاستقرار النوعي يجعل النتيجة قابلة للاستدلال]]
- [[notes/A18-function-barriers-isolate-dynamic-decisions.idea|A18 - حاجز الدالة يعزل القرار الديناميكي]]
- [[notes/A19-warm-up-before-performance-measurement.idea|A19 - التسخين يسبق قياس الأداء]]
- [[notes/A20-mutating-functions-clarify-memory-ownership.idea|A20 - الدالة المعدلة توضح ملكية الذاكرة]]

## أدوات الفحص

```julia
@which f(x)
@code_warntype f(x)
@code_typed f(x)
@allocated f(x)
```

افتح [[lessons/L03-performance-and-type-inference.idea|L03 - الأداء واستدلال الأنواع]] وارجع إلى [[notes/A09-dense-matrices-are-column-major.idea|A09 - المصفوفات الكثيفة تخزن بالأعمدة]] عند تحليل حلقات المصفوفات.

