---
id: M02
aliases:
  - خريطة المصفوفات
type: moc
tags:
  - moc
  - julia/arrays
up: "[[maps/M00-julia-mastery-map.idea|M00 - خريطة إتقان Julia]]"
cssclasses:
  - rtl-note
---

# المصفوفات والذاكرة

## الفكرة المركزية

الأداء الصحيح يبدأ من دلالات البيانات: من يملك الذاكرة؟ هل حدث نسخ؟ وبأي ترتيب تعبر الحلقة العناصر؟

## عقد الخريطة

- [[notes/A09-dense-matrices-are-column-major.idea|A09 - المصفوفات الكثيفة تخزن بالأعمدة]]
- [[notes/A10-views-share-memory-slices-copy.idea|A10 - العرض يشارك الذاكرة والشريحة تنسخ]]
- [[notes/A11-dotted-broadcast-fuses-operations.idea|A11 - البث المنقط يدمج العمليات]]
- [[notes/A12-eachindex-respects-container-indexing.idea|A12 - eachindex يحترم فهرسة الحاوية]]
- [[notes/A13-adjoint-differs-from-transpose.idea|A13 - المرافق المنقول يختلف عن النقل]]
- [[notes/A14-factorization-over-matrix-inverse.idea|A14 - حل النظام بالتحليل أفضل من المعكوس]]
- [[notes/A15-generic-arithmetic-does-not-force-float64.idea|A15 - الحساب العام لا يفرض Float64]]

## طبّقها

افتح [[lessons/L02-arrays-and-generic-numerics.idea|L02 - المصفوفات والحسابات العامة]]، ثم اربط قرار الذاكرة بـ [[notes/A20-mutating-functions-clarify-memory-ownership.idea|A20 - الدالة المعدلة توضح ملكية الذاكرة]].

