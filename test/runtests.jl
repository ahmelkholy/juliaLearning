using Test
using LinearAlgebra
using JuliaMastery

# These tests use the package like an external user: they call public API instead
# of including `src` files. Internal refactoring is safe while the contract remains.

@testset "ODE: problem and algorithm construction" begin
    @test Euler(0.1).dt == 0.1
    @test RK4(0.1).dt == 0.1
    @test_throws ArgumentError Euler(0.0)
    @test_throws ArgumentError RK4(-0.1)
    @test_throws ArgumentError ODEProblem((u, p, t) -> u, 1.0, (1.0, 0.0))
end

@testset "ODE: accuracy and types" begin
    decay(state, rate, _) = -rate * state
    problem = ODEProblem(decay, 1.0, (0.0, 1.0), 2.0)

    euler_solution = solve(problem, Euler(0.001); save_every=100)
    rk4_solution = solve(problem, RK4(0.025))

    @test isapprox(euler_solution.u[end], exp(-2); rtol=0.003)
    @test isapprox(rk4_solution.u[end], exp(-2); rtol=1e-6)
    @test last(euler_solution.t) == 1.0
    @test length(euler_solution) == 11
    @test first(collect(rk4_solution)) == (0.0, 1.0)

    float32_problem = ODEProblem(decay, 1.0f0, (0.0f0, 0.2f0), 2.0f0)
    float32_solution = solve(float32_problem, RK4(0.01f0))
    @test eltype(float32_solution.u) === Float32
    @test eltype(float32_solution.t) === Float32

    initial = [1.0, 0.0]
    oscillator(state, _, _) = [state[2], -state[1]]
    vector_solution = solve(ODEProblem(oscillator, initial, (0.0, 0.2)), RK4(0.01))
    vector_solution.u[1][1] = 99.0
    @test initial == [1.0, 0.0] # Every saved state owns an independent copy.

    @test_throws ArgumentError solve(problem, RK4(0.1); save_every=0)
end

# Add an algorithm from the test file without touching `src`. Success demonstrates
# that `step` and `step_size` are real extension points rather than decoration.
struct Midpoint{T<:Real} <: AbstractStepper
    dt::T
end

JuliaMastery.step_size(algorithm::Midpoint) = algorithm.dt

function JuliaMastery.step(f, state, parameters, time, dt, ::Midpoint)
    first_slope = f(state, parameters, time)
    midpoint_state = state + (dt / 2) * first_slope
    return state + dt * f(midpoint_state, parameters, time + dt / 2)
end

@testset "ODE: extension from outside the package" begin
    problem = ODEProblem((state, _, _) -> -state, 1.0, (0.0, 1.0))
    coarse_error = abs(solve(problem, Midpoint(0.1)).u[end] - exp(-1))
    fine_error = abs(solve(problem, Midpoint(0.05)).u[end] - exp(-1))
    @test coarse_error / fine_error > 3.5
end

@testset "CG: matrix and callable operator" begin
    matrix = [4.0 1.0; 1.0 3.0]
    right_hand_side = [1.0, 2.0]

    matrix_result = cg(matrix, right_hand_side; rtol=1e-12)
    function_result = cg(x -> matrix * x, right_hand_side; rtol=1e-12)

    @test matrix_result.converged
    @test matrix * matrix_result.x ≈ right_hand_side
    @test function_result.x ≈ matrix_result.x
    @test matrix_result.iterations <= length(right_hand_side)

    float32_result = cg(Float32.(matrix), Float32.(right_hand_side))
    @test eltype(float32_result.x) === Float32

    complex_matrix = ComplexF64[3 1+im; 1-im 4]
    complex_rhs = ComplexF64[1+im, 2-im]
    complex_result = cg(complex_matrix, complex_rhs; rtol=1e-12)
    @test complex_result.converged
    @test complex_matrix * complex_result.x ≈ complex_rhs
end

@testset "CG: boundaries and deliberate failure" begin
    zero_result = cg(Matrix{Float64}(I, 3, 3), zeros(3))
    @test zero_result.converged
    @test zero_result.iterations == 0

    stopped_result = cg(Matrix{Float64}(I, 2, 2), ones(2); maxiter=0)
    @test !stopped_result.converged
    @test stopped_result.iterations == 0

    @test_throws DimensionMismatch cg(Matrix{Float64}(I, 2, 2), ones(2); x0=zeros(3))
    @test_throws ConvergenceError cg(-Matrix{Float64}(I, 2, 2), ones(2))
    @test_throws ArgumentError cg(Matrix{Float64}(I, 2, 2), ones(2); rtol=-1)
end
