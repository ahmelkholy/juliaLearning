---
id: A32
aliases:
  - "الملفات تنظم المصدر والوحدات تنظم الأسماء"
  - "Files versus modules"
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

# الملفات تنظم المصدر والوحدات تنظم الأسماء

## الفكرة

الملف وحدة تنظيم للنص المصدر، وليس namespace. الوحدة `module` هي التي تنشئ مساحة أسماء وهوية للأنواع والدوال.

## لماذا تهم؟

إنشاء submodule لكل ملف يزيد التأهيل والاستيراد بلا حد حقيقي. وتقسيم الكود على ملفات داخل الوحدة نفسها يسمح للدوال باستدعاء بعضها مباشرة.

## مثال Julia

```julia
module SmallPackage

include("types.jl")
include("algorithms.jl")

export Model, solve

end
```

## كيف تقرأ المثال؟

إذا عرّف `types.jl` النوع `Model` وعرّف `algorithms.jl` الدالة `solve`، فكلاهما يعيش داخل `SmallPackage`. ترتيب include يحدد أي تعريفات تكون متاحة أولًا.

> [!example] تجربة قصيرة
> ارسم شجرة: package واحدة، module واحدة، وملفان. اكتب بجانب كل عنصر هل ينشئ namespace أم ينظم المصدر.

> [!question]- سؤال استرجاع
> هل انتقال دالة إلى ملف آخر داخل الوحدة يغير اسمها المؤهل؟

> [!success]- الإجابة
> لا؛ تبقى في namespace الوحدة نفسها ما دام الملف يقيّم داخلها.

## روابط ذات معنى

- الخريطة: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس المصدر: [[lessons/L07-package-architecture.idea|L07 - معمارية الحزم]]
- [[notes/A33-include-evaluates-files-in-current-module.idea|A33 - include يقيم الملف داخل الوحدة الحالية]]
- [[notes/A34-using-import-export-define-api-boundaries.idea|A34 - using و import و export تحدد حدود API]]
- [[notes/A36-small-public-apis-reduce-coupling.idea|A36 - واجهة عامة صغيرة تقلل الاقتران]]

