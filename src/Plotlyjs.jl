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

function _describe(x::Union{GenericTrace, Layout})
    fields = sort(map(string, keys(x.fields)))
    n_fields = length(fields)
    if n_fields == 0
        return "$(kind(x)) with no fields"
    elseif n_fields == 1
        return "$(kind(x)) with field $(fields[1])"
    elseif n_fields == 2
        return "$(kind(x)) with fields $(fields[1]) and $(fields[2])"
    else
        return "$(kind(x)) with fields $(join(fields, ", ", ", and "))"
    end
end

function Base.writemime(io::IO, ::MIME"text/plain", p::Plot)
    println(io, """
    data: $(json(map(_describe, p.data), 2))
    layout: "$(_describe(p.layout))"
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

    # other methods
    savefig, to_svg, png_data,

    # plotly.js api methods
    restyle!, relayout!, addtraces!, deletetraces!, movetraces!, redraw!

end # module
