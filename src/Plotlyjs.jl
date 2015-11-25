module Plotlyjs

using JSON
using Blink
using Colors
using Base.Cartesian

export Plot, GenericTrace, Layout

abstract AbstractPlotlyElement
abstract AbstractTrace <: AbstractPlotlyElement
abstract AbstractLayout <: AbstractPlotlyElement

type Plot{TT<:AbstractTrace}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
    window::Nullable{Window}
end

Plot() = Plot([], Layout(), Base.Random.uuid4(), Nullable{Window}())

Plot{T<:AbstractTrace}(data::Vector{T}, layout=Layout()) =
    Plot(data, layout, Base.Random.uuid4(), Nullable{Window}())

Plot(data::AbstractTrace, layout=Layout()) = Plot([data], layout)

function Base.writemime(io::IO, ::MIME"text/plain", p::Plot)
    println(io, """
    data: $(json(p.data, 2))

    layout: $(json(p.layout, 2))
    """)
end

include("display.jl")
include("api.jl")
include("traces_layouts.jl")
# include("Errors.jl")
# include("TraceTypes.jl")
# include("Scatter.jl")

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

# show(Plot())
end # module
