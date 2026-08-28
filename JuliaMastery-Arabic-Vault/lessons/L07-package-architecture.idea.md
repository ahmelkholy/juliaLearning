---
id: L07
aliases:
  - "الدرس 7: معمارية الحزم"
type: source-note
status: complete
tags:
  - course/lesson
  - course/lesson-07
  - julia
lesson: 7
source: lessons/07_package_architecture.jl
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# الدرس 7: معمارية الحزم

> [!goal] هدف الدرس
> أن تميز الملف من الوحدة والحزمة، وتفهم include، وتصمم API صغيرة قابلة للتوسعة.

## قبل التشغيل

تتبع كيف تستدعي `simulation.jl` الدالة `rhs` المعرفة في ملف آخر من دون import بين الملفين.

## شبكة المفاهيم

- [[notes/A32-files-organize-source-modules-organize-names.idea|A32 - الملفات تنظم المصدر والوحدات تنظم الأسماء]]
- [[notes/A33-include-evaluates-files-in-current-module.idea|A33 - include يقيم الملف داخل الوحدة الحالية]]
- [[notes/A34-using-import-export-define-api-boundaries.idea|A34 - using و import و export تحدد حدود API]]
- [[notes/A35-project-and-manifest-fix-package-environment.idea|A35 - Project و Manifest يثبتان بيئة الحزمة]]
- [[notes/A36-small-public-apis-reduce-coupling.idea|A36 - واجهة عامة صغيرة تقلل الاقتران]]

## شغّل الدرس

من جذر المستودع:

```bash
julia --project=. lessons/07_package_architecture.jl
```

## مسار التنفيذ

يحمّل الدرس module تعليمية من عدة ملفات، يستورد أسماءها العامة فقط، ثم يستعمل حزمة `JuliaMastery` الحقيقية من البيئة.

## الكود الكامل

```julia
module Lesson07PackageArchitecture

# This answers a common question: how does one file call a function from another?
# `include` evaluates source inside the current module; it is not a Python-style
# runtime import. Anchor the path to `@__DIR__` so any working directory works.
include(joinpath(@__DIR__, "architecture_demo", "ArchitectureDemo.jl"))

# Import only the public names needed here. The internal `rhs` can be qualified
# during debugging, but users should not depend on it because it is not public API.
using .ArchitectureDemo: Plant, Simulation, simulate

# Load a real package by name from the environment. An application should not
# include package `src` files because that can create a second module and distinct
# type identities that merely look the same.
using JuliaMastery: ODEProblem, RK4, solve

function package_layout_notes()
    # A common professional layout:
    #
    # src/MyPackage.jl     Declares the module, dependencies, exports, and includes.
    # src/types.jl         Defines data types and their invariants.
    # src/algorithms.jl    Contains algorithms that use the types and helpers.
    # src/adapters.jl      Translates external files and libraries at the boundary.
    # test/runtests.jl     Tests public behavior and numerical invariants.
    #
    # In short: files organize code; modules organize namespaces. Do not create a
    # submodule for every file. Use one only when there is a real boundary.
    return nothing
end

function reusable_api_notes()
    # A reusable function asks for the smallest interface it needs. Accept `values`
    # or `AbstractVector` instead of `Vector{Float64}` unless the algorithm truly
    # needs that exact storage and type. Type annotations are contracts and dispatch
    # choices, not general-purpose performance decorations.
    #
    # Keep dynamic choices at the boundary and concrete kernels inside. Pass typed,
    # immutable configuration, export a small API, and prefer algorithm objects and
    # dispatch to a large switch over strings or symbols.
    #
    # From another local application's environment, run once:
    #   using Pkg; Pkg.develop(path="path/to/MyPackage")
    # Then use the package normally:
    #   using MyPackage: Model, solve
    return nothing
end

function main()
    plant = Plant(0.8, 2)
    times = collect(range(0.0, 2.0; length=101))
    result::Simulation = simulate(plant, 0.0, times, _ -> 1.0)
    @assert length(result) == length(times)
    @assert result.state[end] > result.state[1]

    problem = ODEProblem((state, decay, _) -> -decay * state, 1.0, (0.0, 1.0), 2.0)
    package_result = solve(problem, RK4(0.01))
    @assert isapprox(package_result.u[end], exp(-2); rtol=1e-7)

    package_layout_notes()
    reusable_api_notes()
    println("Small package split across files: ", plant, " -> ", result)
    println("Call into a package loaded by name: ", package_result)
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
```

