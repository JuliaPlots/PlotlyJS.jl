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

# methods to re-construct a plot from JSON
function symboldict{T<:AbstractString}(d::Associative{T})
    d2 = Dict{Symbol,Any}()
    map(k -> setindex!(d2, d[k], symbol(k)), keys(d))
    d2
end

GenericTrace(d::Associative{Symbol}) = GenericTrace(pop!(d, :type, "scatter"), d)
GenericTrace{T<:AbstractString}(d::Associative{T}) = GenericTrace(symboldict(d))
Layout{T<:AbstractString}(d::Associative{T}) = Layout(symboldict(d))

function JSON.parse(::Type{Plot}, str::AbstractString)
    d = JSON.parse(str)
    data = GenericTrace[GenericTrace(tr) for tr in d["data"]]
    layout = Layout(d["layout"])
    Plot(data, layout)
end

JSON.parsefile(::Type{Plot}, fn) =
    open(fn, "r") do f; JSON.parse(Plot, readall(f)) end
