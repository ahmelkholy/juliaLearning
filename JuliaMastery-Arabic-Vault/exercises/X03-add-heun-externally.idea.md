---
id: X03
aliases:
  - "إضافة طريقة Heun من خارج الحزمة"
type: exercise
status: queued
difficulty: متوسط
xp: 200
estimated_time: 45 دقيقة
tags:
  - practice/exercise
  - julia
up: "[[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]"
cssclasses:
  - rtl-note
---

# إضافة طريقة Heun من خارج الحزمة

> [!abstract] المهمة
> أنشئ Heun بتحقق كامل، ومد `step_size` و`step` من خارج `src`، ثم أثبت الرتبة الثانية.

## المتطلبات السابقة

- [[notes/A41-algorithm-objects-replace-central-branches.idea|A41 - كائن الخوارزمية يستبدل الفروع المركزية]]
- [[notes/A49-extension-points-add-algorithms-without-changing-solve.idea|A49 - نقاط التوسعة تضيف خوارزمية دون تعديل solve]]
- [[notes/A51-convergence-order-needs-step-sequence.idea|A51 - رتبة التقارب تقاس بسلسلة خطوات]]

## كود البداية

```julia
import JuliaMastery
using JuliaMastery: AbstractStepper, ODEProblem, solve

struct Heun{T<:Real} <: AbstractStepper
    dt::T

    function Heun(dt::T) where {T<:Real}
        # TODO: تحقق من finite وpositive
        new{T}(dt)
    end
end

JuliaMastery.step_size(method::Heun) = method.dt

function JuliaMastery.step(f, u, p, t, dt, ::Heun)
    # TODO: k1
    # TODO: predictor
    # TODO: k2
    # TODO: متوسط الميلين
    error("TODO")
end
```

## اختبارات القبول

```julia
using Test

f(u, _, _) = -2u
exact = exp(-2)
steps = [0.1, 0.05, 0.025]

errors = map(steps) do h
    problem = ODEProblem(f, 1.0, (0.0, 1.0))
    abs(solve(problem, Heun(h)).u[end] - exact)
end

orders = log2.(errors[1:end-1] ./ errors[2:end])

@test all(order -> 1.8 < order < 2.2, orders)
@test_throws ArgumentError Heun(0.0)
```

> [!hint]- تلميحات متدرجة
> 1. `predictor = u + dt*k1`.
> 2. احسب `k2` عند `t+dt` باستخدام predictor.
> 3. الخطوة هي `u + dt*(k1+k2)/2`.

## أسئلة ما بعد الحل

- لماذا لم تعدل `solve`؟
- ما الدليل التجريبي على الرتبة بدل مجرد قرب النتيجة؟

## روابط

- الخريطة: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]
- [[sources/S02-ode-solver-source.idea|S02 - كود محلل ODE]]
- [[sources/S04-advanced-exercises-source.idea|S04 - كود التمارين المتقدمة الأصلي]]
- [[lessons/L10-scientific-capstone.idea|L10 - المشروع العلمي الختامي]]

