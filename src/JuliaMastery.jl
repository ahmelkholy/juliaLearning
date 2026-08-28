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
