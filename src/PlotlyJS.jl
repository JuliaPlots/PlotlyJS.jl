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
using Requires

export plot

# globals for this package
const _pkg_root = dirname(dirname(@__FILE__))
const _js_path = joinpath(_pkg_root, "assets", "plotly-latest.min.js")
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

function PlotlyBase.savefig(p::SyncPlot, args...)
    has_orca = haskey(Pkg.installed(), "ORCA")
    if has_orca
        error("Please call `using ORCA` to save figures")
    end

    if Base.isinteractive()
        msg = "Saving figures requires the ORCA package."
        msg *= " Would you like to install it? (Y/n) "
        print(msg)
        answer = readline()
        if length(answer) == 0
            answer = "y"
        end
        if lowercase(answer)[1] == 'y'
            println("here!!")
            println("Ok. Installing ORCA now...")
            Pkg.add("ORCA")
            @info("Please call `using ORCA` and try saving your plot again")
            return
        end
    end
    msg = "Please install ORCA separately, then call `using ORCA` and try again"
    error(msg)
end

function __init__()
    @require ORCA="47be7bcc-f1a6-5447-8b36-7eeeff7534fd" include("savefig_orca.jl")
    
    _build_log = joinpath(_pkg_root, "deps", "build.log")
    if occursin("Warning:", read(_build_log, String))
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
