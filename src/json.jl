# -------------------------------- #
# Custom JSON output for our types #
# -------------------------------- #
JSON._print(io::IO, state::JSON.State, a::HasFields) =
    JSON._print(io, state, a.fields)

JSON._print(io::IO, state::JSON.State, d::Base.Dates.Date) =
    JSON._print(io, state, "$(year(d))-$(month(d))-$(day(d))")

JSON._print(io::IO, state::JSON.State, p::Plot) =
    JSON._print(io, state, Dict(:data => p.data, :layout => p.layout))

JSON._print(io::IO, state::JSON.State, a::Colors.Colorant) =
    JSON._print(io, state, string("#", hex(a)))

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
