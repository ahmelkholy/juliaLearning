module Lesson04InterfacesAndIteration

# A Julia interface is often an informal contract: implement a few methods and
# many generic functions begin to work. This grid acts like a vector without
# storing every element.
struct AffineGrid{T<:Real} <: AbstractVector{T}
    origin::T
    step::T
    count::Int

    function AffineGrid(origin::T, step::T, count::Integer) where {T<:Real}
        count >= 0 || throw(ArgumentError("count must be nonnegative"))
        return new{T}(origin, step, Int(count))
    end
end

function AffineGrid(origin::Real, step::Real, count::Integer)
    promoted_origin, promoted_step = promote(origin, step)
    return AffineGrid(promoted_origin, promoted_step, count)
end

Base.size(grid::AffineGrid) = (grid.count,)
Base.IndexStyle(::Type{<:AffineGrid}) = IndexLinear()

function Base.getindex(grid::AffineGrid, index::Int)
    @boundscheck checkbounds(grid, index)
    return grid.origin + (index - 1) * grid.step
end

# An object can be callable. This is useful for models and operators: data stays
# in a concrete type while the call remains simple, such as `transform(x)`.
struct AffineMap{A,B}
    scale::A
    offset::B
end

(map::AffineMap)(x) = muladd(map.scale, x, map.offset)

# The iteration protocol returns `(value, next_state)`, or `nothing` at the end.
# This sequence is iterable, but it does not need to pretend it is an array.
struct HalvingSequence{T<:AbstractFloat}
    initial::T
    threshold::T
end

# `collect` also asks whether the length is known in advance. Here it depends on
# the values, so `SizeUnknown` prevents Base from expecting a `length` method.
Base.IteratorSize(::Type{<:HalvingSequence}) = Base.SizeUnknown()
Base.eltype(::Type{HalvingSequence{T}}) where {T} = T

function Base.iterate(sequence::HalvingSequence, state=sequence.initial)
    state < sequence.threshold && return nothing
    return (state, state / 2)
end

function main()
    grid = AffineGrid(0, 0.25, 5)
    @assert eltype(grid) === Float64
    @assert collect(grid) == [0.0, 0.25, 0.5, 0.75, 1.0]
    @assert sum(grid) == 2.5
    @assert sin.(grid) ≈ sin.(collect(grid))

    transform = AffineMap(2.0, -1.0)
    @assert transform.(grid) ≈ 2 .* collect(grid) .- 1

    sequence = HalvingSequence(1.0, 0.1)
    @assert collect(sequence) == [1.0, 0.5, 0.25, 0.125]

    println("Lazy grid type: ", typeof(grid))
    println("Broadcast over our custom array: ", transform.(grid))
    println("Our custom iterator: ", collect(sequence))
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
