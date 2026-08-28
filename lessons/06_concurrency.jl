module Lesson06Concurrency

using Random: Xoshiro, randn
using Base.Threads

# A Channel is like a bounded conveyor belt: a producer adds work and a consumer
# removes it. When the buffer is full, backpressure limits memory growth.
function channel_squares(count::Integer)
    channel = Channel{Tuple{Int,Int}}(min(count, 32)) do output
        for index in 1:count
            put!(output, (index, index^2))
        end
    end
    return collect(channel)
end

# Each iteration owns one output index, so no lock is needed. Request the output
# type explicitly to avoid a `Vector{Any}` and its unpredictable performance.
function threaded_map(f, values, ::Type{T}) where {T}
    output = similar(values, T)
    @threads for index in eachindex(values, output)
        output[index] = f(values[index])
    end
    return output
end

# Do not accumulate into `partial[threadid()]`: tasks may migrate and chunks may
# compete for the same location. Here each logical chunk owns one stable slot.
function threaded_sum(values)
    isempty(values) && return zero(eltype(values))
    chunk_count = min(length(values), max(1, 4 * nthreads()))
    partials = zeros(eltype(values), chunk_count)
    count = length(values)

    @threads for chunk in 1:chunk_count
        first_index = fld((chunk - 1) * count, chunk_count) + 1
        last_index = fld(chunk * count, chunk_count)
        accumulator = zero(eltype(values))
        @inbounds for index in first_index:last_index
            accumulator += values[index]
        end
        partials[chunk] = accumulator
    end

    return sum(partials)
end

# A separate RNG for each logical simulation keeps results stable when thread
# scheduling changes. Sharing a mutable RNG can cause contention or a data race.
function deterministic_ensemble(seeds)
    output = Vector{Float64}(undef, length(seeds))
    @threads for index in eachindex(seeds)
        rng = Xoshiro(seeds[index])
        output[index] = sum(randn(rng, 1_000))
    end
    return output
end

function main()
    @assert channel_squares(4) == [(1, 1), (2, 4), (3, 9), (4, 16)]

    values = collect(1.0:10_000.0)
    mapped = threaded_map(sqrt, values, Float64)
    @assert mapped ≈ sqrt.(values)
    @assert threaded_sum(values) ≈ sum(values)

    seeds = UInt64[11, 22, 33, 44]
    first_run = deterministic_ensemble(seeds)
    second_run = deterministic_ensemble(seeds)
    @assert first_run == second_run

    println("Julia thread count: ", nthreads())
    println("Reproducible ensemble: ", first_run)
    println("Run with more threads: julia --threads=auto --project=. lessons/06_concurrency.jl")
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
