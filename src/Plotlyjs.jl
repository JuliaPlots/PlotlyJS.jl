module Plotlyjs

using JSON
using Blink
using Colors

abstract AbstractPlotlyElement
abstract AbstractTrace <: AbstractPlotlyElement
abstract AbstractLayout <: AbstractPlotlyElement

type Plot{TT<:AbstractTrace}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
    window::Nullable{Window}
end

type GenericTrace{T<:Associative} <: AbstractTrace
    kind::ASCIIString
    fields::T
end

type Layout{T<:Associative} <: AbstractLayout
    fields::T
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

# include the rest of the package
include("display.jl")
include("api.jl")
include("traces_layouts.jl")
include("subplots.jl")
include("json.jl")

# NOTE: additional exports in api.jl
export

    # core types
    Plot, GenericTrace, Layout,

    # plotly.js api methods
    restyle!, relayout!, addtraces!, deletetraces!, movetraces!, redraw!

end # module
