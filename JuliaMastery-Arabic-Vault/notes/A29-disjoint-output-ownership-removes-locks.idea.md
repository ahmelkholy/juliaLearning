---
id: A29
aliases:
  - "ملكية فهارس الخرج تغني عن القفل"
  - "Disjoint ownership"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/concurrency
  - julia/memory
lesson: 6
source: lessons/06_concurrency.jl
up: "[[maps/M05-concurrency-and-reproducibility.idea|M05 - التزامن وقابلية إعادة الإنتاج]]"
cssclasses:
  - rtl-note
---

# ملكية فهارس الخرج تغني عن القفل

## الفكرة

إذا امتلك كل iteration موضع خرج لا يكتبه غيره، يمكن التنفيذ المتوازي من دون lock على تلك الكتابات.

## لماذا تهم؟

الأقفال تعالج مشاركة موجودة وتضيف تعقيدًا. تقسيم الملكية يمنع التعارض من التصميم ويجعل صحة الكود أسهل في البرهنة.

## مثال Julia

```julia
using Base.Threads

function threaded_map(f, values, ::Type{T}) where {T}
    output = similar(values, T)
    @threads for i in eachindex(values, output)
        output[i] = f(values[i])
    end
    return output
end

values = collect(1.0:8.0)
println(threaded_map(sqrt, values, Float64))
```

## كيف تقرأ المثال؟

كل iteration يقرأ `values[i]` ويكتب `output[i]` وحده. ترتيب التنفيذ لا يغير موضع النتيجة.

> [!example] تجربة قصيرة
> غيّر الجسم ليكتب دائمًا `output[1]` ولاحظ أن العقد أصبح غير آمن حتى لو لم يظهر الخطأ في كل تشغيل.

> [!question]- سؤال استرجاع
> ما البرهان المحلي الذي يسمح بإزالة lock في هذا المثال؟

> [!success]- الإجابة
> أن مجموعة الكتابات لكل iteration منفصلة: لا يوجد موضع خرج يملكه iteration آخر.

## روابط ذات معنى

- الخريطة: [[maps/M05-concurrency-and-reproducibility.idea|M05 - التزامن وقابلية إعادة الإنتاج]]
- الدرس المصدر: [[lessons/L06-concurrency.idea|L06 - التزامن]]
- [[notes/A28-channels-provide-backpressure.idea|A28 - Channel يطبق الضغط العكسي]]
- [[notes/A30-parallel-reductions-need-independent-chunks.idea|A30 - الاختزال المتوازي يحتاج أجزاء مستقلة]]
- [[notes/A31-one-rng-per-simulation-is-reproducible.idea|A31 - مولد عشوائي لكل محاكاة يثبت النتائج]]

