__precompile__()

module PlotlyJS

using Reexport
@reexport using PlotlyBase
using JSON
using Base.Iterators

# need to import some functions because methods are meta-generated
import PlotlyBase:
    restyle!, relayout!, update!, addtraces!, deletetraces!, movetraces!,
    redraw!, extendtraces!, prependtraces!, purge!, to_image, download_image,
    restyle, relayout, update, addtraces, deletetraces, movetraces, redraw,
    extendtraces, prependtraces, prep_kwargs, sizes, savefig, _tovec

using Blink
using Blink.JSString
using Requires

# globals for this package
const _pkg_root = dirname(dirname(@__FILE__))
const _js_path = joinpath(_pkg_root, "assets", "plotly-latest.min.js")
const _js_cdn_path = "https://cdn.plot.ly/plotly-latest.min.js"
const _mathjax_cdn_path =
    "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_SVG"

const _autoresize = [true]
autoresize(b::Bool) = (_autoresize[1] = b; b)
autoresize() = _autoresize[1]

abstract type AbstractPlotlyDisplay end

# include the rest of the core parts of the package
include("display.jl")
include("util.jl")
include("savefig.jl")

function docs()
    schema_path = joinpath(dirname(dirname(@__FILE__)), "deps", "schema.html")
    if !isfile(schema_path)
        msg = "schema docs not built. Run `Pkg.build(\"PlotlyJS\")` to generate"
        error(msg)
    end
    w = Blink.Window()
    wait(w.content)
    for f in [
        "https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js",
        "http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css",
        "http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
        ]
        Blink.load!(w.content, f)
        wait(w.content)
    end
    Blink.content!(w, "html", open(readstring, schema_path), fade=false)
end

export

    # core types
    ElectronDisplay, JupyterDisplay, ElectronPlot, JupyterPlot,

    # other methods
    savefig, svg_data, png_data, jpeg_data, webp_data, autoresize,

    # helper methods
    plot, fork,

    # frontend methods
    init_notebook

@require Rsvg include("savefig_cairo.jl")

function _savefig_cairo(x...)
    msg = """
    Rsvg.jl must be loaded in order to save in this format. Please ensure
    that Rsvg is installed, then call `using Rsvg` before trying your command
    again
    """
    error(msg)
end

@init begin
    if !isfile(_js_path)
        info("plotly.js javascript libary not found -- downloading now")
        include(joinpath(_pkg_root, "deps", "build.jl"))
    end
end

end # module
