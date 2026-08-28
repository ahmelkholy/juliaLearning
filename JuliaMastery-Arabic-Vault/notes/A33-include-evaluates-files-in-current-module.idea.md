---
id: A33
aliases:
  - "include يقيم الملف داخل الوحدة الحالية"
  - "include"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/packages
  - julia/modules
lesson: 7
source: lessons/07_package_architecture.jl
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# include يقيم الملف داخل الوحدة الحالية

## الفكرة

`include(path)` يقرأ ملف Julia ويقيّمه داخل الوحدة التي استدعت include. ليس import وقت تشغيل مشابهًا لـ Python.

## لماذا تهم؟

لذلك لا تحتاج ملفات `src` داخل الوحدة إلى import متبادل، ويجب تضمين كل ملف مرة واحدة. تثبيت المسار بـ `@__DIR__` يجعل سكربت الدرس مستقلًا عن مجلد الطرفية.

## مثال Julia

```julia
module Demo

include_string(
    @__MODULE__,
    "helper(x) = 2x",
    "helper.jl",
)

println(helper(3))

# في مشروع فعلي:
# include(joinpath(@__DIR__, "helper.jl"))

end
```

## كيف تقرأ المثال؟

`include_string` يوضح الدلالة بلا ملف خارجي: التعريف ظهر داخل `Demo`. `include` الفعلية تفعل الشيء نفسه مع ملف.

> [!example] تجربة قصيرة
> في REPL أنشئ module صغيرة واستعمل `include_string` لتعريف نوع، ثم افحص `parentmodule` له.

> [!question]- سؤال استرجاع
> لماذا قد يؤدي include يدوي لملفات حزمة من تطبيق إلى أنواع تبدو متشابهة لكنها غير متطابقة؟

> [!success]- الإجابة
> لأنه قد يقيّم التعريفات مرة أخرى داخل module أخرى، فتكون هوية النوع مختلفة.

## روابط ذات معنى

- الخريطة: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس المصدر: [[lessons/L07-package-architecture.idea|L07 - معمارية الحزم]]
- [[notes/A32-files-organize-source-modules-organize-names.idea|A32 - الملفات تنظم المصدر والوحدات تنظم الأسماء]]
- [[notes/A34-using-import-export-define-api-boundaries.idea|A34 - using و import و export تحدد حدود API]]
- [[notes/A35-project-and-manifest-fix-package-environment.idea|A35 - Project و Manifest يثبتان بيئة الحزمة]]

