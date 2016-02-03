module PlotlyJS

using JSON
using Blink
using Colors

# globals for this package
const _js_path = joinpath(dirname(dirname(@__FILE__)),
                          "deps", "plotly-latest.min.js")
const _js_cdn_path = "https://cdn.plot.ly/plotly-latest.min.js"


abstract AbstractPlotlyElement
abstract AbstractTrace <: AbstractPlotlyElement
abstract AbstractLayout <: AbstractPlotlyElement

abstract AbstractPlotlyDisplay

type ElectronDisplay <: AbstractPlotlyDisplay
    w::Nullable{Window}
    js_loaded::Bool
end

ElectronDisplay() = ElectronDisplay(Nullable{Window}(), false)

isactive(ed::ElectronDisplay) = isnull(ed.w) ? false : Blink.active(get(ed.w))

# include these here because they are used below
include("traces_layouts.jl")

type Plot{TT<:AbstractTrace,TD<:AbstractPlotlyDisplay}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
    _display::TD
end

Plot() = Plot(GenericTrace[], Layout(), Base.Random.uuid4(), ElectronDisplay())

Plot{T<:AbstractTrace}(data::Vector{T}, layout=Layout()) =
    Plot(data, layout, Base.Random.uuid4(), ElectronDisplay())

Plot(data::AbstractTrace, layout=Layout()) = Plot([data], layout)

typealias ElectronPlot{TT<:AbstractTrace} Plot{TT,ElectronDisplay}

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

Base.show(io::IO, p::Plot) = writemime(io, MIME("text/plain"), p)

prep_kwarg(pair) = (symbol(replace(string(pair[1]), "_", ".")), pair[2])
prep_kwargs(pairs) = Dict(map(prep_kwarg, pairs))

# include the rest of the package
include("display.jl")
include("api.jl")
include("subplots.jl")
include("json.jl")

# NOTE: additional exports in api.jl
export

    # core types
    Plot, GenericTrace, Layout,

    # other methods
    savefig, svg_data, png_data, jpeg_data, webp_data

    # plotly.js api methods
    restyle!, relayout!, addtraces!, deletetraces!, movetraces!, redraw!,
    extendtraces!, prependtraces!

end # module
