---
id: A50
aliases:
  - "Euler من الرتبة الأولى و RK4 من الرابعة"
  - "Euler and RK4 accuracy"
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

# Euler من الرتبة الأولى و RK4 من الرابعة

## الفكرة

الخطأ العالمي لطريقة Euler يتناسب تقريبًا مع `dt`، بينما RK4 يتناسب مع `dt^4` في نطاق التقارب.

## لماذا تهم؟

الرتبة تحدد كيف يستجيب الخطأ لتصغير الخطوة، لكن RK4 تستعمل أربع عينات للميل في كل خطوة. المقارنة تشمل الدقة والكلفة والاستقرار.

## مثال Julia

```julia
using JuliaMastery: ODEProblem, Euler, RK4, solve

problem = ODEProblem(
    (u, rate, _) -> -rate * u,
    1.0,
    (0.0, 1.0),
    2.0,
)

for method in (Euler(0.1), RK4(0.1))
    value = solve(problem, method).u[end]
    println((typeof(method), value, abs(value - exp(-2))))
end
```

## كيف تقرأ المثال؟

حجم الخطوة نفسه لا يعني الكلفة نفسها؛ RK4 تقيم المشتق أربع مرات في الخطوة. لكنها تحقق خطأ أصغر بكثير عادةً.

> [!example] تجربة قصيرة
> كرر بـ `dt=0.05` واحسب نسبة الخطأ القديم إلى الجديد لكل طريقة.

> [!question]- سؤال استرجاع
> كم تتوقع أن ينخفض خطأ Euler وRK4 تقريبًا عند نصف الخطوة؟

> [!success]- الإجابة
> Euler بنحو 2، وRK4 بنحو 16، إذا كنا في نطاق التقارب ولم يهيمن roundoff.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L10-scientific-capstone.idea|L10 - المشروع العلمي الختامي]]
- [[notes/A48-ode-problem-is-separated-from-solver.idea|A48 - مسألة ODE منفصلة عن طريقة الحل]]
- [[notes/A51-convergence-order-needs-step-sequence.idea|A51 - رتبة التقارب تقاس بسلسلة خطوات]]
- [[notes/A52-physical-invariants-test-entire-trajectory.idea|A52 - الثوابت الفيزيائية تختبر الحل عبر الزمن]]

