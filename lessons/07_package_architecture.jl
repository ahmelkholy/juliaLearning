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
