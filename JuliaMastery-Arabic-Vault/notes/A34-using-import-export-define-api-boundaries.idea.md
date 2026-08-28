---
id: A34
aliases:
  - "using و import و export تحدد حدود API"
  - "using import export"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/packages
  - julia/api
lesson: 7
source: lessons/07_package_architecture.jl
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# using و import و export تحدد حدود API

## الفكرة

`export` يعلن الأسماء المقترحة للمستخدم، و`using` يجلب أسماء للاستخدام، و`import` يعلن نية تمديد دالة من وحدة أخرى عند استعمال اسمها غير المؤهل.

## لماذا تهم؟

الاختيار الصريح يجعل الاعتمادات وحدود التوسعة قابلة للقراءة ويمنع إضافة method إلى دالة أجنبية بالخطأ.

## مثال Julia

```julia
module Library
export PublicModel, solve

struct PublicModel
    gain::Float64
end

internal_helper(x) = 2x
solve(model::PublicModel, x) = model.gain * internal_helper(x)
end

using .Library: PublicModel, solve

model = PublicModel(3.0)
println(solve(model, 2.0))
println(Library.internal_helper(2))
```

## كيف تقرأ المثال؟

الاسم الداخلي ما زال قابلًا للوصول باسم مؤهل للتشخيص، لكنه ليس جزءًا من العقد المصدّر. يستطيع المشروع تغييره لاحقًا.

> [!example] تجربة قصيرة
> استعمل `names(Library)` ثم `names(Library; all=true)` وقارن القائمتين.

> [!question]- سؤال استرجاع
> هل يعني عدم export أن الاسم خاص ومستحيل الوصول إليه؟

> [!success]- الإجابة
> لا؛ يمكن تأهيله باسم الوحدة، لكنه غير مقدم بوصفه API مستقرة للمستخدم.

## روابط ذات معنى

- الخريطة: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس المصدر: [[lessons/L07-package-architecture.idea|L07 - معمارية الحزم]]
- [[notes/A32-files-organize-source-modules-organize-names.idea|A32 - الملفات تنظم المصدر والوحدات تنظم الأسماء]]
- [[notes/A33-include-evaluates-files-in-current-module.idea|A33 - include يقيم الملف داخل الوحدة الحالية]]
- [[notes/A36-small-public-apis-reduce-coupling.idea|A36 - واجهة عامة صغيرة تقلل الاقتران]]

