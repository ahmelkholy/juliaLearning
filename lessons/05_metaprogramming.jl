module Lesson05Metaprogramming

# A macro receives syntax before execution, not computed values. `esc` resolves
# caller code in the caller's scope, while the local variable is renamed
# hygienically so it cannot capture a caller variable by accident.
is_finite_value(value::Number) = isfinite(value)
is_finite_value(values) = all(isfinite, values)

macro ensure_finite(expression)
    return quote
        local result = $(esc(expression))
        is_finite_value(result) || throw(DomainError(result, "expression produced non-finite data"))
        result
    end
end

# A generated function runs during specialization and returns an expression. It
# can inspect types but not runtime values. Prefer a normal function unless code
# generation provides a measured benefit or expresses something genuinely clearer.
@generated function field_values(value::T) where {T}
    accesses = [:(getfield(value, $index)) for index in 1:fieldcount(T)]
    return Expr(:tuple, accesses...)
end

# Putting N inside `Val{N}` makes it part of the type, so generation can see it.
# Unrolling is reasonable for small N, but large values inflate compiled code;
# a normal loop is then the better choice.
@generated function literal_power(x, ::Val{N}) where {N}
    N isa Integer && N >= 0 || error("N must be a nonnegative integer")
    expression = :(one(x))
    for _ in 1:N
        expression = :($expression * x)
    end
    return expression
end

struct Experiment{T,S}
    gain::T
    label::S
end

function main()
    scale = 3.0
    values = @ensure_finite scale .* [1.0, 2.0, 3.0]
    @assert values == [3.0, 6.0, 9.0]
    @assert field_values(Experiment(2.5, :demo)) == (2.5, :demo)
    @assert literal_power(2, Val(10)) == 1024

    expanded = macroexpand(@__MODULE__, :(@ensure_finite scale + 1))
    println("Expression tree:")
    dump(:(scale .* values); maxdepth=3)
    println("Hygienic macro expansion: ", expanded)
    println("Fields returned by the generated function: ", field_values(Experiment(2.5, :demo)))
end

abspath(PROGRAM_FILE) == abspath((@__FILE__)) && main()

end # module
