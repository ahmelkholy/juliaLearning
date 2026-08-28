---
id: A38
aliases:
  - "finally تضمن تنظيف المورد"
  - "finally cleanup"
  - "Resource ownership"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/errors
  - julia/resources
lesson: 8
source: lessons/08_errors_resources_and_testing.jl
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# finally تضمن تنظيف المورد

## الفكرة

قسم `finally` ينفذ بعد `try` سواء عاد الجسم طبيعيًا أم رمى استثناء. استعمله عندما يجب تحرير مورد أو إبطال حالة مهما كانت النتيجة.

## لماذا تهم؟

الموارد الخارجية والملفات والأقفال تحتاج دورة حياة واضحة. cleanup في نهاية المسار الناجح فقط لا يغطي الفشل المبكر.

## مثال Julia

```julia
function with_workspace(callback, count)
    workspace = zeros(count)
    try
        return callback(workspace)
    finally
        fill!(workspace, NaN)  # يمثل إبطال مورد
    end
end

result = with_workspace(4) do workspace
    workspace .= 1:4
    sum(workspace)
end

println(result)
```

## كيف تقرأ المثال؟

القيمة المعادة من callback محفوظة، ثم ينفذ `finally` قبل خروج الدالة. في العمل الفعلي فضّل API قياسية مثل `open(...) do io` عندما توجد.

> [!example] تجربة قصيرة
> اجعل callback ترمي `error("boom")` وأضف طباعة مؤقتة في `finally` لتثبت أن cleanup حدث، ثم احذف الطباعة.

> [!question]- سؤال استرجاع
> هل تمنع `finally` الاستثناء من الانتشار؟

> [!success]- الإجابة
> لا؛ تضمن cleanup ثم يستمر الاستثناء ما لم يمسكه catch مناسب.

## روابط ذات معنى

- الخريطة: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس المصدر: [[lessons/L08-errors-resources-and-testing.idea|L08 - الأخطاء والموارد والاختبارات]]
- [[notes/A37-narrow-catch-blocks-do-not-hide-errors.idea|A37 - catch الضيقة لا تخفي الأخطاء]]
- [[notes/A39-good-tests-check-public-contracts.idea|A39 - الاختبار الجيد يفحص العقد العام]]
- [[notes/A28-channels-provide-backpressure.idea|A28 - Channel يطبق الضغط العكسي]]

