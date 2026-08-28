module Lesson10ScientificCapstone

using LinearAlgebra
using JuliaMastery: Euler, ODEProblem, RK4, solve

# The final lesson combines a model, immutable data, an algorithm object, and a
# generic solver. The model does not know solver details, and the solver does not
# know oscillator details. This separation lets the design outlive one script.
struct Oscillator{T<:Real}
    angular_frequency::T
end

function (model::Oscillator)(state, _, _)
    position, velocity = state
    return [velocity, -(model.angular_frequency^2) * position]
end

energy(state, model::Oscillator) = 0.5 * (state[2]^2 + (model.angular_frequency * state[1])^2)

function maximum_energy_drift(solution, model)
    initial_energy = energy(first(solution.u), model)
    return maximum(state -> abs(energy(state, model) - initial_energy), solution.u)
end

function convergence_order(model, initial_state, final_time, step_sizes)
    errors = map(step_sizes) do step
        problem = ODEProblem(model, initial_state, (0.0, final_time))
        numerical = solve(problem, RK4(step)).u[end]
        exact = [cos(model.angular_frequency * final_time), -model.angular_frequency * sin(model.angular_frequency * final_time)]
        norm(numerical - exact)
    end
    orders = log2.(errors[1:end-1] ./ errors[2:end])
    return errors, orders
end

function main()
    model = Oscillator(2.0)
    problem = ODEProblem(model, [1.0, 0.0], (0.0, 20.0))
    euler_solution = solve(problem, Euler(0.01); save_every=10)
    rk4_solution = solve(problem, RK4(0.01); save_every=10)

    euler_drift = maximum_energy_drift(euler_solution, model)
    rk4_drift = maximum_energy_drift(rk4_solution, model)
    @assert rk4_drift < euler_drift
    @assert last(rk4_solution.t) == 20.0

    errors, observed_orders = convergence_order(model, [1.0, 0.0], 1.0, [0.1, 0.05, 0.025])
    @assert all(order -> order > 3.8, observed_orders)

    println("Maximum Euler energy drift: ", euler_drift)
    println("Maximum RK4 energy drift: ", rk4_drift)
    println("RK4 errors: ", errors)
    println("Measured convergence orders: ", observed_orders)
    println("Next project: port a real MATLAB or Python model and compare the results.")
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
