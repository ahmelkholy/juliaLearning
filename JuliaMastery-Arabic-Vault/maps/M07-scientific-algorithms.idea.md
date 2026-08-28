---
id: M07
aliases:
  - خريطة البرمجة العلمية
type: moc
tags:
  - moc
  - julia/numerics
  - julia/ode
up: "[[maps/M00-julia-mastery-map.idea|M00 - خريطة إتقان Julia]]"
cssclasses:
  - rtl-note
---

# الخوارزميات العلمية

## نقطة دخول الحزمة

- [[sources/S01-package-entry-point.idea|S01 - كود نقطة دخول حزمة JuliaMastery]]

## تصميم الخوارزمية والاستقرار

- [[notes/A41-algorithm-objects-replace-central-branches.idea|A41 - كائن الخوارزمية يستبدل الفروع المركزية]]
- [[notes/A42-compensated-summation-recovers-lost-parts.idea|A42 - الجمع المعوض يستعيد الأجزاء المفقودة]]
- [[notes/A43-welford-computes-online-variance.idea|A43 - خوارزمية Welford تحسب التباين على الإنترنت]]
- [[notes/A44-log-sum-exp-prevents-overflow.idea|A44 - log-sum-exp يمنع الفيضان]]
- [[notes/A45-matrix-free-operators-reduce-memory.idea|A45 - المؤثر دون مصفوفة يقلل الذاكرة]]

## Conjugate Gradient

- [[notes/A46-conjugate-gradient-requires-positive-definite-operator.idea|A46 - Conjugate Gradient يحتاج مؤثرا موجبا]]
- [[notes/A47-relative-residual-measures-solution-quality.idea|A47 - المتبقي النسبي يقيس جودة الحل]]
- [[sources/S03-conjugate-gradient-source.idea|S03 - كود Conjugate Gradient]]

## المعادلات التفاضلية

- [[notes/A48-ode-problem-is-separated-from-solver.idea|A48 - مسألة ODE منفصلة عن طريقة الحل]]
- [[notes/A49-extension-points-add-algorithms-without-changing-solve.idea|A49 - نقاط التوسعة تضيف خوارزمية دون تعديل solve]]
- [[notes/A50-euler-first-order-rk4-fourth-order.idea|A50 - Euler من الرتبة الأولى و RK4 من الرابعة]]
- [[notes/A51-convergence-order-needs-step-sequence.idea|A51 - رتبة التقارب تقاس بسلسلة خطوات]]
- [[notes/A52-physical-invariants-test-entire-trajectory.idea|A52 - الثوابت الفيزيائية تختبر الحل عبر الزمن]]
- [[notes/A53-copying-saved-states-prevents-aliasing.idea|A53 - نسخ الحالات المحفوظة يمنع aliasing]]
- [[notes/A54-short-final-step-reaches-final-time.idea|A54 - الخطوة الأخيرة القصيرة تصل إلى الزمن النهائي]]
- [[sources/S02-ode-solver-source.idea|S02 - كود محلل ODE]]

## الدروس

- [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]
- [[lessons/L10-scientific-capstone.idea|L10 - المشروع العلمي الختامي]]
