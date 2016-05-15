# -------------------------------- #
# Custom JSON output for our types #
# -------------------------------- #
# Shape and GenericTrace have the same fields and json representation
function JSON._print(io::IO, state::JSON.State, a::Union{Shape,GenericTrace})
    JSON.start_object(io, state, true)
    range = keys(a.fields)
    if length(range) > 0
        Base.print(io, JSON.prefix(state), "\"", :type, "\"", JSON.colon(state))
        JSON._print(io, state, a.kind)

        for name in range
            Base.print(io, ",")
            JSON.printsp(io, state)
            Base.print(io, "\"", name, "\"", JSON.colon(state))
            JSON._print(io, state, a.fields[name])
        end
    end
    JSON.end_object(io, state, true)
end

JSON._print(io::IO, state::JSON.State, a::Union{PlotlyAttribute,Layout}) =
    JSON._print(io, state, a.fields)

JSON._print(io::IO, state::JSON.State, a::Colors.Colorant) =
    JSON._print(io, state, string("#", hex(a)))

JSON._print(io::IO, state::JSON.State, d::Base.Dates.Date) =
    JSON._print(io, state, "$(year(d))-$(month(d))-$(day(d))")

function JSON._print(io::IO, state::JSON.State, p::Plot)
    JSON.start_object(io, state, true)

    # print data
    Base.print(io, JSON.prefix(state), "\"data\"", JSON.colon(state))
    JSON._print(io, state, p.data)
    Base.print(io, ",")

    # print layout
    JSON.printsp(io, state)
    Base.print(io, JSON.prefix(state), "\"layout\"", JSON.colon(state))
    JSON._print(io, state, p.layout)
    JSON.end_object(io, state, true)
end

# Let string interpolation stringify to JSON format
Base.print(io::IO, a::Union{Shape,GenericTrace,PlotlyAttribute,Layout,Plot}) = print(io, JSON.json(a))
Base.print{T<:GenericTrace}(io::IO, a::Vector{T}) = print(io, JSON.json(a))

# methods to re-construct a plot from JSON
_symbol_dict(x) = x
_symbol_dict(d::Associative) =
    Dict{Symbol,Any}([(symbol(k), _symbol_dict(v)) for (k, v) in d])

GenericTrace(d::Associative{Symbol}) = GenericTrace(pop!(d, :type, "scatter"), d)
GenericTrace{T<:AbstractString}(d::Associative{T}) = GenericTrace(_symbol_dict(d))
Layout{T<:AbstractString}(d::Associative{T}) = Layout(_symbol_dict(d))

function JSON.parse(::Type{Plot}, str::AbstractString)
    d = JSON.parse(str)
    data = GenericTrace[GenericTrace(tr) for tr in d["data"]]
    layout = Layout(d["layout"])
    Plot(data, layout)
end

JSON.parsefile(::Type{Plot}, fn) =
    open(fn, "r") do f; JSON.parse(Plot, readall(f)) end
