---
id: X08
aliases:
  - "بناء حزمة Julia صغيرة قابلة للتطوير"
type: exercise
status: queued
difficulty: متقدم
xp: 350
estimated_time: 90 دقيقة
tags:
  - practice/exercise
  - julia
up: "[[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]"
cssclasses:
  - rtl-note
---

# بناء حزمة Julia صغيرة قابلة للتطوير

> [!abstract] المهمة
> أنشئ حزمة مستقلة، اقسمها حسب المسؤولية، واستخدمها من تطبيق منفصل عبر `Pkg.develop` مع API أقل من عشرة أسماء.

## المتطلبات السابقة

- [[notes/A32-files-organize-source-modules-organize-names.idea|A32 - الملفات تنظم المصدر والوحدات تنظم الأسماء]]
- [[notes/A33-include-evaluates-files-in-current-module.idea|A33 - include يقيم الملف داخل الوحدة الحالية]]
- [[notes/A34-using-import-export-define-api-boundaries.idea|A34 - using و import و export تحدد حدود API]]
- [[notes/A35-project-and-manifest-fix-package-environment.idea|A35 - Project و Manifest يثبتان بيئة الحزمة]]
- [[notes/A36-small-public-apis-reduce-coupling.idea|A36 - واجهة عامة صغيرة تقلل الاقتران]]

## كود البداية

```julia
# في Julia REPL داخل مجلد عمل آمن:
using Pkg
Pkg.generate("MiniScientific")

# داخل بيئة تطبيق أخرى:
Pkg.activate("MiniApp")
Pkg.develop(path="../MiniScientific")
```

## اختبارات القبول

```julia
# قائمة قبول يدوية
# [ ] src/MiniScientific.jl يعلن module وincludes مرة واحدة
# [ ] types.jl يحمي invariants
# [ ] interfaces.jl يعلن نقاط التوسعة
# [ ] algorithms.jl لا يعتمد على تفاصيل ملفية
# [ ] export أقل من 10 أسماء
# [ ] test/runtests.jl يستعمل public API
# [ ] اختبارات Float32 وFloat64 وBigFloat
# [ ] اختبار view وrange ومدخل غير صالح
# [ ] تطبيق منفصل يعمل عبر using MiniScientific
```

> [!hint]- تلميحات متدرجة
> 1. لا تنشئ submodule لكل ملف.
> 2. ابدأ بملفين فقط ثم افصل عند ظهور مسؤولية.
> 3. استعمل `using MiniScientific: Name` في التطبيق لتوضيح الاعتماد.

## أسئلة ما بعد الحل

- أي حدود في تصميمك حقيقية وأيها مجرد تقسيم ملفي؟
- ما الاسم الذي قررت عدم تصديره ولماذا؟

## روابط

- الخريطة: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]
- [[lessons/L07-package-architecture.idea|L07 - معمارية الحزم]]
- [[sources/S01-package-entry-point.idea|S01 - كود نقطة دخول حزمة JuliaMastery]]
- [[sources/S06-package-tests-source.idea|S06 - اختبارات حزمة JuliaMastery]]

