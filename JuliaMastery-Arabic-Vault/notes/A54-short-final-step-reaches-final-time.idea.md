---
id: A54
aliases:
  - "الخطوة الأخيرة القصيرة تصل إلى الزمن النهائي"
  - "Short final ODE step"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/ode
  - julia/numerics
lesson: 10
source: src/ode.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# الخطوة الأخيرة القصيرة تصل إلى الزمن النهائي

## الفكرة

إذا لم تقسم `dt` الفترة الزمنية تمامًا، قصّر الخطوة الأخيرة إلى المسافة المتبقية بدل تجاوز `tf` أو التوقف قبله.

## لماذا تهم؟

الوصول الدقيق إلى حد المسألة جزء من العقد. تغيير الخطوة الأخيرة قليلًا يحافظ على الخوارزمية ويمنع خطأ توقيت تراكمي واضح.

## مثال Julia

```julia
using JuliaMastery: ODEProblem, Euler, solve

problem = ODEProblem(
    (u, _, _) -> -u,
    1.0,
    (0.0, 1.0),
)

solution = solve(problem, Euler(0.3))

println(solution.t)
println(last(solution.t))
@assert last(solution.t) == 1.0
```

## كيف تقرأ المثال؟

الخطوات الاسمية `0.3` تصل إلى `0.9`، ثم تكون الخطوة الفعلية `0.1`. داخل solver تحسب بـ `min(nominal_dt, stop_time-time)`.

> [!example] تجربة قصيرة
> استعمل `dt=0.07` وافحص آخر زمن وعدد الحالات. ثم جرّب `save_every` مختلفًا.

> [!question]- سؤال استرجاع
> لماذا لا نكتفي بحلقة `for t in t0:dt:tf` دائمًا؟

> [!success]- الإجابة
> لأن range قد لا تحتوي `tf` عندما لا تقسم الخطوة الفترة، وقد تحتاج contract حفظ وتقصير واضحين.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L10-scientific-capstone.idea|L10 - المشروع العلمي الختامي]]
- [[notes/A48-ode-problem-is-separated-from-solver.idea|A48 - مسألة ODE منفصلة عن طريقة الحل]]
- [[notes/A50-euler-first-order-rk4-fourth-order.idea|A50 - Euler من الرتبة الأولى و RK4 من الرابعة]]
- [[notes/A53-copying-saved-states-prevents-aliasing.idea|A53 - نسخ الحالات المحفوظة يمنع aliasing]]

