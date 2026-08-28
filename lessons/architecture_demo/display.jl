# Extending a function from another module must be explicit. Qualify the name as
# `Base.show`, or write `import Base: show` before an unqualified definition.
function Base.show(io::IO, plant::Plant)
    print(io, "Plant(decay=", plant.decay, ", input_gain=", plant.input_gain, ')')
end

function Base.show(io::IO, result::Simulation)
    print(io, "Simulation(", length(result), " samples, final_state=", last(result.state), ')')
end
