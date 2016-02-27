module PlotlyJS

using JSON
using Blink
using Colors

# globals for this package
const _js_path = joinpath(dirname(dirname(@__FILE__)),
                          "deps", "plotly-latest.min.js")
const _js_cdn_path = "https://cdn.plot.ly/plotly-latest.min.js"

# include these here because they are used below
include("traces_layouts.jl")
abstract AbstractPlotlyDisplay

type Plot{TT<:AbstractTrace,TD<:AbstractPlotlyDisplay}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
    _display::TD
end

# include the rest of the core parts of the package
include("display.jl")
include("api.jl")
include("subplots.jl")
include("json.jl")

# Set some defaults for constructing `Plot`s
Plot() = Plot(GenericTrace[], Layout(), Base.Random.uuid4(), ElectronDisplay())

Plot{T<:AbstractTrace}(data::Vector{T}, layout=Layout()) =
    Plot(data, layout, Base.Random.uuid4(), ElectronDisplay())

Plot(data::AbstractTrace, layout=Layout()) = Plot([data], layout)

export

    # core types
    Plot, GenericTrace, Layout,

    # other methods
    savefig, svg_data, png_data, jpeg_data, webp_data

    # plotly.js api methods
    restyle!, relayout!, addtraces!, deletetraces!, movetraces!, redraw!,
    extendtraces!, prependtraces!

end # module
