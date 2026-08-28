# Julia Mastery Quest Map

This file turns the repository into ten short quests. Use the Arabic Word guide for the full explanation and this page as your action list.

## Points and progress

Each completed checkpoint is worth 100 XP. The learning coach records completion locally in `.julia_mastery_progress.toml`; that file is ignored by Git.

```bash
julia --project=. scripts/learning_coach.jl status
julia --project=. scripts/learning_coach.jl next
julia --project=. scripts/learning_coach.jl quiz 1
```

The coach never changes lesson source code. A quest is complete only after you run its lesson and answer its checkpoint. If an experiment breaks, that is useful evidence, not lost progress.

## A strong 35-minute session

1. **Recall — 5 minutes:** explain yesterday's main idea without opening a file.
2. **Predict — 5 minutes:** read a small code block and write down its output or type.
3. **Run — 10 minutes:** execute the lesson and inspect one function with compiler tools.
4. **Change — 10 minutes:** alter one assumption, observe the failure, and repair it.
5. **Record — 5 minutes:** answer the checkpoint and write one sentence about what changed in your mental model.

Stop after a clear win. Returning tomorrow with one unanswered question is more useful than rushing through three lessons.

## Quest 1 — Dispatch detective

**File:** `lessons/01_dispatch_and_types.jl`

**Goal:** understand that functions own methods and Julia selects a method from all argument types.

**Before running:** predict the types of `Point(1, 2)`, `Point(0.5, 1.5)`, and their sum.

**Run:**

```bash
julia --project=. scripts/learning_coach.jl start 1
```

**Experiment:** remove `relation(::Integer, ::Integer)`, then call `relation(1, 2)`. Read the ambiguity message and restore the method.

**Tool move:** evaluate `methods(area)` and `@which area(Circle(2.0))` in the REPL.

**Checkpoint:** do methods belong to a class, a function, or a module?

**Boss challenge:** add a `Square` without editing existing `area` methods.

## Quest 2 — Memory map

**File:** `lessons/02_arrays_and_numerics.jl`

**Goal:** distinguish copies from views and write generic, allocation-aware array code.

**Before running:** predict which value changes after assigning through `viewed_column`.

**Experiment:** replace `@view matrix[:, 2]` with `matrix[:, 2]` and explain the changed assertion. Then compare `transpose` and `'` on a complex vector.

**Tool move:** use `@allocated matrix[:, 2]` and `@allocated @view(matrix[:, 2])` inside a function.

**Checkpoint:** does a view copy its selected data?

**Boss challenge:** make `affine!` work with a matrix view and with `Float32` inputs.

## Quest 3 — Compiler whisperer

**File:** `lessons/03_performance_and_inference.jl`

**Goal:** recognize type instability, use a function barrier, and measure allocations correctly.

**Before running:** decide which kernel gives the compiler more field-type information.

**Experiment:** inspect both callable kernels with `@code_warntype`. Change `load_values` so one branch returns integers, then follow the type through `sum_squares`.

**Tool move:** warm up a method before using `@allocated`.

**Checkpoint:** why can an abstract struct field make a hot loop harder to optimize?

**Boss challenge:** rewrite a small MATLAB or NumPy loop as a mutating Julia kernel with allocation outside the loop.

## Quest 4 — Interface builder

**File:** `lessons/04_interfaces_and_iteration.jl`

**Goal:** build useful behavior from a small informal interface.

**Before running:** list the minimum methods that let `AffineGrid` act like an `AbstractVector`.

**Experiment:** add `Base.eltype` explicitly, even though the parent type already provides it. Confirm that behavior does not change. Then change the halving threshold.

**Tool move:** call `collect`, `sum`, broadcasting, and indexing on the custom types.

**Checkpoint:** must a custom iterable subtype `Array`?

**Boss challenge:** create a lazy arithmetic sequence with reverse iteration.

## Quest 5 — Syntax mechanic

**File:** `lessons/05_metaprogramming.jl`

**Goal:** understand expressions, macro hygiene, and the narrow role of generated functions.

**Before running:** predict whether the macro's local `result` can overwrite a caller variable with the same name.