## الملف المساند: `lessons/architecture_demo/ArchitectureDemo.jl`

```julia
"""A small package that demonstrates a real multi-file architecture."""
module ArchitectureDemo

export Plant, Simulation, simulate

# Include each file exactly once. All three files live in the same module, so their
# functions can call each other directly without imports between files.
include("types.jl")
include("simulation.jl")
include("display.jl")

end # module
```

## الملف المساند: `lessons/architecture_demo/types.jl`

```julia
"""A first-order system: `dx/dt = -decay*x + input_gain*u(t)`."""
struct Plant{T<:Real}
    decay::T
    input_gain::T

    function Plant(decay::T, input_gain::T) where {T<:Real}
        decay >= zero(T) || throw(ArgumentError("decay must be nonnegative"))
        return new{T}(decay, input_gain)
    end
end

function Plant(decay::Real, input_gain::Real)
    promoted_decay, promoted_gain = promote(decay, input_gain)
    return Plant(promoted_decay, promoted_gain)
end

# This function is internal and not exported. `simulation.jl` can call it directly
# because both files belong to `ArchitectureDemo`; a file is not a namespace.
rhs(plant::Plant, state, input) = -plant.decay * state + plant.input_gain * input

struct Simulation{T,U}
    time::Vector{T}
    state::Vector{U}
end

Base.length(result::Simulation) = length(result.time)
Base.getindex(result::Simulation, index::Integer) = result.state[index]
```

## الملف المساند: `lessons/architecture_demo/simulation.jl`

```julia
"""
    simulate(plant, initial_state, times, input)

Solve a `Plant` with Euler steps at user-provided times. `input` may be any
callable object, including a closure, a normal function, or a stateful model.
"""
function simulate(plant::Plant, initial_state, times, input)
    length(times) >= 1 || throw(ArgumentError("times cannot be empty"))
    issorted(times) || throw(ArgumentError("times must be sorted"))
    all(diff(times) .> 0) || throw(ArgumentError("times must be strictly increasing"))

    promoted_state = initial_state * one(eltype(times))
    states = Vector{typeof(promoted_state)}(undef, length(times))
    states[1] = promoted_state

    for index in 2:length(times)
        previous_time = times[index - 1]
        step = times[index] - previous_time
        states[index] = states[index - 1] +
                        step * rhs(plant, states[index - 1], input(previous_time))
    end

    return Simulation(collect(times), states)
end
```

## الملف المساند: `lessons/architecture_demo/display.jl`

```julia
# Extending a function from another module must be explicit. Qualify the name as
# `Base.show`, or write `import Base: show` before an unqualified definition.
function Base.show(io::IO, plant::Plant)
    print(io, "Plant(decay=", plant.decay, ", input_gain=", plant.input_gain, ')')
end

function Base.show(io::IO, result::Simulation)
    print(io, "Simulation(", length(result), " samples, final_state=", last(result.state), ')')
end
```

## تجارب مقصودة

- قارن `names(ArchitectureDemo)` و`names(...; all=true)`.
- انقل helper إلى ملف آخر داخل الوحدة وتأكد أن اسمها المؤهل لم يتغير.
- أنشئ حزمة صغيرة واستعملها عبر `Pkg.develop`.

> [!question]- اختبار استرجاع
> لماذا لا ينبغي للتطبيق أن يعمل include يدويًا لملفات `src` في حزمة؟

> [!success]- الإجابة
> لأنه قد يعيد تقييم الوحدة ويخلق أنواعًا بهويات مختلفة، ويتجاوز نظام البيئة والحزمة.

## الملاحة

- الخريطة الأعلى: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- الدرس التالي: [[lessons/L08-errors-resources-and-testing.idea|L08 - الأخطاء والموارد والاختبارات]]

