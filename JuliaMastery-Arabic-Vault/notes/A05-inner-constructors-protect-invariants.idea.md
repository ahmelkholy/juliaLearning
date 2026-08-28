---
id: A05
aliases:
  - "المنشئ الداخلي يحمي ثوابت النوع"
  - "Inner constructor"
  - "Type invariants"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/types
  - julia/errors
lesson: 1
source: lessons/01_dispatch_and_types.jl
up: "[[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]"
cssclasses:
  - rtl-note
---

# المنشئ الداخلي يحمي ثوابت النوع

## الفكرة

الـ inner constructor هو آخر بوابة قبل إنشاء القيمة، ولذلك يصلح لفرض invariant يجب ألا توجد أي قيمة من النوع من دونه.

## لماذا تهم؟

إذا كان نصف قطر سالبًا غير صالح في النموذج، فإن رفضه داخل المنشئ يجعل بقية البرنامج يفترض الصلاحية بدل إعادة الفحص في كل دالة.

## مثال Julia

```julia
struct Circle{T<:Real}
    radius::T

    function Circle(radius::T) where {T<:Real}
        radius >= zero(T) ||
            throw(ArgumentError("radius must be nonnegative"))
        return new{T}(radius)
    end
end

println(Circle(2.0))
# Circle(-1.0)  # يرمي ArgumentError
```

## كيف تقرأ المثال؟

`new{T}` متاح داخل المنشئ الداخلي فقط. استعمال `zero(T)` يحافظ على عمومية النوع ولا يفرض `Float64`.

> [!example] تجربة قصيرة
> أضف شرط `isfinite(radius)`، ثم اختبر `Circle(Inf)` و`Circle(NaN)`.

> [!question]- سؤال استرجاع
> لماذا يكون invariant القوي داخل inner constructor أفضل من فحصه في `area`؟

> [!success]- الإجابة
> لأنه يمنع تكوين القيمة غير الصالحة أصلًا، فتستطيع كل الدوال اللاحقة الاعتماد على invariant واحد.

## روابط ذات معنى

- الخريطة: [[maps/M01-types-and-dispatch.idea|M01 - الأنواع والتوزيع]]
- الدرس المصدر: [[lessons/L01-dispatch-and-types.idea|L01 - التوزيع المتعدد والأنواع]]
- [[notes/A03-abstract-families-concrete-data.idea|A03 - النوع المجرد عائلة والنوع الملموس بيانات]]
- [[notes/A37-narrow-catch-blocks-do-not-hide-errors.idea|A37 - catch الضيقة لا تخفي الأخطاء]]
- [[notes/A39-good-tests-check-public-contracts.idea|A39 - الاختبار الجيد يفحص العقد العام]]

