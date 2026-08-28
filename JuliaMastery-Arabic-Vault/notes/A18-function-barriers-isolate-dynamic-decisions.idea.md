---
id: A18
aliases:
  - "حاجز الدالة يعزل القرار الديناميكي"
  - "Function barrier"
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

# حاجز الدالة يعزل القرار الديناميكي

## الفكرة

حاجز الدالة يفصل قرارًا ديناميكيًا عند حد البرنامج عن kernel صغيرة تستقبل قيمة ملموسة النوع.

## لماذا تهم؟

قراءة configuration أو اختيار دقة وقت التشغيل أمر طبيعي. المهم ألا تعيد الحلقة الساخنة السؤال نفسه في كل iteration. ندخل النتيجة الملموسة إلى دالة أخرى فيخصصها المترجم.

## مثال Julia

```julia
function load_values(kind::Symbol, count)
    kind === :f32 && return fill(0.25f0, count)
    kind === :f64 && return fill(0.25, count)
    throw(ArgumentError("unknown kind"))
end

sum_squares(kind, count) =
    sum_squares_kernel(load_values(kind, count))

function sum_squares_kernel(values)
    total = zero(eltype(values))
    for value in values
        total += abs2(value)
    end
    return total
end

println(typeof(sum_squares(:f32, 8)))
println(typeof(sum_squares(:f64, 8)))
```

## كيف تقرأ المثال؟

`load_values` قرار ديناميكي، لكن كل نداء إلى `sum_squares_kernel` يرى `Vector{Float32}` أو `Vector{Float64}` ملموسًا.

> [!example] تجربة قصيرة
> أضف خيار `:big` يعيد `BigFloat`، من دون تعديل kernel، ثم افحص نوع النتيجة.

> [!question]- سؤال استرجاع
> أين نسمح بالديناميكية وأين نريد الأنواع الملموسة؟

> [!success]- الإجابة
> نسمح بها عند حدود الإدخال والاختيار، ثم نمرر قيمًا ملموسة إلى kernels الحسابية.

## روابط ذات معنى

- الخريطة: [[maps/M03-performance-and-compiler.idea|M03 - الأداء والمترجم]]
- الدرس المصدر: [[lessons/L03-performance-and-type-inference.idea|L03 - الأداء واستدلال الأنواع]]
- [[notes/A16-parametric-fields-expose-types.idea|A16 - الحقل البارامتري يكشف النوع للمترجم]]
- [[notes/A17-type-stability-enables-inference.idea|A17 - الاستقرار النوعي يجعل النتيجة قابلة للاستدلال]]
- [[notes/A36-small-public-apis-reduce-coupling.idea|A36 - واجهة عامة صغيرة تقلل الاقتران]]

