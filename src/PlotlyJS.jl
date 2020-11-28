module PlotlyJS

using Reexport
@reexport using PlotlyBase
using JSON
using REPL, Pkg

# need to import some functions because methods are meta-generated
import PlotlyBase:
    restyle!, relayout!, update!, addtraces!, deletetraces!, movetraces!,
    redraw!, extendtraces!, prependtraces!, purge!, to_image, download_image,
    restyle, relayout, update, addtraces, deletetraces, movetraces, redraw,
    extendtraces, prependtraces, prep_kwargs, sizes, savefig, _tovec, html_body,
    react, react!

using WebIO
using JSExpr
using JSExpr: @var, @new
using Blink
using Pkg.Artifacts
using Requires

export plot

# globals for this package
const _pkg_root = dirname(dirname(@__FILE__))
const _js_path = joinpath(artifact"plotly-artifacts", "plotly.min.js")
const _js_cdn_path = "https://cdn.plot.ly/plotly-latest.min.js"
const _mathjax_cdn_path =
    "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_SVG"

struct PlotlyJSDisplay <: AbstractDisplay end

# include the rest of the core parts of the package
include("display.jl")
include("util.jl")

function docs()
    schema_path = joinpath(dirname(dirname(@__FILE__)), "deps", "schema.html")
    if !isfile(schema_path)
        msg = "schema docs not built. Run `Pkg.build(\"PlotlyJS\")` to generate"
        error(msg)
    end
    w = Blink.Window()
    wait(w.content)
    Blink.content!(w, "html", open(f->read(f, String), schema_path), fade=false, async=false)
end

PlotlyBase.savefig(p::SyncPlot, a...; k...) = savefig(p.plot, a...; k...)
PlotlyBase.savefig(io::IO, p::SyncPlot, a...; k...) = savefig(io, p.plot, a...; k...)

for (mime, fmt) in PlotlyBase._KALEIDO_MIMES
    @eval function Base.show(
        io::IO, ::MIME{Symbol($mime)}, plt::SyncPlot,
        width::Union{Nothing,Int}=nothing,
        height::Union{Nothing,Int}=nothing,
        scale::Union{Nothing,Real}=nothing,
    )
        savefig(io, plt.plot, format = $fmt)
    end
end


function __init__()
    _build_log = joinpath(_pkg_root, "deps", "build.log")
    if isfile(_build_log) && occursin("Warning:", read(_build_log, String))
        @warn("Warnings were generated during the last build of PlotlyJS:  please check the build log at $_build_log")
    end

    if !isfile(_js_path)
        @info("plotly.js javascript libary not found -- downloading now")
        include(joinpath(_pkg_root, "deps", "build.jl"))
    end

    insert!(Base.Multimedia.displays, findlast(x -> x isa Base.TextDisplay || x isa REPL.REPLDisplay, Base.Multimedia.displays) + 1, PlotlyJSDisplay())

    atreplinit(i -> begin
        while PlotlyJSDisplay() in Base.Multimedia.displays
            popdisplay(PlotlyJSDisplay())
        end
        insert!(Base.Multimedia.displays, findlast(x -> x isa REPL.REPLDisplay, Base.Multimedia.displays) + 1, PlotlyJSDisplay())
    end)
end

end # module
