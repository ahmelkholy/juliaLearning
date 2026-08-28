---
id: L10
aliases:
  - "الدرس 10: المشروع العلمي الختامي"
type: source-note
status: complete
tags:
  - course/lesson
  - course/lesson-10
  - julia
lesson: 10
source: lessons/10_scientific_capstone.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# الدرس 10: المشروع العلمي الختامي

> [!goal] هدف الدرس
> أن تربط نموذجًا مستقلًا بمحلّل عام، وتقيس invariant ورتبة تقارب بدل الاكتفاء بنتيجة جميلة.

## قبل التشغيل

توقع أي من Euler وRK4 يملك energy drift أصغر للخطوة نفسها، وما نسبة خطأ RK4 عند نصف الخطوة.

## شبكة المفاهيم

- [[notes/A48-ode-problem-is-separated-from-solver.idea|A48 - مسألة ODE منفصلة عن طريقة الحل]]
- [[notes/A49-extension-points-add-algorithms-without-changing-solve.idea|A49 - نقاط التوسعة تضيف خوارزمية دون تعديل solve]]
- [[notes/A50-euler-first-order-rk4-fourth-order.idea|A50 - Euler من الرتبة الأولى و RK4 من الرابعة]]
- [[notes/A51-convergence-order-needs-step-sequence.idea|A51 - رتبة التقارب تقاس بسلسلة خطوات]]
- [[notes/A52-physical-invariants-test-entire-trajectory.idea|A52 - الثوابت الفيزيائية تختبر الحل عبر الزمن]]
- [[notes/A53-copying-saved-states-prevents-aliasing.idea|A53 - نسخ الحالات المحفوظة يمنع aliasing]]
- [[notes/A54-short-final-step-reaches-final-time.idea|A54 - الخطوة الأخيرة القصيرة تصل إلى الزمن النهائي]]

## شغّل الدرس

من جذر المستودع:

```bash
julia --project=. lessons/10_scientific_capstone.jl
```

## مسار التنفيذ

يعرّف الدرس مهتزًا callable، يحل النموذج بطريقتين، يقيس energy drift، ثم يبني دراسة تقارب RK4 على ثلاث خطوات.

## الكود الكامل

```julia
module Lesson10ScientificCapstone

using LinearAlgebra
using JuliaMastery: Euler, ODEProblem, RK4, solve

# The final lesson combines a model, immutable data, an algorithm object, and a
# generic solver. The model does not know solver details, and the solver does not
# know oscillator details. This separation lets the design outlive one script.
struct Oscillator{T<:Real}
    angular_frequency::T
end

function (model::Oscillator)(state, _, _)
    position, velocity = state
    return [velocity, -(model.angular_frequency^2) * position]
end

energy(state, model::Oscillator) = 0.5 * (state[2]^2 + (model.angular_frequency * state[1])^2)

function maximum_energy_drift(solution, model)
    initial_energy = energy(first(solution.u), model)
    return maximum(state -> abs(energy(state, model) - initial_energy), solution.u)
end

function convergence_order(model, initial_state, final_time, step_sizes)
    errors = map(step_sizes) do step
        problem = ODEProblem(model, initial_state, (0.0, final_time))
        numerical = solve(problem, RK4(step)).u[end]
        exact = [cos(model.angular_frequency * final_time), -model.angular_frequency * sin(model.angular_frequency * final_time)]
        norm(numerical - exact)
    end
    orders = log2.(errors[1:end-1] ./ errors[2:end])
    return errors, orders
end

function main()
    model = Oscillator(2.0)
    problem = ODEProblem(model, [1.0, 0.0], (0.0, 20.0))
    euler_solution = solve(problem, Euler(0.01); save_every=10)
    rk4_solution = solve(problem, RK4(0.01); save_every=10)

    euler_drift = maximum_energy_drift(euler_solution, model)
    rk4_drift = maximum_energy_drift(rk4_solution, model)
    @assert rk4_drift < euler_drift
    @assert last(rk4_solution.t) == 20.0

    errors, observed_orders = convergence_order(model, [1.0, 0.0], 1.0, [0.1, 0.05, 0.025])
    @assert all(order -> order > 3.8, observed_orders)

    println("Maximum Euler energy drift: ", euler_drift)
    println("Maximum RK4 energy drift: ", rk4_drift)
    println("RK4 errors: ", errors)
    println("Measured convergence orders: ", observed_orders)
    println("Next project: port a real MATLAB or Python model and compare the results.")
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
```

## تجارب مقصودة

- ضاعف زمن المحاكاة وقارن drift.
- أضف خطوة رابعة إلى دراسة التقارب.
- انقل نموذجًا موثوقًا من MATLAB أو Python وقارن نتائجه.

> [!question]- اختبار استرجاع
> لماذا لا تثبت دقة الطريقة من تشغيل واحد؟

> [!success]- الإجابة
> لأن الرتبة ادعاء عن تغير الخطأ مع الخطوة؛ يلزم refinement sequence لإظهار النمط.

## الملاحة

- الخريطة الأعلى: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- انتقل إلى خريطة التمارين: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]

