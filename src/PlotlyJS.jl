__precompile__()

module PlotlyJS

using Compat; import Compat: String, readstring, view
using JSON
using Blink
using Colors
using DocStringExtensions
using DataFrames

import Base: ==

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

_symbol_dict(x) = x
_symbol_dict(d::Associative) =
    Dict{Symbol,Any}([(Symbol(k), _symbol_dict(v)) for (k, v) in d])

# include these here because they are used below
include("traces_layouts.jl")
include("styles.jl")
abstract AbstractPlotlyDisplay

# core plot object
type Plot{TT<:AbstractTrace}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
    style::Style
end

# include the rest of the core parts of the package
include("display.jl")
include("json.jl")
include("subplots.jl")
include("api.jl")
include("savefig.jl")
include("convenience_api.jl")
include("recession_bands.jl")

# Set some defaults for constructing `Plot`s
function Plot(;style::Style=DEFAULT_STYLE[1])
    Plot(GenericTrace{Dict{Symbol,Any}}[], Layout(), Base.Random.uuid4(), style)
end

function Plot{T<:AbstractTrace}(data::Vector{T}, layout=Layout();
                                style::Style=DEFAULT_STYLE[1])
    Plot(data, layout, Base.Random.uuid4(), style)
end

function Plot(data::AbstractTrace, layout=Layout();
              style::Style=DEFAULT_STYLE[1])
    Plot([data], layout; style=style)
end

function docs()
    schema_path = joinpath(dirname(dirname(@__FILE__)), "deps", "schema.html")
    if !isfile(schem_path)
        msg = "schema docs not build. Run `Pkg.build(\"PlotlyJS\")` to generate"
        error(msg)
    end
    w = Blink.Window()
    for f in [
        "http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css",
        "https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js",
        "http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
        ]
        Blink.load!(w.content, f)
    end
    Blink.content!(w, "html", open(readstring, schema_path), fade=false)
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
    extendtraces!, prependtraces!, purge!, to_image, download_image,

    # non-!-versions (forks, then applies, then returns fork)
    restyle, relayout, addtraces, deletetraces, movetraces, redraw,
    extendtraces, prependtraces,

    # helper methods
    plot, fork, vline, hline, attr,

    # new trace types
    stem,

    # convenience stuff
    add_recession_bands!,

    # frontend methods
    init_notebook,

    # styles
    use_style!, style, Style

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
        global const _ijulia_eval_comm = Ref(Comm(:plotlyjs_eval))
        global const _ijulia_return_comms = ObjectIdDict()

        @eval begin
            function IJulia.display_dict(p::JupyterPlot)
                if p.view.displayed
                    Dict()
                else
                    p.view.displayed = true
                    Dict("text/html" => html_body(p),
                         "application/vnd.plotly.v1+json" => json(p))
                end
            end

            SyncPlot(p::Plot) = SyncPlot(p, JupyterDisplay(p))

            IJulia.display_dict(p::Plot) =
                Dict("text/plain" => sprint(show, "text/plain", p))

        end
    else
        @eval SyncPlot(p::Plot) = SyncPlot(p, ElectronDisplay(p))
    end

    global const DEFAULT_STYLE = [_default_style()]

end


end # module
