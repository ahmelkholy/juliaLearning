---
id: A51
aliases:
  - "رتبة التقارب تقاس بسلسلة خطوات"
  - "Convergence order"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/ode
  - julia/numerics
  - julia/testing
lesson: 10
source: lessons/10_scientific_capstone.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# رتبة التقارب تقاس بسلسلة خطوات

## الفكرة

لا تثبت رتبة خوارزمية من تشغيل واحد. احسب الأخطاء عند سلسلة خطوات متناقصة واستخرج `log2(error_h/error_h2)` عند نصف الخطوة.

## لماذا تهم؟

إذا كان الخطأ `C*h^p`، فنسبة الخطأين تقترب من `2^p`. الدراسة تكشف هل دخلت النطاق asymptotic وهل توافق المشاهدة النظرية.

## مثال Julia

```julia
using JuliaMastery: ODEProblem, RK4, solve

f(u, _, _) = -u
exact = exp(-1)
steps = [0.1, 0.05, 0.025]

errors = map(steps) do h
    problem = ODEProblem(f, 1.0, (0.0, 1.0))
    abs(solve(problem, RK4(h)).u[end] - exact)
end

orders = log2.(errors[1:end-1] ./ errors[2:end])

println(errors)
println(orders)
```

## كيف تقرأ المثال؟

نتوقع orders قريبة من 4، لا مساوية لها تمامًا. خطوة خشنة جدًا أو صغيرة جدًا قد تبعدنا عن النطاق المناسب.

> [!example] تجربة قصيرة
> أضف `0.0125`، ثم راقب متى تتوقف الرتبة عن التحسن بسبب roundoff.

> [!question]- سؤال استرجاع
> لماذا نستخدم أكثر من قيمتي خطوة إن كانت النسبة بين اثنتين تكفي للحساب؟

> [!success]- الإجابة
> لرؤية استقرار الاتجاه واستبعاد مصادفة أو خطوة خارج نطاق التقارب.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L10-scientific-capstone.idea|L10 - المشروع العلمي الختامي]]
- [[notes/A40-numerical-tolerances-follow-algorithm-accuracy.idea|A40 - التسامح العددي مشتق من دقة الخوارزمية]]
- [[notes/A50-euler-first-order-rk4-fourth-order.idea|A50 - Euler من الرتبة الأولى و RK4 من الرابعة]]
- [[notes/A52-physical-invariants-test-entire-trajectory.idea|A52 - الثوابت الفيزيائية تختبر الحل عبر الزمن]]

