__precompile__()

module PlotlyJS


using Base.Iterators
using JSON
using Blink
using Colors
using DocStringExtensions
using Requires

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
const _mathjax_cdn_path =
    "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_SVG"

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
abstract type AbstractPlotlyDisplay end

# core plot object
mutable struct Plot{TT<:AbstractTrace}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
    style::Style
end

# include the rest of the core parts of the package
include("display.jl")
include("util.jl")
include("json.jl")
include("subplots.jl")
include("api.jl")
include("savefig.jl")
include("convenience_api.jl")
@require DataFrames include("dataframes_api.jl")
include("recession_bands.jl")

# Set some defaults for constructing `Plot`s
function Plot(;style::Style=CURRENT_STYLE[])
    Plot(GenericTrace{Dict{Symbol,Any}}[], Layout(), Base.Random.uuid4(), style)
end

function Plot{T<:AbstractTrace}(data::AbstractVector{T}, layout=Layout();
                                style::Style=CURRENT_STYLE[])
    Plot(data, layout, Base.Random.uuid4(), style)
end

function Plot(data::AbstractTrace, layout=Layout();
              style::Style=CURRENT_STYLE[])
    Plot([data], layout; style=style)
end

function docs()
    schema_path = joinpath(dirname(dirname(@__FILE__)), "deps", "schema.html")
    if !isfile(schema_path)
        msg = "schema docs not built. Run `Pkg.build(\"PlotlyJS\")` to generate"
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
    use_style!, style, Style, Cycler


## borrowed from Compose.jl
function isinstalled(pkg, ge=v"0.0.0-")
    try
        # Pkg.installed might throw an error,
        # we need to account for it to be able to precompile
        ver = Pkg.installed(pkg)
        ver == nothing && try
            # Assume the version is new enough if the package is in LOAD_PATH
            ex = Expr(:import, Symbol(pkg))
            @eval $ex
            return true
        catch
            return false
        end
        return ver >= ge
    catch
        return false
    end
end

@static if isinstalled("Cairo") && isinstalled("Rsvg")
    include("savefig_cairo.jl")
else
    function _savefig_cairo(x...)
        lib_fn = joinpath(Base.LOAD_CACHE_PATH[1], "PlotlyJS.ji")
        msg = """
        Cairo and Rsvg need to be installed in order to save in this format

        Use `Pkg.add("Rsvg")` to install both of them.

        You then need to delete $(lib_fn) and restart your Julia session
        """
        error(msg)
    end
end



@init begin
    if !isfile(_js_path)
        info("plotly.js javascript libary not found -- downloading now")
        include(joinpath(dirname(_js_path), "build.jl"))
    end

    env_style = Symbol(get(ENV, "PLOTLYJS_STYLE", ""))
    if env_style in STYLES
        global DEFAULT_STYLE
        DEFAULT_STYLE[] = Style(env_style)
    end

end


end # module
