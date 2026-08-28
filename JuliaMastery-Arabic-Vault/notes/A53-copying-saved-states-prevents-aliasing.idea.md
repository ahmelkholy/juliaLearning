---
id: A53
aliases:
  - "نسخ الحالات المحفوظة يمنع aliasing"
  - "Saved-state ownership"
  - "Aliasing prevention"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/ode
  - julia/memory
lesson: 10
source: src/ode.jl
up: "[[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]"
cssclasses:
  - rtl-note
---

# نسخ الحالات المحفوظة يمنع aliasing

## الفكرة

عند حفظ تاريخ حالات mutable، ادفع `copy(state)` لا المرجع نفسه، وإلا قد تشير كل اللقطات إلى الذاكرة نفسها.

## لماذا تهم؟

الحل يجب أن يملك snapshots مستقلة. aliasing يجعل تعديل حالة لاحقة أو تعديل المستخدم للنتيجة يغير الماضي أو المدخل الأصلي.

## مثال Julia

```julia
state = [1.0, 0.0]
safe_history = Vector{Vector{Float64}}()
unsafe_history = Vector{Vector{Float64}}()

push!(safe_history, copy(state))
push!(unsafe_history, state)

state[1] = 99.0

println(safe_history[1])
println(unsafe_history[1])
```

## كيف تقرأ المثال؟

النسخة الآمنة بقيت `[1,0]`، بينما التاريخ غير الآمن يرى التعديل لأنه يحمل المرجع نفسه.

> [!example] تجربة قصيرة
> ادفع `state` نفسها ثلاث مرات ثم عدل عنصرًا واحدًا. استعمل `===` لفحص هوية المصفوفات.

> [!question]- سؤال استرجاع
> متى لا تكون `copy` السطحية كافية؟

> [!success]- الإجابة
> عندما تحتوي الحالة نفسها مراجع داخلية mutable تحتاج snapshots مستقلة؛ قد تحتاج `deepcopy` أو تصميم ملكية أوضح.

## روابط ذات معنى

- الخريطة: [[maps/M07-scientific-algorithms.idea|M07 - الخوارزميات العلمية]]
- الدرس المصدر: [[lessons/L10-scientific-capstone.idea|L10 - المشروع العلمي الختامي]]
- [[notes/A10-views-share-memory-slices-copy.idea|A10 - العرض يشارك الذاكرة والشريحة تنسخ]]
- [[notes/A20-mutating-functions-clarify-memory-ownership.idea|A20 - الدالة المعدلة توضح ملكية الذاكرة]]
- [[notes/A48-ode-problem-is-separated-from-solver.idea|A48 - مسألة ODE منفصلة عن طريقة الحل]]

