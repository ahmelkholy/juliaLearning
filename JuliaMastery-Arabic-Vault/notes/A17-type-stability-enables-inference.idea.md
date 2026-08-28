---
id: A17
aliases:
  - "الاستقرار النوعي يجعل النتيجة قابلة للاستدلال"
  - "Type stability"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/performance
  - julia/compiler
lesson: 3
source: lessons/03_performance_and_inference.jl
up: "[[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]"
cssclasses:
  - rtl-note
---

# الاستقرار النوعي يجعل النتيجة قابلة للاستدلال

## الفكرة

الدالة مستقرة نوعيًا عندما يستطيع المترجم استنتاج نوع ناتجها من أنواع مدخلاتها، من دون الحاجة إلى معرفة قيمها وقت التشغيل.

## لماذا تهم؟

الاستقرار يسمح بإنتاج كود متخصص وتخزين القيم بلا صناديق ديناميكية. عدم الاستقرار عند حدود البرنامج مقبول أحيانًا؛ الخطر هو تسربه إلى loop حسابية كبيرة.

## مثال Julia

```julia
unstable(flag::Bool) = flag ? 1 : 1.0
stable(flag::Bool) = flag ? 1.0 : 2.0

println(typeof(unstable(true)))
println(typeof(unstable(false)))
println(typeof(stable(true)))

# في REPL:
# @code_warntype unstable(true)
# @code_warntype stable(true)
```

## كيف تقرأ المثال؟

نوع `unstable` قد يكون `Int` أو `Float64` رغم ثبات نوع المدخل. في `stable` الفرعان من نوع واحد، فيعرف المترجم النتيجة.

> [!example] تجربة قصيرة
> غيّر الفرع الأول إلى `Float32(1)` وافحص union الناتج، ثم وحّد الفرعين بنوع مقصود.

> [!question]- سؤال استرجاع
> هل يعني الاستقرار النوعي أن النتيجة يجب أن تكون النوع نفسه لكل قيم المدخلات المختلفة؟

> [!success]- الإجابة
> لكل تركيبة أنواع مدخلات يجب أن يكون النوع قابلًا للاستنتاج؛ يمكن لتواقيع أنواع مختلفة أن تعطي نتائج مختلفة.

## روابط ذات معنى

- الخريطة: [[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]
- الدرس المصدر: [[lessons/L03-performance-and-type-inference.idea|L03 - الأداء واستدلال الأنواع]]
- [[notes/A16-parametric-fields-expose-types.idea|A16 - الحقل البارامتري يكشف النوع للمترجم]]
- [[notes/A18-function-barriers-isolate-dynamic-decisions.idea|A18 - حاجز الدالة يعزل القرار الديناميكي]]
- [[notes/A19-warm-up-before-performance-measurement.idea|A19 - التسخين يسبق قياس الأداء]]

