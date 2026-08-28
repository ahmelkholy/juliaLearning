---
id: X06
aliases:
  - "تنفيذ الجمع الثنائي دون نسخ"
type: exercise
status: queued
difficulty: متوسط
xp: 200
estimated_time: 45 دقيقة
tags:
  - practice/exercise
  - julia
up: "[[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]"
cssclasses:
  - rtl-note
---

# تنفيذ الجمع الثنائي دون نسخ

> [!abstract] المهمة
> نفّذ pairwise summation على `AbstractVector` بتقسيم مجال الفهارس، مع cutoff، ومن دون slices.

## المتطلبات السابقة

- [[notes/A12-eachindex-respects-container-indexing.idea|A12 - eachindex يحترم فهرسة الحاوية]]
- [[notes/A15-generic-arithmetic-does-not-force-float64.idea|A15 - الحساب العام لا يفرض Float64]]
- [[notes/A42-compensated-summation-recovers-lost-parts.idea|A42 - الجمع المعوض يستعيد الأجزاء المفقودة]]

## كود البداية

```julia
function pairwise_sum(values::AbstractVector;
                      cutoff::Integer=128)
    # TODO: تحقق من cutoff
    # TODO: عالج المدخل الفارغ
    # TODO: استدع helper بحدي الفهرسة
end

function _pairwise_sum(values, first_i, last_i, cutoff)
    length = last_i - first_i + 1
    # TODO: حلقة مباشرة عندما length <= cutoff
    # TODO: اقسم المجال نصفين واجمع النتيجتين
end
```

## اختبارات القبول

```julia
using Test

@test pairwise_sum(Int[]) == 0
@test pairwise_sum(collect(1:100)) == 5_050
@test pairwise_sum(Float32[1, 2, 3]) === 6.0f0
@test_throws ArgumentError pairwise_sum([1, 2]; cutoff=0)

difficult = [1.0e16, 1.0, -1.0e16, 2.0]
@test isfinite(pairwise_sum(difficult; cutoff=1))
```

> [!hint]- تلميحات متدرجة
> 1. استعمل `firstindex` و`lastindex`.
> 2. في الحالة الصغيرة ابدأ بـ `zero(eltype(values))`.
> 3. لا تكتب `values[left:right]` لأنها slice.

## أسئلة ما بعد الحل

- كيف يؤثر cutoff في overhead وترتيب الجمع؟
- هل pairwise والـ compensated يعالجان المشكلة نفسها بالطريقة نفسها؟

## روابط

- الخريطة: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]
- [[sources/S04-advanced-exercises-source.idea|S04 - كود التمارين المتقدمة الأصلي]]
- [[sources/S05-advanced-solutions-source.idea|S05 - الحلول المرجعية المتقدمة]]
- [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]

