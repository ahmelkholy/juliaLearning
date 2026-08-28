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
