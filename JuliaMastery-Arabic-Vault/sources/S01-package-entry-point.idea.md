---
id: S01
aliases:
  - "كود نقطة دخول حزمة JuliaMastery"
type: source-note
status: complete
tags:
  - source/code
  - julia
source: src/JuliaMastery.jl
up: "[[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]"
cssclasses:
  - rtl-note
---

# كود نقطة دخول حزمة JuliaMastery


## غرض الملف

هذا الملف يعلن module الحزمة واعتمادها العام وواجهة export وترتيب include. اقرأه بوصفه خريطة ملكية، لا بوصفه مكان الحساب.

## أسئلة توجه القراءة

1. لماذا يأتي `ode.jl` قبل `iterative_solvers.jl`؟
2. أي الأسماء عامة وأيها يبقى تفصيلًا داخليًا؟

## الكود الكامل

```julia
"""
    JuliaMastery

The package's main module. This file coordinates dependencies, the public API,
and source-file order; numerical work is implemented in the included files.
"""
module JuliaMastery

# Load the dependency once. Every file under `src/` is part of this module, so an
# included file can use LinearAlgebra without another `using` statement.
using LinearAlgebra

# This is the public API. Names not exported here are internal implementation details.
export AbstractStepper,
       CGResult,
       ConvergenceError,
       Euler,
       ODEProblem,
       ODESolution,
       RK4,
       cg,
       solve,
       step,
       step_size

# `include` is not a Python import. It evaluates a file inside the current module.
# Include each source file once, with the ODE definitions before the linear solver.
include("ode.jl")
include("iterative_solvers.jl")

end # module
```

## روابط الفهم

- الخريطة: [[maps/M06-packages-errors-and-testing.idea|M06 - الحزم والأخطاء والاختبارات]]
- [[notes/A32-files-organize-source-modules-organize-names.idea|A32 - الملفات تنظم المصدر والوحدات تنظم الأسماء]]
- [[notes/A33-include-evaluates-files-in-current-module.idea|A33 - include يقيم الملف داخل الوحدة الحالية]]
- [[notes/A34-using-import-export-define-api-boundaries.idea|A34 - using و import و export تحدد حدود API]]
- [[notes/A36-small-public-apis-reduce-coupling.idea|A36 - واجهة عامة صغيرة تقلل الاقتران]]
- [[sources/S02-ode-solver-source.idea|S02 - كود محلل ODE]]
- [[sources/S03-conjugate-gradient-source.idea|S03 - كود Conjugate Gradient]]

