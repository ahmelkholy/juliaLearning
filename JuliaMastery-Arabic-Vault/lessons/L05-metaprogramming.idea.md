---
id: L05
aliases:
  - "الدرس 5: البرمجة الوصفية"
type: source-note
status: complete
tags:
  - course/lesson
  - course/lesson-05
  - julia
lesson: 5
source: lessons/05_metaprogramming.jl
up: "[[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]"
cssclasses:
  - rtl-note
---

# الدرس 5: البرمجة الوصفية

> [!goal] هدف الدرس
> أن تفرق بين الصياغة والقيمة، وتقرأ macro expansion، وتستعمل `esc` بوعي.

## قبل التشغيل

توقع هل يستطيع متغير الماكرو المحلي `result` تغيير متغير للمستدعي يحمل الاسم نفسه.

## شبكة المفاهيم

- [[notes/A25-macros-receive-syntax-not-values.idea|A25 - الماكرو يستقبل صياغة لا قيما]]
- [[notes/A26-macro-hygiene-and-esc-protect-scope.idea|A26 - نظافة الماكرو و esc تحميان النطاق]]
- [[notes/A27-generated-functions-see-types-not-runtime-values.idea|A27 - الدالة المولدة ترى الأنواع لا قيم التشغيل]]

## شغّل الدرس

من جذر المستودع:

```bash
julia --project=. lessons/05_metaprogramming.jl
```

## مسار التنفيذ

يعرف الدرس ماكرو يفحص finite data من دون تقييم مكرر، ثم generated function للحقول، ثم مثال `Val{N}` يفك قوة صغيرة.

## الكود الكامل

```julia
module Lesson05Metaprogramming

# A macro receives syntax before execution, not computed values. `esc` resolves
# caller code in the caller's scope, while the local variable is renamed
# hygienically so it cannot capture a caller variable by accident.
is_finite_value(value::Number) = isfinite(value)
is_finite_value(values) = all(isfinite, values)

macro ensure_finite(expression)
    return quote
        local result = $(esc(expression))
        is_finite_value(result) || throw(DomainError(result, "expression produced non-finite data"))
        result
    end
end

# A generated function runs during specialization and returns an expression. It
# can inspect types but not runtime values. Prefer a normal function unless code
# generation provides a measured benefit or expresses something genuinely clearer.
@generated function field_values(value::T) where {T}
    accesses = [:(getfield(value, $index)) for index in 1:fieldcount(T)]
    return Expr(:tuple, accesses...)
end

# Putting N inside `Val{N}` makes it part of the type, so generation can see it.
# Unrolling is reasonable for small N, but large values inflate compiled code;
# a normal loop is then the better choice.
@generated function literal_power(x, ::Val{N}) where {N}
    N isa Integer && N >= 0 || error("N must be a nonnegative integer")
    expression = :(one(x))
    for _ in 1:N
        expression = :($expression * x)
    end
    return expression
end

struct Experiment{T,S}
    gain::T
    label::S
end

function main()
    scale = 3.0
    values = @ensure_finite scale .* [1.0, 2.0, 3.0]
    @assert values == [3.0, 6.0, 9.0]
    @assert field_values(Experiment(2.5, :demo)) == (2.5, :demo)
    @assert literal_power(2, Val(10)) == 1024

    expanded = macroexpand(@__MODULE__, :(@ensure_finite scale + 1))
    println("Expression tree:")
    dump(:(scale .* values); maxdepth=3)
    println("Hygienic macro expansion: ", expanded)
    println("Fields returned by the generated function: ", field_values(Experiment(2.5, :demo)))
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
```

## تجارب مقصودة

- افحص `macroexpand` ثم تتبع الاسم hygienic.
- احذف `esc` مؤقتًا وافهم خطأ النطاق.
- قارن `literal_power` بحلقة عادية لقيم N مختلفة.

> [!question]- اختبار استرجاع
> لماذا لا تستطيع generated function اتخاذ قرار من قيمة runtime؟

> [!success]- الإجابة
> لأنها تعمل وقت التخصص وترى الأنواع ومعلماتها، قبل توفر قيم التشغيل.

## الملاحة

- الخريطة الأعلى: [[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]
- الدرس التالي: [[lessons/L06-concurrency.idea|L06 - التزامن]]

