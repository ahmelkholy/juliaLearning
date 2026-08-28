"""A small package that demonstrates a real multi-file architecture."""
module ArchitectureDemo

export Plant, Simulation, simulate

# Include each file exactly once. All three files live in the same module, so their
# functions can call each other directly without imports between files.
include("types.jl")
include("simulation.jl")
include("display.jl")

end # module
