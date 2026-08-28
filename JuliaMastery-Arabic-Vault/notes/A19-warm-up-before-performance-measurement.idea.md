---
id: A19
aliases:
  - "التسخين يسبق قياس الأداء"
  - "Warm-up before benchmarking"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/performance
  - julia/benchmarking
lesson: 3
source: lessons/03_performance_and_inference.jl
up: "[[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]"
cssclasses:
  - rtl-note
---

# التسخين يسبق قياس الأداء

## الفكرة

النداء الأول لتركيبة أنواع جديدة قد يشمل ترجمة method. قياس هذا النداء يخلط زمن compilation بزمن التنفيذ المستقر.

## لماذا تهم؟

إذا قارنت دالتين من دون تسخين عادل فقد تحكم على وقت المترجم لا على الخوارزمية. التسخين والقياس داخل دالة ومدخلات ثابتة الشروط يجعل المقارنة قابلة للتفسير.

## مثال Julia

```julia
function sum_squares(values)
    total = zero(eltype(values))
    for value in values
        total += abs2(value)
    end
    return total
end

values = rand(10_000)
sum_squares(values)  # تسخين الطريقة نفسها
bytes = @allocated sum_squares(values)

println((result=sum_squares(values), allocated=bytes))
```

## كيف تقرأ المثال؟

`@allocated` يقيس الذاكرة المخصصة، لا الزمن. ولقياس جاد متكرر استخدم BenchmarkTools مع interpolation للمدخلات.

> [!example] تجربة قصيرة
> قِس التخصيص قبل التسخين وبعده في جلسة جديدة. لا تستنتج من مرة واحدة؛ كرر بشروط متساوية.

> [!question]- سؤال استرجاع
> ما الذي قد يدخل في زمن النداء الأول ولا يتكرر في النداءات التالية؟

> [!success]- الإجابة
> ترجمة method المتخصصة وتحضير الكود، إضافة إلى التنفيذ الفعلي.

## روابط ذات معنى

- الخريطة: [[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]
- الدرس المصدر: [[lessons/L03-performance-and-type-inference.idea|L03 - الأداء واستدلال الأنواع]]
- [[notes/A17-type-stability-enables-inference.idea|A17 - الاستقرار النوعي يجعل النتيجة قابلة للاستدلال]]
- [[notes/A20-mutating-functions-clarify-memory-ownership.idea|A20 - الدالة المعدلة توضح ملكية الذاكرة]]
- [[notes/A09-dense-matrices-are-column-major.idea|A09 - المصفوفات الكثيفة تخزن بالأعمدة]]

