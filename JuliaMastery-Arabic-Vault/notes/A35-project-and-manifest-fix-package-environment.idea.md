---
id: A35
aliases:
  - "Project و Manifest يثبتان بيئة الحزمة"
  - "Julia environments"
  - "Project.toml"
  - "Manifest.toml"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/packages
  - julia/environments
lesson: 7
source: Project.toml
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# Project و Manifest يثبتان بيئة الحزمة

## الفكرة

`Project.toml` يصف الحزمة واعتماداتها المباشرة وحدود التوافق، و`Manifest.toml` يقفل شجرة الاعتمادات الفعلية لإعادة البيئة.

## لماذا تهم؟

البيئة تمنع اعتماد الكود على حزم موجودة صدفةً في جهازك. الخيار `--project=.` يجعل الأوامر تستعمل المشروع المقصود.

## مثال Julia

```julia
using Pkg

Pkg.activate(".")
Pkg.instantiate()
Pkg.status()
```

## كيف تقرأ المثال؟

`activate` يختار البيئة، و`instantiate` يحقق الحالة الموصوفة في الملفات، و`status` يعرض الاعتمادات النشطة.

> [!example] تجربة قصيرة
> شغّل `Base.active_project()` مع `--project=.` ومن دونه في جلسة أخرى، وقارن المسار.

> [!question]- سؤال استرجاع
> أي ملف يعبّر عن الاعتمادات المباشرة المقصودة وأيهما يقفل الإصدارات الفعلية؟

> [!success]- الإجابة
> `Project.toml` يصف المقصود المباشر والتوافق، و`Manifest.toml` يسجل الحل الكامل الفعلي.

## روابط ذات معنى

- الخريطة: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس المصدر: [[lessons/L07-package-architecture.idea|L07 - معمارية الحزم]]
- [[notes/A33-include-evaluates-files-in-current-module.idea|A33 - include يقيم الملف داخل الوحدة الحالية]]
- [[notes/A34-using-import-export-define-api-boundaries.idea|A34 - using و import و export تحدد حدود API]]
- [[notes/A39-good-tests-check-public-contracts.idea|A39 - الاختبار الجيد يفحص العقد العام]]

