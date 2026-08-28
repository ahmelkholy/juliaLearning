---
id: A16
aliases:
  - "الحقل البارامتري يكشف النوع للمترجم"
  - "Parametric fields"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/performance
  - julia/types
lesson: 3
source: lessons/03_performance_and_inference.jl
up: "[[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]"
cssclasses:
  - rtl-note
---

# الحقل البارامتري يكشف النوع للمترجم

## الفكرة

عندما تعلن حقلًا بنوع مجرد، لا يحمل نوع الكائن الخارجي هوية النوع الملموس المخزن. جعل نوع الحقل parameter يسجل هذه المعلومة في النوع.

## لماذا تهم؟

في الكود الساخن، معرفة النوع الملموس تتيح specialization واستدلالًا أقوى. هذا يختلف عن وسيط دالة من نوع `AbstractVector`، لأن Julia تخصص الدالة عادةً على نوع الوسيط الفعلي.

## مثال Julia

```julia
struct AbstractFieldKernel
    coefficients::AbstractVector
end

struct ParametricKernel{V<:AbstractVector}
    coefficients::V
end

a = AbstractFieldKernel(rand(3))
p = ParametricKernel(rand(3))

println(typeof(a))
println(typeof(p))
```

## كيف تقرأ المثال؟

نوع `a` لا يعرض نوع المتجه في اسمه، بينما `typeof(p)` يحتوي `Vector{Float64}`. المعلومة أصبحت جزءًا من هوية الكائن.

> [!example] تجربة قصيرة
> أنشئ `ParametricKernel(Float32[1,2])` ونسخة من range، وقارن الأنواع الناتجة.

> [!question]- سؤال استرجاع
> لماذا لا تكون المشكلة نفسها عند كتابة `f(x::AbstractVector)`؟

> [!success]- الإجابة
> لأن dispatch يخصص `f` عادةً على النوع الملموس للوسيط، أما الحقل المجرد فيخفي النوع داخل كائن نوعه الخارجي ثابت.

## روابط ذات معنى

- الخريطة: [[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]
- الدرس المصدر: [[lessons/L03-performance-and-type-inference.idea|L03 - الأداء واستدلال الأنواع]]
- [[notes/A03-abstract-families-concrete-data.idea|A03 - النوع المجرد عائلة والنوع الملموس بيانات]]
- [[notes/A17-type-stability-enables-inference.idea|A17 - الاستقرار النوعي يجعل النتيجة قابلة للاستدلال]]
- [[notes/A18-function-barriers-isolate-dynamic-decisions.idea|A18 - حاجز الدالة يعزل القرار الديناميكي]]

