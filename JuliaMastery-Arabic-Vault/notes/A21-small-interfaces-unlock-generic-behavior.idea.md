---
id: A21
aliases:
  - "الواجهة الصغيرة تفتح سلوكا عاما"
  - "Informal interfaces"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/interfaces
  - julia/design
lesson: 4
source: lessons/04_interfaces_and_iteration.jl
up: "[[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]"
cssclasses:
  - rtl-note
---

# الواجهة الصغيرة تفتح سلوكا عاما

## الفكرة

واجهة Julia غالبًا اتفاق غير رسمي: تنفّذ مجموعة طرق صغيرة، فتستعملك دوال عامة كثيرة من Base ومكتبات أخرى.

## لماذا تهم؟

بدل إعادة كتابة `sum` و`collect` والبث لكل نوع، عبّر عن العمليات الأساسية التي يحتاجها النظام. التوسعة تكون بالتوافق مع العقد لا بالوراثة الثقيلة.

## مثال Julia

```julia
struct PairValues{T}
    first::T
    second::T
end

Base.length(::PairValues) = 2
Base.getindex(values::PairValues, i::Int) =
    i == 1 ? values.first :
    i == 2 ? values.second :
    throw(BoundsError(values, i))

values = PairValues(10, 20)
println([values[i] for i in 1:length(values)])
```

## كيف تقرأ المثال؟

هذا المثال يوضح الفكرة لكنه لا يرث `AbstractVector`. إذا وعد النوع بعقد مصفوفة كاملًا، فالأفضل تنفيذ الواجهة المناسبة كما في الملاحظة التالية.

> [!example] تجربة قصيرة
> أضف `Base.iterate` إلى النوع واجعل `collect(values)` يعمل من دون كتابة `collect` مخصصة.

> [!question]- سؤال استرجاع
> لماذا تكون الواجهة الصغيرة أفضل من نسخ عشرات الدوال لنوع جديد؟

> [!success]- الإجابة
> لأن الدوال العامة تُبنى فوق العمليات الأساسية، فتحصل على سلوك واسع بعقد قليل ومتناسق.

## روابط ذات معنى

- الخريطة: [[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]
- الدرس المصدر: [[lessons/L04-interfaces-and-iteration.idea|L04 - الواجهات والتكرار]]
- [[notes/A22-building-a-custom-abstract-vector.idea|A22 - بناء AbstractVector مخصص]]
- [[notes/A23-iteration-returns-value-and-state.idea|A23 - بروتوكول التكرار يعيد القيمة والحالة]]
- [[notes/A36-small-public-apis-reduce-coupling.idea|A36 - واجهة عامة صغيرة تقلل الاقتران]]

