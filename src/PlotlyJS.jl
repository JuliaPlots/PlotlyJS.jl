module PlotlyJS

using Base64
using Reexport
@reexport using PlotlyBase
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
using Requires

export plot, dataset, list_datasets, make_subplots, savefig, mgrid

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

    kaleido_task = Base.Threads.@spawn _start_kaleido_process()

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

    @require JSON2 = "2535ab7d-5cd8-5a07-80ac-9b1792aadce3" JSON2.write(io::IO, p::SyncPlot) = JSON2.write(io, p.plot)
    @require JSON3 = "0f8b85d8-7281-11e9-16c2-39a750bddbf1" begin
        JSON3.write(io::IO, p::SyncPlot) = JSON.print(io, p.plot)
        JSON3.write(p::SyncPlot) = JSON.json(p.plot)
    end

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

    @require CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b" begin
        function dataset(::Type{CSV.File}, name::String)
            ds_path = check_dataset_exists(name)
            if !endswith(ds_path, "csv")
                error("Can only construct CSV.File from a csv data source")
            end
            CSV.File(ds_path)
        end
        @require DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0" begin
            dataset(::Type{DataFrames.DataFrame}, name::String) = DataFrames.DataFrame(dataset(CSV.File, name))
        end
    end

    wait(kaleido_task)

    if ccall(:jl_generating_output, Cint, ()) == 1
        # ensure precompilation of packages depending on PlotlyJS finishes
        if isdefined(P, :proc)
            close(P.stdin)
            wait(P.proc)
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

end # module
