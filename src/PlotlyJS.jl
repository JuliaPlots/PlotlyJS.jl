__precompile__()

module PlotlyJS

using Compat; import Compat.String
using JSON
using Blink
using Colors

# import LaTeXStrings and export the handy macros
using LaTeXStrings
export @L_mstr, @L_str

# export some names from JSON
export json

# globals for this package
const _js_path = joinpath(dirname(dirname(@__FILE__)),
                          "deps", "plotly-latest.min.js")
const _js_cdn_path = "https://cdn.plot.ly/plotly-latest.min.js"
const _mathjax_cdn_path = "https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_SVG"

const _autoresize = [true]
autoresize(b::Bool) = (_autoresize[1] = b; b)
autoresize() = _autoresize[1]

_isijulia() = isdefined(Main, :IJulia) && Main.IJulia.inited

# include these here because they are used below
include("traces_layouts.jl")
abstract AbstractPlotlyDisplay

# core plot object
type Plot{TT<:AbstractTrace}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
end

# include the rest of the core parts of the package
include("json.jl")
include("display.jl")
include("subplots.jl")
include("api.jl")
include("savefig.jl")

# Set some defaults for constructing `Plot`s
Plot() = Plot(GenericTrace{Dict{Symbol,Any}}[], Layout(), Base.Random.uuid4())

Plot{T<:AbstractTrace}(data::Vector{T}, layout=Layout()) =
    Plot(data, layout, Base.Random.uuid4())

Plot(data::AbstractTrace, layout=Layout()) = Plot([data], layout)

function docs()
    schema_path = joinpath(dirname(dirname(@__FILE__)), "deps", "schema.html")
    w = Blink.Window()
    Blink.content!(w, "html", open(readall, schema_path), fade=false)
end

# NOTE: we export trace constructing types from inside api.jl
# NOTE: we export names of shapes from traces_layouts.jl
export

    # core types
    Plot, GenericTrace, Layout, Shape, ElectronDisplay, JupyterDisplay,
    ElectronPlot, JupyterPlot, AbstractTrace, AbstractLayout,

    # other methods
    savefig, svg_data, png_data, jpeg_data, webp_data, autoresize,

    # plotly.js api methods
    restyle!, relayout!, addtraces!, deletetraces!, movetraces!, redraw!,
    extendtraces!, prependtraces!,

    # non-!-versions (forks, then applies, then returns fork)
    restyle, relayout, addtraces, deletetraces, movetraces, redraw,
    extendtraces, prependtraces,

    # helper methods
    plot, fork, vline, hline, attr,

    # frontend methods
    init_notebook

function __init__()
    # --------------------------------------------- #
    # Code to run once when the notebook starts up! #
    # --------------------------------------------- #

    if _isijulia()

        init_notebook()

        @eval begin
            import IJulia
            import IJulia.CommManager: Comm, send_comm
        end

        # set up the comms we will use to send js messages to be executed
        global const _ijulia_eval_comm = Comm(:plotlyjs_eval)
        global const _ijulia_return_comms = ObjectIdDict()

        @eval begin
            function IJulia.display_dict(p::JupyterPlot)
                if p.view.displayed
                    Dict()
                else
                    p.view.displayed = true
                    Dict("text/html" => html_body(p))
                end
            end

            SyncPlot(p::Plot) = SyncPlot(p, JupyterDisplay(p))

            IJulia.display_dict(p::Plot) =
                Dict("text/plain" => sprint(writemime, "text/plain", p))

        end
    else
        @eval SyncPlot(p::Plot) = SyncPlot(p, ElectronDisplay())
    end

end


end # module
