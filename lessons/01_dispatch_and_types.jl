module Lesson01DispatchAndTypes

using InteractiveUtils: which

# Start with one question: who owns a method? In Python, it is usually a class.
# In Julia, methods belong to a function, so dispatch can use every argument type.
# An abstract type names a family; a concrete type stores actual data.
abstract type AbstractShape end

struct Circle{T<:Real} <: AbstractShape
    radius::T

    function Circle(radius::T) where {T<:Real}
        radius >= zero(T) || throw(ArgumentError("radius must be nonnegative"))
        new{T}(radius)
    end
end

struct Rectangle{T<:Real} <: AbstractShape
    width::T
    height::T
end

area(shape::Circle) = π * shape.radius^2
area(shape::Rectangle) = shape.width * shape.height

# An interaction between two shapes belongs to neither shape alone. Multiple
# dispatch is a natural fit because it can inspect both argument types.
overlaps(::Circle, ::Circle) = "use a center-distance test"
overlaps(::Rectangle, ::Rectangle) = "use interval separation"
overlaps(::AbstractShape, ::AbstractShape) = "use the generic convex-shape method"

# `Point{N,T}` stores the dimension N and number type T in the type itself.
# Addition accepts different number types and promotes them instead of forcing
# every value to be Float64.
struct Point{N,T<:Real}
    coordinates::NTuple{N,T}
end

Point(values::Vararg{T,N}) where {T<:Real,N} = Point{N,T}(values)

function Base.:+(left::Point{N,T}, right::Point{N,S}) where {N,T,S}
    R = promote_type(T, S)
    coordinates = ntuple(i -> convert(R, left.coordinates[i]) + right.coordinates[i], Val(N))
    return Point(coordinates)
end

# A trait selects behavior by a property that may not belong in the inheritance
# tree. It avoids Boolean flags and lets an external type join with one method.
abstract type EvaluationStyle end
struct ClosedForm <: EvaluationStyle end
struct Sampled <: EvaluationStyle end

evaluation_style(::Type) = Sampled()
evaluation_style(::Type{<:Circle}) = ClosedForm()

describe_evaluation(value) = describe_evaluation(evaluation_style(typeof(value)), value)
describe_evaluation(::ClosedForm, _) = "analytic implementation"
describe_evaluation(::Sampled, _) = "generic sampled implementation"

# The first two methods are ambiguous for `(Integer, Integer)`. Resolve their
# intersection explicitly with a third method; definition order is not a tie-breaker.
relation(::Real, ::Integer) = :right_discrete
relation(::Integer, ::Real) = :left_discrete
relation(::Integer, ::Integer) = :both_discrete

function main()
    circle = Circle(2.0)
    rectangle = Rectangle(3, 4)
    mixed_point = Point(1, 2) + Point(0.5, 1.5)

    @assert area(rectangle) == 12
    @assert mixed_point == Point(1.5, 3.5)
    @assert relation(1, 2) === :both_discrete
    @assert describe_evaluation(circle) == "analytic implementation"
    @assert describe_evaluation(rectangle) == "generic sampled implementation"

    println("Circle area: ", area(circle))
    println("Method selected by Julia: ", which(area, (typeof(circle),)))
    println("Dispatch between two shape types: ", overlaps(circle, rectangle))
    println("Point type after promotion: ", typeof(mixed_point))
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
