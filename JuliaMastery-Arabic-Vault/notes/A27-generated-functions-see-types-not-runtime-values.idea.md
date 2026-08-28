---
id: A27
aliases:
  - "الدالة المولدة ترى الأنواع لا قيم التشغيل"
  - "Generated functions"
  - "Val"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/metaprogramming
  - julia/compiler
lesson: 5
source: lessons/05_metaprogramming.jl
up: "[[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]"
cssclasses:
  - rtl-note
---

# الدالة المولدة ترى الأنواع لا قيم التشغيل

## الفكرة

`@generated` تعمل أثناء التخصص وتعيد تعبيرًا مبنيًا على الأنواع ومعلماتها. لا تستطيع الاعتماد على قيم runtime.

## لماذا تهم؟

قد تعبّر عن عملية يحددها تركيب النوع، لكن الإفراط يولد كودًا ضخمًا ويزيد compilation. الدالة العادية هي الخيار الافتراضي.

## مثال Julia

```julia
@generated function field_values(value::T) where {T}
    accesses = [
        :(getfield(value, $i))
        for i in 1:fieldcount(T)
    ]
    return Expr(:tuple, accesses...)
end

struct Experiment{T,S}
    gain::T
    label::S
end

println(field_values(Experiment(2.5, :demo)))
```

## كيف تقرأ المثال؟

يعرف المولد `T` وعدد حقوله وقت التخصص، فيبني tuple من عمليات `getfield`. لا يعرف أن `gain` يساوي `2.5` وقت التوليد.

> [!example] تجربة قصيرة
> اكتب نسخة عادية تستعمل `ntuple` وقارن الوضوح. لا تفترض أن generated أسرع من دون قياس.

> [!question]- سؤال استرجاع
> ما الحد الفاصل بين ما تراه generated function وما لا تراه؟

> [!success]- الإجابة
> ترى الأنواع ومعلماتها الثابتة وقت التخصص، ولا ترى قيم التشغيل الفعلية.

## روابط ذات معنى

- الخريطة: [[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]
- الدرس المصدر: [[lessons/L05-metaprogramming.idea|L05 - البرمجة الوصفية]]
- [[notes/A25-macros-receive-syntax-not-values.idea|A25 - الماكرو يستقبل صياغة لا قيما]]
- [[notes/A26-macro-hygiene-and-esc-protect-scope.idea|A26 - نظافة الماكرو و esc تحميان النطاق]]
- [[notes/A19-warm-up-before-performance-measurement.idea|A19 - التسخين يسبق قياس الأداء]]

