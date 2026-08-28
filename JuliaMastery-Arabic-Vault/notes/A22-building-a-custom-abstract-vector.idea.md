---
id: A22
aliases:
  - "بناء AbstractVector مخصص"
  - "Custom AbstractVector"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/interfaces
  - julia/arrays
lesson: 4
source: lessons/04_interfaces_and_iteration.jl
up: "[[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]"
cssclasses:
  - rtl-note
---

# بناء AbstractVector مخصص

## الفكرة

يمكن لنوع كسول أن يتصرف كمتجه من دون تخزين كل عناصره، إذا نفّذ عقد `AbstractVector`: الشكل، ونمط الفهرسة، والوصول إلى عنصر.

## لماذا تهم؟

هذا يتيح استعمال `sum` و`collect` والبث وخوارزميات عامة أخرى مع تمثيل ذاكرة مختلف.

## مثال Julia

```julia
struct AffineGrid{T<:Real} <: AbstractVector{T}
    origin::T
    step::T
    count::Int
end

Base.size(grid::AffineGrid) = (grid.count,)
Base.IndexStyle(::Type{<:AffineGrid}) = IndexLinear()

function Base.getindex(grid::AffineGrid, i::Int)
    @boundscheck checkbounds(grid, i)
    return grid.origin + (i - 1) * grid.step
end

grid = AffineGrid(0.0, 0.25, 5)
println(collect(grid))
println(sum(grid))
println(sin.(grid))
```

## كيف تقرأ المثال؟

لا يوجد حقل `data`. كل عنصر يُحسب عند الطلب. الوراثة من `AbstractVector{T}` وعد بأن النوع يلتزم بدلالات المتجه.

> [!example] تجربة قصيرة
> حاول الوصول إلى `grid[0]` واقرأ `BoundsError`. ثم اختبر `eltype(grid)`.

> [!question]- سؤال استرجاع
> ما الطرق الثلاث الأساسية التي نفذها المثال؟

> [!success]- الإجابة
> `size` و`IndexStyle` و`getindex`، مع نوع العنصر معلنًا في `AbstractVector{T}`.

## روابط ذات معنى

- الخريطة: [[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]
- الدرس المصدر: [[lessons/L04-interfaces-and-iteration.idea|L04 - الواجهات والتكرار]]
- [[notes/A12-eachindex-respects-container-indexing.idea|A12 - eachindex يحترم فهرسة الحاوية]]
- [[notes/A21-small-interfaces-unlock-generic-behavior.idea|A21 - الواجهة الصغيرة تفتح سلوكا عاما]]
- [[notes/A23-iteration-returns-value-and-state.idea|A23 - بروتوكول التكرار يعيد القيمة والحالة]]