**Experiment:** inspect the macro expansion. Temporarily remove `esc`, call the macro with a local variable, and explain the scope error before restoring it.

**Tool move:** use `dump`, `quote`, and `macroexpand` before writing a new macro.

**Checkpoint:** what does `esc` do for caller-provided syntax?

**Boss challenge:** write a small assertion macro that evaluates its expression exactly once.

## Quest 6 — Reproducibility engineer

**File:** `lessons/06_concurrency.jl`

**Goal:** use channels and threads without hidden races or schedule-dependent random results.

**Run with threads:**

```bash
julia --threads=auto --project=. lessons/06_concurrency.jl
```

**Before running:** identify which output locations can be written by more than one task.

**Experiment:** change the seed order and verify that each logical simulation still has its own reproducible stream.

**Tool move:** compare `Threads.nthreads()` in a normal run and a `--threads=auto` run.

**Checkpoint:** should random generators be assigned by physical thread or logical simulation?

**Boss challenge:** return both the mean and variance from deterministic threaded chunks.

## Quest 7 — Package architect

**File:** `lessons/07_package_architecture.jl`

**Goal:** understand the separate jobs of files, modules, packages, imports, and exports.

**Before running:** trace how `simulate` can call `rhs` even though they live in different files.

**Experiment:** qualify `ArchitectureDemo.rhs` at the REPL, then explain why application code should still avoid depending on it.

**Tool move:** use `names(ArchitectureDemo)` and `names(ArchitectureDemo; all=true)` to compare public and internal names.

**Checkpoint:** which organizes source and which organizes namespaces: files or modules?

**Boss challenge:** generate a tiny package, split it into three source files, and use it through `Pkg.develop`.

## Quest 8 — Failure designer

**File:** `lessons/08_errors_resources_and_testing.jl`

**Goal:** make invalid states clear, guarantee cleanup, and test contracts instead of implementation details.

**Before running:** predict which exceptions are translated to `ConfigurationError` and which are rethrown.

**Experiment:** make the workspace callback throw. Confirm that the `finally` block still runs by adding a temporary diagnostic line.

**Tool move:** write one happy-path test, one boundary test, and one deliberate-failure test.

**Checkpoint:** what guarantee does `finally` provide?

**Boss challenge:** design a custom exception with a concise `showerror` method for one of your own models.

## Quest 9 — Numerical guardian

**File:** `lessons/09_algorithm_design.jl`

**Goal:** recognize cancellation, stable reductions, online statistics, and matrix-free operators.

**Before running:** calculate `[1e16, 1.0, -1e16]` from left to right using floating-point reasoning.

**Experiment:** permute the difficult values and compare native and compensated results. Increase the matrix-free operator dimension without allocating a dense matrix.

**Tool move:** check a solver with a relative residual, not only by inspecting its answer vector.

**Checkpoint:** what does compensated summation preserve that ordinary addition may lose?

**Boss challenge:** add a diagonal preconditioner interface to a copy of the CG experiment.

## Quest 10 — Scientific finisher

**File:** `lessons/10_scientific_capstone.jl`

**Goal:** connect models, algorithms, invariants, error measurement, and convergence evidence.

**Before running:** predict which method has lower energy drift and why.

**Experiment:** halve RK4's step size and measure the error ratio. Then make the simulation longer and compare the two methods' energy drift.

**Tool move:** never claim an accuracy order from one run; estimate it from a sequence of refinements.

**Checkpoint:** when RK4's step is halved in the asymptotic regime, by roughly what factor should its error decrease?

**Boss challenge:** port one model you already trust in MATLAB or Python and create a numerical cross-check.

## Final gate

After all ten quests, run:

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
julia --project=. scripts/run_all.jl
julia --project=. solutions/advanced_solutions.jl
```

You are ready for the advanced exercises when you can explain each of these without notes:

- why method ambiguity occurs;
- when a slice allocates and a view does not;
- what makes a function type-stable;
- how a small interface unlocks generic behavior;
- why macro hygiene matters;
- what makes threaded randomness reproducible;
- why files are not namespaces;
- how cleanup survives an exception;
- how cancellation damages a sum;
- how a convergence study supports an accuracy claim.
