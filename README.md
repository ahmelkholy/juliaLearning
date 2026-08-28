# Julia Mastery Lab

Julia Mastery Lab is a practical course for programmers who already know MATLAB or Python. It focuses on the ideas that make Julia code reusable, fast, and pleasant to extend: multiple dispatch, parametric types, compiler inference, memory-aware array code, interfaces, numerical algorithms, metaprogramming, concurrency, package design, and testing.

This repository is also a real Julia package. Each lesson starts with a small idea, runs as a complete program, and connects to the final ODE solver and matrix-free Conjugate Gradient solver. The code is intentionally readable so you can see why each design decision exists.

## Start here

1. Open the complete Arabic Word guide: [`docs/Julia_Mastery_Arabic_Guide.docx`](docs/Julia_Mastery_Arabic_Guide.docx).
2. Open the Arabic Foam/Obsidian vault: [`JuliaMastery-Arabic-Vault/README.idea.md`](JuliaMastery-Arabic-Vault/README.idea.md).
3. From this repository directory, install dependencies and run the tests:

   ```bash
   julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.test()'
   ```

4. Check your course progress:

   ```bash
   julia --project=. scripts/learning_coach.jl status
   ```

5. Start the first quest:

   ```bash
   julia --project=. scripts/learning_coach.jl start 1
   ```

You can also run a lesson directly:

```bash
julia --project=. lessons/01_dispatch_and_types.jl
```

Run the complete course with:

```bash
julia --project=. scripts/run_all.jl
```

## Course map

| Quest | Executable lesson | Main idea |
|---:|---|---|
| 1 | `lessons/01_dispatch_and_types.jl` | Parametric types, multiple dispatch, traits, and ambiguities |
| 2 | `lessons/02_arrays_and_numerics.jl` | Column-major arrays, views, broadcasting, and generic arithmetic |
| 3 | `lessons/03_performance_and_inference.jl` | Specialization, type stability, function barriers, and allocations |
| 4 | `lessons/04_interfaces_and_iteration.jl` | Informal interfaces, custom arrays, iteration, and callable objects |
| 5 | `lessons/05_metaprogramming.jl` | Expressions, macro hygiene, generated functions, and their limits |
| 6 | `lessons/06_concurrency.jl` | Tasks, channels, threads, safe reductions, and reproducibility |
| 7 | `lessons/07_package_architecture.jl` | Files, modules, imports, exports, and reusable APIs |
| 8 | `lessons/08_errors_resources_and_testing.jl` | Exceptions, cleanup, contracts, and numerical tests |
| 9 | `lessons/09_algorithm_design.jl` | Stable summation, online statistics, and matrix-free algorithms |
| 10 | `lessons/10_scientific_capstone.jl` | A complete scientific workflow and convergence experiment |

The detailed objectives, experiments, checkpoints, and optional boss challenges are in [`LEARNING_PATH.md`](LEARNING_PATH.md).

## The learning loop

For each lesson:

1. Read one small section.
2. Predict the output before running it.
3. Run the lesson.
4. Change one thing and observe what breaks.
5. Repair it and explain the cause in your own words.
6. Use `@which`, `@code_warntype`, or `@code_typed` on the important function.
7. Complete the checkpoint and record the quest with the learning coach.

For performance work, put the operation inside a function and run the same method once before measuring it. This separates compilation time from steady-state execution time.

## Repository map

```text
src/                         Reusable JuliaMastery package
lessons/                     Ten executable lessons
lessons/architecture_demo/   Small multi-file module used by lesson 7
exercises/                   Starter code with deliberate TODOs
solutions/                   Reference solutions; open after attempting a task
test/                        Package behavior and numerical tests
scripts/run_all.jl           Runs every lesson in a fresh Julia process
scripts/learning_coach.jl    Tracks quests, points, and next steps
docs/                        Arabic Word guide
JuliaMastery-Arabic-Vault/   Arabic Foam/Obsidian Zettelkasten with linked code notes
```

## Advanced practice

`exercises/advanced_exercises.jl` contains starter functions and four larger assignments. Attempt them before opening `solutions/advanced_solutions.jl`. Working code is only the first level of mastery. You should also be able to explain:

- why Julia selected a particular method;
- the type of every important value;
- who owns each mutable array;
- where an allocation may occur;
- why the numerical algorithm is stable;
- how a function can cross file boundaries without creating namespace problems.

## Common setup issues

- Make sure Julia is available with `julia --version`.
- Keep `--project=.` in commands so Julia uses this repository's environment.
- Run commands from the repository root unless the command uses an absolute path.
- If packages are missing, run `julia --project=. -e 'using Pkg; Pkg.instantiate()'`.
- For the concurrency lesson, use `julia --threads=auto --project=. lessons/06_concurrency.jl`.

The course supports Julia 1.10 and later.
