module PlotlyJS

using Base64
using Reexport
@reexport using PlotlyBase
using PlotlyKaleido: PlotlyKaleido
using JSON
using REPL, Pkg, Pkg.Artifacts, DelimitedFiles  # stdlib

# need to import some functions because methods are meta-generated
import PlotlyBase:
    restyle!, relayout!, update!, addtraces!, deletetraces!, movetraces!,
    redraw!, extendtraces!, prependtraces!, purge!, to_image, download_image,
    restyle, relayout, update, addtraces, deletetraces, movetraces, redraw,
    extendtraces, prependtraces, prep_kwargs, sizes, _tovec,
    react, react!, add_trace!

using WebIO
using JSExpr
using JSExpr: @var, @new
using Blink
using Pkg.Artifacts
if !isdefined(Base, :get_extension)
    using Requires
end

export plot, dataset, list_datasets, make_subplots, savefig, mgrid

# globals for this package
const _pkg_root = dirname(dirname(@__FILE__))
const _js_path = joinpath(artifact"plotly-artifacts", "plotly.min.js")
const _js_version = include(joinpath(_pkg_root, "deps", "plotly_cdn_version.jl"))
const _js_cdn_path = "https://cdn.plot.ly/plotly-$(_js_version).min.js"
const _mathjax_cdn_path =
    "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_SVG"

struct PlotlyJSDisplay <: AbstractDisplay end

# include the rest of the core parts of the package
include("display.jl")
include("util.jl")
include("kaleido.jl")

make_subplots(;kwargs...) = plot(Layout(Subplots(;kwargs...)))

@doc (@doc Subplots) make_subplots

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


@enum RENDERERS BLINK IJULIA BROWSER DOCS

const DEFAULT_RENDERER = Ref(BLINK)

function set_default_renderer(s::RENDERERS)
    global DEFAULT_RENDERER
    DEFAULT_RENDERER[] = s
end

@inline get_renderer() = DEFAULT_RENDERER[]

list_datasets() = readdir(joinpath(artifact"plotly-artifacts", "datasets"))
function check_dataset_exists(name::String)
    ds = list_datasets()
    name_ext = Dict(name => strip(ext, '.') for (name, ext) in splitext.(ds))
    if !haskey(name_ext, name)
        error("Unknown dataset $name, known datasets are $(collect(keys(name_ext)))")
    end
    ds_path = joinpath(artifact"plotly-artifacts", "datasets", "$(name).$(name_ext[name])")
    return ds_path
end

function dataset(name::String)::Dict{String,Any}
    ds_path = check_dataset_exists(name)
    if endswith(ds_path, "csv")
        # if csv, use DelimitedFiles and convert to dict
        data = DelimitedFiles.readdlm(ds_path, ',')
        return Dict(zip(data[1, :], data[2:end, i] for i in 1:size(data, 2)))
    elseif endswith(ds_path, "json")
        # use json
        return JSON.parsefile(ds_path)
    end
    error("should not ever get here!!! Please file an issue")
end


function __init__()
    _build_log = joinpath(_pkg_root, "deps", "build.log")
    if isfile(_build_log) && occursin("Warning:", read(_build_log, String))
        @warn("Warnings were generated during the last build of PlotlyJS:  please check the build log at $_build_log")
    end

    if !isfile(_js_path)
        @info("plotly.js javascript library not found -- downloading now")
        include(joinpath(_pkg_root, "deps", "build.jl"))
    end
    
    if ccall(:jl_generating_output, Cint, ()) != 1
        # ensure precompilation of packages depending on PlotlyJS finishes
        PlotlyKaleido.start(plotlyjs=_js_path)
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

    @static if !isdefined(Base, :get_extension)
        @require JSON3 = "0f8b85d8-7281-11e9-16c2-39a750bddbf1" include("../ext/JSON3Ext.jl")
        @require IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a" include("../ext/IJuliaExt.jl")

        @require CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b" begin
            include("../ext/CSVExt.jl")
            @require DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0" begin
                include("../ext/DataFramesExt.jl")
            end
        end
    end
end

# for methods that update the layout, first apply to the plot, then let plotly.js
# deal with the rest via the react function
for (k, v) in vcat(PlotlyBase._layout_obj_updaters, PlotlyBase._layout_vector_updaters)
    @eval function PlotlyBase.$(k)(p::SyncPlot, args...;kwargs...)
        $(k)(p.plot, args...; kwargs...)
        send_command(p.scope, :react, p.plot.data, p.plot.layout)
    end
end

for k in [:add_hrect!, :add_hline!, :add_vrect!, :add_vline!, :add_shape!, :add_layout_image!]
    @eval function PlotlyBase.$(k)(p::SyncPlot, args...;kwargs...)
        $(k)(p.plot, args...; kwargs...)
        send_command(p.scope, :react, p.plot.data, p.plot.layout)
    end
end

function unsafe_electron(deb=false)  # https://github.com/JuliaGizmos/Blink.jl/issues/325#issuecomment-2252670794
    # workaround for github.com/JuliaGizmos/Blink.jl/issues/325
    # inspired from github.com/Eben60/PackageMaker.jl/commit/297219f5c14845bf75de4475cabab4dbf6e6599d
    @eval Blink.AtomShell Window(args...; kwargs...) = Window(shell(; debug = $deb), args...; kwargs...)

    @eval Blink.AtomShell function init(; debug = $deb)
        electron() # Check path exists
        p, dp = port(), port()
        debug && inspector(dp)
        dbg = debug ? "--inspect=$dp" : []
        # vvvvvvvvvvvv begin addition
        cmd = `$(electron()) --no-sandbox $dbg $mainjs port $p`
        # ^^^^^^^^^^^^ end addition
        proc = (debug ? run_rdr : run)(cmd; wait = false)
        conn = try_connect(ip"127.0.0.1", p)
        shell = Electron(proc, conn)
        initcbs(shell)
        return shell
    end
end

end  # module
