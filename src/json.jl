# -------------------------------- #
# Custom JSON output for our types #
# -------------------------------- #
function JSON._print(io::IO, state::JSON.State, a::GenericTrace)
    JSON.start_object(io, state, true)
    range = keys(a.fields)
    if length(range) > 0
        Base.print(io, JSON.prefix(state), "\"", :type, "\"", JSON.colon(state))
        JSON._print(io, state, a.kind)

        for name in range
            Base.print(io, ",")
            JSON.printsp(io, state)
            Base.print(io, "\"", name, "\"", colon(state))
            JSON._print(io, state, a.fields[name])
        end
    end
    JSON.end_object(io, state, true)
end

JSON._print(io::IO, state::JSON.State, a::Layout) = JSON._print(io, state, a.fields)

function JSON._print(io::IO, state::JSON.State, a::AbstractTrace)
    JSON.start_object(io, state, true)
    range = fieldnames(a)
    if length(range) > 0
        Base.print(io, JSON.prefix(state), "\"", :type, "\"", JSON.colon(state))
        JSON._print(io, state, plottype(a))

        for name in range
            Base.print(io, ",")
            JSON.printsp(io, state)
            Base.print(io, "\"", name, "\"", colon(state))
            JSON._print(io, state, a.(name))
        end
    end
    JSON.end_object(io, state, true)
end

JSON._print(io::IO, state::JSON.State, a::Colors.Colorant) =
    JSON._print(io, state, string("#", hex(a)))
