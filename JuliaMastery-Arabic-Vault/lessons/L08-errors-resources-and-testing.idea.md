---
id: L08
aliases:
  - "الدرس 8: الأخطاء والموارد والاختبارات"
type: source-note
status: complete
tags:
  - course/lesson
  - course/lesson-08
  - julia
lesson: 8
source: lessons/08_errors_resources_and_testing.jl
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# الدرس 8: الأخطاء والموارد والاختبارات

> [!goal] هدف الدرس
> أن تترجم خطأً متوقعًا من دون إخفاء bugs، وتضمن cleanup، وتختبر العقد العددي.

## قبل التشغيل

حدد أي فئة خطأ ستتحول إلى `ConfigurationError` وأي خطأ سيعاد رميه.

## شبكة المفاهيم

- [[notes/A37-narrow-catch-blocks-do-not-hide-errors.idea|A37 - catch الضيقة لا تخفي الأخطاء]]
- [[notes/A38-finally-guarantees-resource-cleanup.idea|A38 - finally تضمن تنظيف المورد]]
- [[notes/A39-good-tests-check-public-contracts.idea|A39 - الاختبار الجيد يفحص العقد العام]]
- [[notes/A40-numerical-tolerances-follow-algorithm-accuracy.idea|A40 - التسامح العددي مشتق من دقة الخوارزمية]]

## شغّل الدرس

من جذر المستودع:

```bash
julia --project=. lessons/08_errors_resources_and_testing.jl
```

## مسار التنفيذ

يعرف الدرس استثناء إعداد، ويضيق try حول parse، ويستعمل finally لإبطال workspace، ثم يختبر الحالات الطبيعية والحواف والفشل.

## الكود الكامل

```julia
module Lesson08ErrorsResourcesAndTesting

using Test

struct ConfigurationError <: Exception
    key::String
    value::String
end

function Base.showerror(io::IO, error::ConfigurationError)
    print(io, "invalid value for ", error.key, ": ", repr(error.value))
end

# Catch only the operation whose error you intend to translate. A broad try/catch
# may hide your own bug and incorrectly report it as a configuration problem.
function parse_positive_float(key::AbstractString, text::AbstractString)
    value = try
        parse(Float64, text)
    catch error
        error isa ArgumentError || rethrow()
        throw(ConfigurationError(String(key), String(text)))
    end
    isfinite(value) && value > 0 || throw(ConfigurationError(String(key), String(text)))
    return value
end

# The callback comes first to support `do` syntax. `finally` guarantees cleanup
# even when the callback throws. Prefer standard APIs such as `open(...) do io`
# when one already exists for the resource.
function with_workspace(callback::F, count::Integer) where {F}
    count >= 0 || throw(ArgumentError("count must be nonnegative"))
    workspace = Vector{Float64}(undef, count)
    fill!(workspace, 0.0)
    try
        return callback(workspace)
    finally
        fill!(workspace, NaN) # Simulate invalidating an external resource after use.
    end
end

function normalized_energy(values)
    isempty(values) && throw(ArgumentError("values cannot be empty"))
    all(isfinite, values) || throw(DomainError(values, "all values must be finite"))
    scale = maximum(abs, values)
    iszero(scale) && return zero(float(eltype(values)))
    return sum(abs2, values ./ scale) * scale^2 / length(values)
end

function main()
    # A useful test checks public behavior, invariants, edge cases, and deliberate
    # failure. A tolerance should follow from algorithm accuracy, not convenience.
    @testset "configuration boundaries" begin
        @test parse_positive_float("dt", "0.125") == 0.125
        @test_throws ConfigurationError parse_positive_float("dt", "fast")
        @test_throws ConfigurationError parse_positive_float("dt", "-1")
    end

    @testset "resource ownership" begin
        result = with_workspace(8) do workspace
            workspace .= 1:8
            sum(workspace)
        end
        @test result == 36
    end

    @testset "numerical contract" begin
        @test normalized_energy([3.0, 4.0]) ≈ 12.5
        @test normalized_energy(zeros(Float32, 3)) === 0.0f0
        @test_throws ArgumentError normalized_energy(Float64[])
        @test_throws DomainError normalized_energy([1.0, Inf])
    end

    println("Behavior tests passed. The full package tests are in test/runtests.jl.")
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
```

## تجارب مقصودة

- اجعل callback ترمي وتحقق أن finally نفذت.
- أضف حالة `NaN` لاختبار الإعداد.
- اكتب تسامحًا مشتقًا من خطأ خوارزمية بدل رقم مريح.

> [!question]- اختبار استرجاع
> ما الخطر في catch واسعة حول دالة كبيرة؟

> [!success]- الإجابة
> قد تمسك bug داخلية وتعيد تسميتها كخطأ مستخدم، فتخفي السبب والـ stack الصحيح.

## الملاحة

- الخريطة الأعلى: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس التالي: [[lessons/L09-algorithm-design.idea|L09 - تصميم الخوارزميات]]

