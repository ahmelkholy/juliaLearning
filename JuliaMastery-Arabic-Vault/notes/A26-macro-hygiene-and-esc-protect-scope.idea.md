---
id: A26
aliases:
  - "نظافة الماكرو و esc تحميان النطاق"
  - "Macro hygiene"
  - "esc"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/metaprogramming
  - julia/scoping
lesson: 5
source: lessons/05_metaprogramming.jl
up: "[[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]"
cssclasses:
  - rtl-note
---

# نظافة الماكرو و esc تحميان النطاق

## الفكرة

نظافة الماكرو تعيد تسمية متغيراته المحلية حتى لا تلتقط أسماء المستدعي. `esc` تجعل الصياغة القادمة من المستدعي تُحل في نطاقه هو.

## لماذا تهم؟

من دون النظافة قد يغيّر الماكرو متغيرًا لا يقصده. ومن دون `esc` قد يبحث تعبير المستخدم عن أسمائه داخل وحدة تعريف الماكرو.

## مثال Julia

```julia
is_finite_value(x::Number) = isfinite(x)
is_finite_value(xs) = all(isfinite, xs)

macro ensure_finite(expression)
    return quote
        local result = $(esc(expression))
        is_finite_value(result) ||
            throw(DomainError(result, "non-finite result"))
        result
    end
end

function demo()
    scale = 3.0
    result = "لن يتغير"
    values = @ensure_finite scale .* [1.0, 2.0]
    return result, values
end

println(demo())
```

## كيف تقرأ المثال؟

`result` داخل الماكرو يحصل على اسم hygienic مختلف عن `result` في `demo`. أما `scale` في تعبير المستخدم فيُحل داخل `demo` بفضل `esc`.

> [!example] تجربة قصيرة
> احذف `esc` مؤقتًا، شغّل المثال، واقرأ خطأ النطاق. أعدها قبل متابعة العمل.

> [!question]- سؤال استرجاع
> أي جزء نهربه عادةً بـ `esc`: المتغيرات الداخلية أم تعبير المستدعي؟

> [!success]- الإجابة
> تعبير المستدعي الذي يجب أن يرى نطاقه؛ تبقى المتغيرات الداخلية hygienic.

## روابط ذات معنى

- الخريطة: [[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]
- الدرس المصدر: [[lessons/L05-metaprogramming.idea|L05 - البرمجة الوصفية]]
- [[notes/A25-macros-receive-syntax-not-values.idea|A25 - الماكرو يستقبل صياغة لا قيما]]
- [[notes/A27-generated-functions-see-types-not-runtime-values.idea|A27 - الدالة المولدة ترى الأنواع لا قيم التشغيل]]
- [[notes/A37-narrow-catch-blocks-do-not-hide-errors.idea|A37 - catch الضيقة لا تخفي الأخطاء]]

