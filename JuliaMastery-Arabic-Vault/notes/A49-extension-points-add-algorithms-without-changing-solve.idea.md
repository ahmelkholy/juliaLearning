---
id: A49
aliases:
  - "نقاط التوسعة تضيف خوارزمية دون تعديل solve"
  - "Extension points"
  - "Open closed design"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/ode
  - julia/dispatch
  - julia/api
lesson: 10
source: src/ode.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# نقاط التوسعة تضيف خوارزمية دون تعديل solve

## الفكرة

الحزمة الجيدة تتيح إضافة خوارزمية جديدة بتعريف نوع وطرق لنقاط توسعة معلنة، من دون فتح قلب `solve` وتعديله.

## لماذا تهم؟

هذا يحقق توسعة مفتوحة مع مركز مستقر، ويسمح لحزمة أو ملف خارجي بالمشاركة من دون fork.

## مثال Julia

```julia
import JuliaMastery
using JuliaMastery: AbstractStepper, ODEProblem, solve

struct Heun{T<:Real} <: AbstractStepper
    dt::T
end

JuliaMastery.step_size(method::Heun) = method.dt

function JuliaMastery.step(f, u, p, t, dt, ::Heun)
    k1 = f(u, p, t)
    predictor = u + dt * k1
    k2 = f(predictor, p, t + dt)
    return u + (dt / 2) * (k1 + k2)
end

problem = ODEProblem((u, _, _) -> -u, 1.0, (0.0, 1.0))
println(solve(problem, Heun(0.01)).u[end])
```

## كيف تقرأ المثال؟

استعملنا الاسم المؤهل `JuliaMastery.step` و`step_size` لإضافة methods إلى دوال الحزمة. لم نغيّر `src/ode.jl`.

> [!example] تجربة قصيرة
> أضف inner constructor يتحقق من أن `dt` موجبة وfinite، ثم اختبر الرتبة الثانية.

> [!question]- سؤال استرجاع
> ما علامتا نجاح نقطة التوسعة هنا؟

> [!success]- الإجابة
> أن النوع الجديد يعمل عبر `solve` وأن إضافة الدعم لم تتطلب تعديل `solve` أو switch مركزية.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L10-scientific-capstone.idea|L10 - المشروع العلمي الختامي]]
- [[notes/A02-multiple-dispatch-uses-all-arguments.idea|A02 - التوزيع المتعدد يستخدم جميع أنواع الوسائط]]
- [[notes/A34-using-import-export-define-api-boundaries.idea|A34 - using و import و export تحدد حدود API]]
- [[notes/A48-ode-problem-is-separated-from-solver.idea|A48 - مسألة ODE منفصلة عن طريقة الحل]]

