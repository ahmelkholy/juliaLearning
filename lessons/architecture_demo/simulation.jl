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
