---
id: START
aliases:
  - البداية
  - Start Here
type: entry
tags:
  - vault/start
  - julia
cssclasses:
  - rtl-note
---

# ابدأ هنا

> [!tip] طريقة فتح الخزنة
> في Foam افتح المستودع في VS Code، وأعد تحميل النافذة مرة واحدة، ثم افتح هذا الملف أو شغّل **Foam: Show Graph**. وفي Obsidian افتح مجلد `JuliaMastery-Arabic-Vault` بوصفه Vault مستقلًا، وفعّل CSS snippet المسمى `arabic-notes` من **Settings → Appearance → CSS snippets** إذا لم يُفعّل تلقائيًا.
> أسماء الملفات إنجليزية واضحة لتجنب تشوّه الحروف، أما العناوين والشرح فبالعربية. التفاصيل في [[FILENAME-GUIDE.idea|دليل أسماء الملفات]].

هذه الخزنة ليست كتابًا خطيًا. هي شبكة معرفة: تبدأ بسؤال، تفتح ملاحظة واحدة، تشغّل الكود، ثم تنتقل عبر رابط له معنى.

## المسار المقترح لأول مرة

1. افتح [[maps/M00-julia-mastery-map.idea|الخريطة الرئيسية]].
   ويمكنك فتح [[julia-mastery-map.canvas|الخريطة البصرية]] لرؤية المجالات الثمانية حول المركز.
2. نفّذ اختبار المشروع من الطرفية.
3. ادرس [[lessons/L01-dispatch-and-types.idea|الدرس الأول]].
4. اختر ملاحظة ذرية واحدة واكتب تفسيرها من الذاكرة.
5. حل سؤال الاسترجاع المطوي قبل فتح الإجابة.
6. شغّل التجربة القصيرة وعدّل متغيّرًا واحدًا.
7. سجّل الجلسة بقالب [[templates/T02-learning-session-review.idea|مراجعة جلسة تعلم]].

## فحص المشروع

شغّل الأوامر من مجلد المستودع الأب، لا من داخل الخزنة:

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
julia --project=. scripts/learning_coach.jl next
```

## خرائط الدخول

- [[maps/M01-types-and-dispatch.idea|الأنواع والتوزيع]]
- [[maps/M02-arrays-and-memory.idea|المصفوفات والذاكرة]]
- [[maps/M03-performance-and-compiler.idea|الأداء والمترجم]]
- [[maps/M04-interfaces-and-metaprogramming.idea|الواجهات والبرمجة الوصفية]]
- [[maps/M05-concurrency-and-reproducibility.idea|التزامن وقابلية إعادة الإنتاج]]
- [[maps/M06-packages-errors-and-testing.idea|الحزم والأخطاء والاختبارات]]
- [[maps/M07-scientific-algorithms.idea|الخوارزميات العلمية]]
- [[maps/M08-exercises-and-review.idea|التمارين والمراجعة]]

## قاعدة التعلّم

لا تعتبر الملاحظة مفهومة لأنك قرأتها. تعتبرها مفهومة عندما تستطيع:

- توقع ناتج المثال قبل تشغيله.
- شرح سبب اختيار Julia للطريقة أو النوع.
- تغيير افتراض واحد ومعرفة ما سينكسر.
- ربط الفكرة بملاحظة أخرى من دون النظر إلى الخريطة.
