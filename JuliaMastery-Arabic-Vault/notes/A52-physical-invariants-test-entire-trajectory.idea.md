---
id: A52
aliases:
  - "الثوابت الفيزيائية تختبر الحل عبر الزمن"
  - "Physical invariants"
  - "Energy drift"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/ode
  - julia/scientific-computing
  - julia/testing
lesson: 10
source: lessons/10_scientific_capstone.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# الثوابت الفيزيائية تختبر الحل عبر الزمن

## الفكرة

إذا كان للنموذج invariant مثل الطاقة، فراقب انحرافه عبر المسار كله، لا دقة نقطة النهاية فقط.

## لماذا تهم؟

قد تنجح نقطة أخيرة بالمصادفة بينما يتشوه السلوك بينهما. invariant تربط الاختبار بمعنى النموذج الفيزيائي.

## مثال Julia

```julia
using LinearAlgebra
using JuliaMastery: ODEProblem, Euler, RK4, solve

ω = 2.0
oscillator(state, _, _) =
    [state[2], -(ω^2) * state[1]]
energy(state) =
    0.5 * (state[2]^2 + (ω * state[1])^2)

problem = ODEProblem(
    oscillator,
    [1.0, 0.0],
    (0.0, 10.0),
)

for method in (Euler(0.01), RK4(0.01))
    solution = solve(problem, method; save_every=10)
    e0 = energy(first(solution.u))
    drift = maximum(abs(energy(u) - e0) for u in solution.u)
    println((typeof(method), drift))
end
```

## كيف تقرأ المثال؟

المقياس هو أكبر انحراف عن الطاقة الابتدائية. في هذه التجربة يكون drift لـ RK4 أصغر، لكن حفظ الطاقة طويل الأمد قد يحتاج طرقًا هندسية خاصة.

> [!example] تجربة قصيرة
> ضاعف الزمن النهائي وراقب كيف ينمو drift لكل طريقة.

> [!question]- سؤال استرجاع
> لماذا يكون invariant أحيانًا اختبارًا أقوى من مقارنة الحالة النهائية وحدها؟

> [!success]- الإجابة
> لأنه يفحص السلوك خلال المسار ويرتبط بقانون يجب أن يحفظه النموذج لا بنقطة واحدة.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L10-scientific-capstone.idea|L10 - المشروع العلمي الختامي]]
- [[notes/A39-good-tests-check-public-contracts.idea|A39 - الاختبار الجيد يفحص العقد العام]]
- [[notes/A50-euler-first-order-rk4-fourth-order.idea|A50 - Euler من الرتبة الأولى و RK4 من الرابعة]]
- [[notes/A51-convergence-order-needs-step-sequence.idea|A51 - رتبة التقارب تقاس بسلسلة خطوات]]

