---
id: A36
aliases:
  - "واجهة عامة صغيرة تقلل الاقتران"
  - "Small public API"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/api
  - julia/design
lesson: 7
source: src/JuliaMastery.jl
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# واجهة عامة صغيرة تقلل الاقتران

## الفكرة

صدّر أقل عدد من الأسماء التي تمثل عقدًا متماسكًا، واترك helpers والتفاصيل الداخلية قابلة للتغيير.

## لماذا تهم؟

كل اسم عام التزام على المستقبل. API صغيرة تقلل ما يجب على المستخدم تعلمه وما تكسره refactor داخلية.

## مثال Julia

```julia
module TinySolver

export Problem, RK4, solve

struct Problem{F,U}
    f::F
    u0::U
end

struct RK4{T}
    dt::T
end

_prepare(problem) = copy(problem.u0)
solve(problem::Problem, method::RK4) =
    (_prepare(problem), method.dt)

end
```

## كيف تقرأ المثال؟

`_prepare` غير مصدّرة، ويمكن تغييرها من دون تعديل كود المستخدم ما دام سلوك `solve` ثابتًا. الشرطة السفلية عرف وليست حماية أمنية.

> [!example] تجربة قصيرة
> اكتب قائمة الأسماء التي يحتاجها مستخدم حزمة ODE فعليًا، ثم افصلها عن helpers التي يحتاجها المطور فقط.

> [!question]- سؤال استرجاع
> ما معيار إدخال اسم إلى API العامة؟

> [!success]- الإجابة
> أن يحتاجه المستخدم لبناء عقد مستقر، لا أن يكون موجودًا أو مفيدًا مؤقتًا أثناء التنفيذ.

## روابط ذات معنى

- الخريطة: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس المصدر: [[lessons/L07-package-architecture.idea|L07 - معمارية الحزم]]
- [[notes/A32-files-organize-source-modules-organize-names.idea|A32 - الملفات تنظم المصدر والوحدات تنظم الأسماء]]
- [[notes/A34-using-import-export-define-api-boundaries.idea|A34 - using و import و export تحدد حدود API]]
- [[notes/A39-good-tests-check-public-contracts.idea|A39 - الاختبار الجيد يفحص العقد العام]]

