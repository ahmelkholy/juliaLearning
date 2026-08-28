---
id: A37
aliases:
  - "catch الضيقة لا تخفي الأخطاء"
  - "Narrow catch blocks"
  - "Exception translation"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/errors
  - julia/design
lesson: 8
source: lessons/08_errors_resources_and_testing.jl
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# catch الضيقة لا تخفي الأخطاء

## الفكرة

أحط فقط العملية التي تتوقع خطأها وتريد ترجمته. أعد رمي أي فئة غير مقصودة بدل تحويل كل فشل إلى رسالة مضللة.

## لماذا تهم؟

`try/catch` واسع حول دالة كبيرة قد يمسك bug من كودك ويعرضه كخطأ إدخال. الحد الضيق يحافظ على stack trace والمعنى.

## مثال Julia

```julia
struct ConfigurationError <: Exception
    key::String
    value::String
end

function parse_positive(key, text)
    value = try
        parse(Float64, text)
    catch error
        error isa ArgumentError || rethrow()
        throw(ConfigurationError(String(key), String(text)))
    end
    isfinite(value) && value > 0 ||
        throw(ConfigurationError(String(key), String(text)))
    return value
end

println(parse_positive("dt", "0.1"))
# parse_positive("dt", "fast")
```

## كيف تقرأ المثال؟

العملية التي تترجم خطأها هي `parse` وحدها. بعد نجاح التحليل تتحقق الدالة من العقد الدلالي: finite وموجب.

> [!example] تجربة قصيرة
> أضف خطأً برمجيًا متعمدًا بعد `try` وتأكد أنه لا يتحول إلى `ConfigurationError`.

> [!question]- سؤال استرجاع
> لماذا نستعمل `rethrow()` بدل `throw(error)` عند إعادة الخطأ الحالي؟

> [!success]- الإجابة
> `rethrow()` يحافظ على سياق الخطأ الأصلي وموضعه بدل إنشاء رمية جديدة مضللة.

## روابط ذات معنى

- الخريطة: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس المصدر: [[lessons/L08-errors-resources-and-testing.idea|L08 - الأخطاء والموارد والاختبارات]]
- [[notes/A05-inner-constructors-protect-invariants.idea|A05 - المنشئ الداخلي يحمي ثوابت النوع]]
- [[notes/A38-finally-guarantees-resource-cleanup.idea|A38 - finally تضمن تنظيف المورد]]
- [[notes/A39-good-tests-check-public-contracts.idea|A39 - الاختبار الجيد يفحص العقد العام]]

