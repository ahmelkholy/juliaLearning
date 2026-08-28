---
id: M08
aliases:
  - خريطة التمارين
type: moc
tags:
  - moc
  - practice
up: "[[maps/M00-julia-mastery-map.idea|M00 - خريطة إتقان Julia]]"
cssclasses:
  - rtl-note
---

# التمارين والمراجعة

## تمارين مفاهيمية

- [[exercises/X01-add-a-shape-with-dispatch.idea|X01 - إضافة شكل جديد بالتوزيع]]
- [[exercises/X02-compare-copy-view-allocation.idea|X02 - مقارنة النسخ والعرض والتخصيص]]

## تمارين متقدمة

- [[exercises/X03-add-heun-externally.idea|X03 - إضافة طريقة Heun من خارج الحزمة]]
- [[exercises/X04-matrix-free-operator-and-cg.idea|X04 - بناء مؤثر وحل نظام دون مصفوفة]]
- [[exercises/X05-custom-circular-buffer.idea|X05 - بناء CircularBuffer بواجهة AbstractVector]]
- [[exercises/X06-pairwise-summation.idea|X06 - تنفيذ الجمع الثنائي دون نسخ]]
- [[exercises/X07-power-iteration.idea|X07 - تنفيذ power iteration بواجهة مؤثر]]
- [[exercises/X08-build-a-julia-package.idea|X08 - بناء حزمة Julia صغيرة قابلة للتطوير]]

## ملفات المصدر للتدريب

- [[sources/S04-advanced-exercises-source.idea|S04 - كود التمارين المتقدمة الأصلي]]
- [[sources/S05-advanced-solutions-source.idea|S05 - الحلول المرجعية المتقدمة]]
- [[sources/S07-learning-coach-source.idea|S07 - كود مدرب التعلم]]
- [[sources/S08-run-all-lessons-source.idea|S08 - كود تشغيل جميع الدروس]]

## أدوات الاسترجاع

- [[templates/T01-new-atomic-note.idea|T01 - ملاحظة ذرية جديدة]]
- [[templates/T02-learning-session-review.idea|T02 - مراجعة جلسة تعلم]]

## بوابة النهاية

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
julia --project=. scripts/run_all.jl
julia --project=. solutions/advanced_solutions.jl
```

بعد النجاح، اختر ملاحظة عشوائية من الرسم البياني، واكتب مثالًا جديدًا لها من دون نسخ المثال الموجود.
