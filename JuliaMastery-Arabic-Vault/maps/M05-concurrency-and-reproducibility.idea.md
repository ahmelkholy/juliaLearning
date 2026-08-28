---
id: M05
aliases:
  - خريطة التزامن
type: moc
tags:
  - moc
  - julia/concurrency
up: "[[maps/M00-julia-mastery-map.idea|M00 - خريطة إتقان Julia]]"
cssclasses:
  - rtl-note
---

# التزامن وقابلية إعادة الإنتاج

## الفكرة المركزية

أفضل سباق بيانات هو السباق الذي تمنعه بتقسيم الملكية، لا الذي تحاول إصلاحه بأقفال كثيرة.

## عقد الخريطة

- [[notes/A28-channels-provide-backpressure.idea|A28 - Channel يطبق الضغط العكسي]]
- [[notes/A29-disjoint-output-ownership-removes-locks.idea|A29 - ملكية فهارس الخرج تغني عن القفل]]
- [[notes/A30-parallel-reductions-need-independent-chunks.idea|A30 - الاختزال المتوازي يحتاج أجزاء مستقلة]]
- [[notes/A31-one-rng-per-simulation-is-reproducible.idea|A31 - مولد عشوائي لكل محاكاة يثبت النتائج]]

## التشغيل

```bash
julia --threads=auto --project=. lessons/06_concurrency.jl
```

افتح [[lessons/L06-concurrency.idea|L06 - التزامن]]، ثم اسأل في كل حلقة: من يكتب في كل موضع؟ وهل تتغير النتيجة إذا تغير ترتيب المهام؟

