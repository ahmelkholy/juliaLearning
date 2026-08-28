---
id: A28
aliases:
  - "Channel يطبق الضغط العكسي"
  - "Channels"
  - "Backpressure"
type: evergreen
status: cultivated
tags:
  - note/evergreen
  - julia/concurrency
lesson: 6
source: lessons/06_concurrency.jl
up: "[[maps/M05-concurrency-and-reproducibility.idea|M05 - التزامن وقابلية إعادة الإنتاج]]"
cssclasses:
  - rtl-note
---

# Channel يطبق الضغط العكسي

## الفكرة

`Channel` طابور متزامن قد تكون سعته محدودة. عندما تمتلئ القناة ينتظر المنتج، فينشأ backpressure بدل نمو غير محدود.

## لماذا تهم؟

تفصل القناة توقيت المنتج عن المستهلك وتعبّر عن stream من القيم. ليست أسرع تلقائيًا من حلقة؛ قيمتها في تنظيم التدفق والانتظار.

## مثال Julia

```julia
function squares(count)
    channel = Channel{Tuple{Int,Int}}(2) do output
        for i in 1:count
            put!(output, (i, i^2))
        end
    end
    return collect(channel)
end

println(squares(5))
```

## كيف تقرأ المثال؟

المهمة المنتجة تعمل داخل constructor ذي do-block. السعة 2؛ إذا لم يسحب المستهلك تنتظر `put!` عند الامتلاء.

> [!example] تجربة قصيرة
> غيّر السعة إلى 1 ثم إلى 100. النتيجة ثابتة، لكن نمط الانتظار والذاكرة يتغير.

> [!question]- سؤال استرجاع
> ماذا يحدث للمنتج عندما يحاول `put!` في قناة ممتلئة؟

> [!success]- الإجابة
> ينتظر حتى يستهلك طرف آخر عنصرًا وتتوفر سعة.

## روابط ذات معنى

- الخريطة: [[maps/M05-concurrency-and-reproducibility.idea|M05 - التزامن وقابلية إعادة الإنتاج]]
- الدرس المصدر: [[lessons/L06-concurrency.idea|L06 - التزامن]]
- [[notes/A29-disjoint-output-ownership-removes-locks.idea|A29 - ملكية فهارس الخرج تغني عن القفل]]
- [[notes/A30-parallel-reductions-need-independent-chunks.idea|A30 - الاختزال المتوازي يحتاج أجزاء مستقلة]]
- [[notes/A38-finally-guarantees-resource-cleanup.idea|A38 - finally تضمن تنظيف المورد]]

