---
id: X05
aliases:
  - "بناء CircularBuffer بواجهة AbstractVector"
type: exercise
status: queued
difficulty: متوسط
xp: 250
estimated_time: 60 دقيقة
tags:
  - practice/exercise
  - julia
up: "[[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]"
cssclasses:
  - rtl-note
---

# بناء CircularBuffer بواجهة AbstractVector

> [!abstract] المهمة
> ابنِ مخزنًا دائريًا بسعة ثابتة يستبدل أقدم عنصر عند الامتلاء، واجعل `collect` و`sum` والبث تعمل.

## المتطلبات السابقة

- [[notes/A21-small-interfaces-unlock-generic-behavior.idea|A21 - الواجهة الصغيرة تفتح سلوكا عاما]]
- [[notes/A22-building-a-custom-abstract-vector.idea|A22 - بناء AbstractVector مخصص]]
- [[notes/A20-mutating-functions-clarify-memory-ownership.idea|A20 - الدالة المعدلة توضح ملكية الذاكرة]]

## كود البداية

```julia
mutable struct CircularBuffer{T} <: AbstractVector{T}
    storage::Vector{T}
    first_slot::Int
    count::Int
end

function CircularBuffer{T}(capacity::Integer) where {T}
    # TODO: ارفض السعة غير الموجبة
    # TODO: أنشئ storage غير مهيأة
end

Base.size(buffer::CircularBuffer) = (buffer.count,)
Base.IndexStyle(::Type{<:CircularBuffer}) = IndexLinear()

function Base.getindex(buffer::CircularBuffer, i::Int)
    # TODO: checkbounds
    # TODO: حوّل الفهرس المنطقي إلى slot بـ mod1
end

function Base.push!(buffer::CircularBuffer{T}, value) where {T}
    # TODO: أضف أو استبدل الأقدم
end
```

## اختبارات القبول

```julia
using Test

buffer = CircularBuffer{Float64}(3)
foreach(x -> push!(buffer, x), 1:5)

@test collect(buffer) == [3.0, 4.0, 5.0]
@test sum(buffer) == 12.0
@test 2 .* buffer == [6.0, 8.0, 10.0]
@test_throws BoundsError buffer[0]
@test_throws ArgumentError CircularBuffer{Int}(0)
```

> [!hint]- تلميحات متدرجة
> 1. الفهرس الفيزيائي هو `mod1(first_slot + i - 1, capacity)`.
> 2. قبل الامتلاء زد `count`؛ بعده حرّك `first_slot`.
> 3. حوّل `value` إلى `T` قبل التخزين.

## أسئلة ما بعد الحل

- ما معنى الفهرس 1 بعد التفاف المخزن؟
- لماذا يرث النوع من `AbstractVector{T}` بدل `Vector{T}`؟

## روابط

- الخريطة: [[maps/M08-exercises-and-review.idea|M08 - التمارين والمراجعة]]
- [[sources/S04-advanced-exercises-source.idea|S04 - كود التمارين المتقدمة الأصلي]]
- [[sources/S05-advanced-solutions-source.idea|S05 - الحلول المرجعية المتقدمة]]
- [[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]

