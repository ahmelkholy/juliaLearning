module AdvancedExercises

using LinearAlgebra
using JuliaMastery

# This file is intentionally incomplete. Replace every TODO, write a test before
# the implementation, and open the reference solution only after attempting,
# measuring, and checking inference in your own version.

"""
    pairwise_sum(values; cutoff=128)

Implement recursive pairwise summation for an `AbstractVector`. Preserve the
element type, define behavior for empty input and unusual indices, avoid slicing
allocations, and compare numerical error with `sum` and a left fold.
"""
function pairwise_sum(values; cutoff=128)
    error("TODO: implement pairwise_sum")
end

"""
Create `Heun <: AbstractStepper`, validate dt, and extend JuliaMastery's
`step_size` and `step` interfaces without editing `src`. Demonstrate second-order
convergence for `du/dt=-2u` with at least three different step sizes.
"""
struct HeunExercisePlaceholder end

"""
    power_iteration(operator, initial; tolerance, maxiter)

Implement a dominant-eigenpair solver without requiring a matrix. Accept a matrix
or callable operator through a small interface, return a typed convergence report,
handle sign or phase ambiguity, and reject a zero initial vector.
"""
function power_iteration(operator, initial; tolerance=1e-10, maxiter=1_000)
    error("TODO: implement power_iteration")
end

"""
Implement a fixed-capacity `CircularBuffer{T} <: AbstractVector{T}` with `size`,
`IndexStyle`, `getindex`, and `push!`. Define and document its full-buffer behavior.
Make `collect`, `sum`, and broadcasting work, then inspect inference for reads and writes.
"""
struct CircularBufferExercisePlaceholder end

# Architecture assignment: create a package with `Pkg.generate`, split it into an
# entry point, types, interfaces, algorithms, and adapters, then use it from a
# separate application through `Pkg.develop`. Include each file once, export fewer
# than ten names, and test Float32, Float64, BigFloat, a view, a range, invalid
# inputs, and a callable operator of your own.

end # module
