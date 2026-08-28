---
id: A48
aliases:
  - "مسألة ODE منفصلة عن طريقة الحل"
  - "ODE problem-algorithm separation"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/ode
  - julia/design
lesson: 10
source: src/ode.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# مسألة ODE منفصلة عن طريقة الحل

## الفكرة

`ODEProblem` تصف المعادلة والحالة والفترة والمعلمات، بينما كائن الخوارزمية يصف طريقة الحل وحجم الخطوة.

## لماذا تهم؟

الفصل يسمح بحل المسألة نفسها بـ Euler وRK4 وخوارزمية خارجية، ومقارنة النتائج من دون تغيير النموذج.

## مثال Julia

```julia
using JuliaMastery: ODEProblem, Euler, RK4, solve

decay(u, rate, t) = -rate * u
problem = ODEProblem(
    decay,
    1.0,
    (0.0, 1.0),
    2.0,
)

euler = solve(problem, Euler(0.01))
rk4 = solve(problem, RK4(0.01))

println((euler.u[end], rk4.u[end], exp(-2)))
```

## كيف تقرأ المثال؟

المعادلة `decay` لا تعرف الخوارزمية. و`solve` لا يعرف معنى decay؛ يستعمل عقد `f(state, parameters, time)`.

> [!example] تجربة قصيرة
> استعمل problem نفسها مع حجمي خطوة مختلفين من RK4، ولا تعدل تعريف المعادلة.

> [!question]- سؤال استرجاع
> أي كائن يحمل `f` و`u0` و`tspan`، وأي كائن يحمل `dt`؟

> [!success]- الإجابة
> `ODEProblem` تحمل تعريف المسألة، و`Euler` أو `RK4` يحملان حجم الخطوة.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L10-scientific-capstone.idea|L10 - المشروع العلمي الختامي]]
- [[notes/A41-algorithm-objects-replace-central-branches.idea|A41 - كائن الخوارزمية يستبدل الفروع المركزية]]
- [[notes/A49-extension-points-add-algorithms-without-changing-solve.idea|A49 - نقاط التوسعة تضيف خوارزمية دون تعديل solve]]
- [[notes/A50-euler-first-order-rk4-fourth-order.idea|A50 - Euler من الرتبة الأولى و RK4 من الرابعة]]

