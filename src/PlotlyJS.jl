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
    extendtraces, prependtraces, prep_kwargs, sizes, savefig, _tovec,
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
    Blink.content!(w, "html", open(f -> read(f, String), schema_path), fade=false, async=false)
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
        savefig(io, plt.plot, format=$fmt)
    end
end

@enum RENDERERS BLINK IJULIA BROWSER DOCS

const DEFAULT_RENDERER = Ref(BLINK)

function set_default_renderer(s::RENDERERS)
    global DEFAULT_RENDERER
    DEFAULT_RENDERER[] = s
end

@inline get_renderer() = DEFAULT_RENDERER[]


function __init__()
    _build_log = joinpath(_pkg_root, "deps", "build.log")
    if isfile(_build_log) && occursin("Warning:", read(_build_log, String))
        @warn("Warnings were generated during the last build of PlotlyJS:  please check the build log at $_build_log")
    end

    if !isfile(_js_path)
        @info("plotly.js javascript libary not found -- downloading now")
        include(joinpath(_pkg_root, "deps", "build.jl"))
    end

    # set default renderer
    # First check env var
    env_val = get(ENV, "PLOTLY_RENDERER_JULIA", missing)
    if !ismissing(env_val)
        env_symbol = Symbol(uppercase(env_val))
        options = Dict(v => k for (k, v) in collect(Base.Enums.namemap(PlotlyJS.RENDERERS)))
        renderer_int = get(options, env_symbol, missing)
        if ismissing(renderer_int)
            @warn "Unknown value for env var `PLOTLY_RENDERER_JULIA` \"$(env_val)\", known options are $(string.(keys(options)))"
        else
            set_default_renderer(RENDERERS(renderer_int))
        end
    else
        # we have no env-var
        # check IJULIA
        isdefined(Main, :IJulia) && Main.IJulia.inited && set_default_renderer(IJULIA)
    end

    # set up display
    insert!(Base.Multimedia.displays, findlast(x -> x isa Base.TextDisplay || x isa REPL.REPLDisplay, Base.Multimedia.displays) + 1, PlotlyJSDisplay())

    atreplinit(i -> begin
        while PlotlyJSDisplay() in Base.Multimedia.displays
            popdisplay(PlotlyJSDisplay())
        end
        insert!(Base.Multimedia.displays, findlast(x -> x isa REPL.REPLDisplay, Base.Multimedia.displays) + 1, PlotlyJSDisplay())
    end)

    @require IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a" begin

        function IJulia.display_dict(p::SyncPlot)
            Dict(
                "application/vnd.plotly.v1+json" => JSON.lower(p),
                "text/plain" => sprint(show, "text/plain", p),
                "text/html" => let
                    buf = IOBuffer()
                    show(buf, MIME("text/html"), p)
                    String(resize!(buf.data, buf.size))
                end
            )
        end
    end
end

end # module
