---
id: A25
aliases:
  - "الماكرو يستقبل صياغة لا قيما"
  - "Macros receive syntax"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/metaprogramming
lesson: 5
source: lessons/05_metaprogramming.jl
up: "[[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]"
cssclasses:
  - rtl-note
---

# الماكرو يستقبل صياغة لا قيما

## الفكرة

الدالة تستقبل قيم الوسائط بعد تقييمها، أما الماكرو فيستقبل تعبيرات قبل التنفيذ ويعيد صياغة جديدة.

## لماذا تهم؟

لذلك يستطيع الماكرو إنشاء تراكيب لغوية أو إدخال كود حول تعبير. لكنه يحمل مخاطر النطاق والتقييم المتكرر، فلا يستخدم عندما تكفي دالة عادية.

## مثال Julia

```julia
expression = :(scale .* values)

println(typeof(expression))
println(expression.head)
println(expression.args)
dump(expression; maxdepth=3)

macro show_syntax(ex)
    return :(string($(QuoteNode(ex))))
end

println(@show_syntax 1 + 2 * 3)
```

## كيف تقرأ المثال؟

`:(...)` يبني `Expr` بدل تنفيذ الحساب. الماكرو يرى شجرة `1 + 2 * 3` نفسها، لا القيمة `7`.

> [!example] تجربة قصيرة
> غيّر التعبير إلى function call وراقب `head` و`args`. ثم قارن ذلك بنداء دالة عادية تستقبل النتيجة.

> [!question]- سؤال استرجاع
> لماذا يستطيع الماكرو رؤية اسم المتغيّر الذي كتبه المستدعي بينما لا تستطيع الدالة العادية؟

> [!success]- الإجابة
> لأنه يعمل على الصياغة قبل تقييم المتغيّر، بينما الدالة تستقبل القيمة بعد التقييم.

## روابط ذات معنى

- الخريطة: [[maps/M04-interfaces-and-metaprogramming.idea|M04 - الواجهات والبرمجة الوصفية]]
- الدرس المصدر: [[lessons/L05-metaprogramming.idea|L05 - البرمجة الوصفية]]
- [[notes/A26-macro-hygiene-and-esc-protect-scope.idea|A26 - نظافة الماكرو و esc تحميان النطاق]]
- [[notes/A27-generated-functions-see-types-not-runtime-values.idea|A27 - الدالة المولدة ترى الأنواع لا قيم التشغيل]]
- [[notes/A21-small-interfaces-unlock-generic-behavior.idea|A21 - الواجهة الصغيرة تفتح سلوكا عاما]]

