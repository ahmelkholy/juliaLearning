module Lesson03PerformanceAndInference

# With an abstract field, the compiler may need to discover the concrete type at
# runtime. A parametric type records the vector's concrete type in the object type.
struct AbstractFieldKernel
    coefficients::AbstractVector
end

struct ParametricKernel{V<:AbstractVector}
    coefficients::V
end

(kernel::AbstractFieldKernel)(x) = sum(kernel.coefficients .* x)
(kernel::ParametricKernel)(x) = sum(kernel.coefficients .* x)

# A dynamic decision at the program boundary is fine. A function barrier passes
# its concrete result into a small kernel that the compiler can specialize.
function load_values(kind::Symbol, count::Integer)
    kind === :f32 && return fill(Float32(0.25), count)
    kind === :f64 && return fill(0.25, count)
    throw(ArgumentError("kind must be :f32 or :f64"))
end

sum_squares(kind, count) = sum_squares_kernel(load_values(kind, count))

function sum_squares_kernel(values)
    accumulator = zero(eltype(values))
    @inbounds @simd for index in eachindex(values)
        accumulator += abs2(values[index])
    end
    return accumulator
end

# Because storage is column-major, rows belong in the inner loop. This function
# mutates its input so memory allocation remains outside the numerical kernel.
function scale_columns!(matrix, scales)
    size(matrix, 2) == length(scales) || throw(DimensionMismatch("one scale per column required"))
    @inbounds for column in axes(matrix, 2)
        scale = scales[column]
        @simd for row in axes(matrix, 1)
            matrix[row, column] *= scale
        end
    end
    return matrix
end

function main()
    values = rand(10_000)
    abstract_kernel = AbstractFieldKernel(values)
    parametric_kernel = ParametricKernel(values)

    # The first call may compile code, so warm up the same method before measuring.
    abstract_kernel(values)
    parametric_kernel(values)
    abstract_bytes = @allocated abstract_kernel(values)
    parametric_bytes = @allocated parametric_kernel(values)

    @assert abstract_kernel(values) ≈ parametric_kernel(values)
    @assert sum_squares(:f32, 8) isa Float32
    @assert sum_squares(:f64, 8) isa Float64

    matrix = ones(4, 3)
    scale_columns!(matrix, [1.0, 2.0, 3.0])
    @assert matrix[:, 3] == fill(3.0, 4)

    println("Allocation with an abstract field: ", abstract_bytes, " bytes")
    println("Allocation with a parametric field: ", parametric_bytes, " bytes")
    println("Try this: @code_warntype sum_squares_kernel(rand(100))")
    println("For a serious benchmark, warm up the method and interpolate inputs with BenchmarkTools.")
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
