using JSServe
using PlotlyBase

mutable struct SyncPlot
    plot::PlotlyBase.Plot
    # scope::Scope # TODO: This is for WebIO, need to use a different thing for JSServe
    observables::Dict{Observable}
    window::Union{Nothing,Blink.Window} # Blink is not supported. Use Electron/ElectronDisplay
end

function SyncPlot(
    p::Plot,
    kwargs...
)
    lowered = JSON.lower(p)
    id = string("#plot-", p.divid)

    deps = [
        "Plotly" => joinpath(artifact"plotly-artifacts", "plotly.min.js"),
        joinpath(@__DIR__, "..", "assets", "plotly_webio.bundle.js")
    ]

    dependencies = setup_dependencies()

    # Initialize the app
    app = JSServe.App() do session::JSServe.Session
        observables = setup_observables()
        setup_callbacks(session, observables)

        # TODO: Translate `onimport` block
    end
end

function setup_dependencies()
    const deps = Dict(
        "Plotly" => JSServe.Dependency(:Plotly, [joinpath(artifact"plotly-artifacts", "plotly.min.js")])
    )
    return deps
end

function setup_observables()
    observables = Dict()
    
    # INPUT observables: plot events
    observables["image"] = Observable(Dict())
    observables["hover"] = Observable(Dict())
    observables["selected"] = Observable(Dict())
    observables["click"] = Observable(Dict())
    observables["relayout"] = Observable(Dict())
    observables["__gd_contents"] = Observable{Any}(Dict())  # for testing

    # OUTPUT observables: sends modify commands
    observables["_commands"] = Observable{Any}([])
    observables["_toImage"] = Observable(Dict())
    observables["_downloadImage"] = Observable(Dict())
    observables["__get_gd_contents"] = Observable("")

    return observables
end

# Sets up OUTPUT callbacks for Plotly events
function setup_callbacks(session, observables)
    # Register callback for plotly.toImage method
    onjs(session, observables["_toImage"], @js function (options)
        this.Plotly.toImage(this.plotElem, options).then(function (data)
            $(observables["image"])[] = data
        end) 
    end)

    # Register callback for Plotly._commands method
    # Do the respective action when _commands is triggered
    onjs(session, observables["_commands"], @js function (args)
        @var fn = args.shift()
        @var elem = this.plotElem
        @var Plotly = this.Plotly
        args.unshift(elem) # use div as first argument
        Plotly[fn].apply(this, args)
    end)

    # Register _downloadImage callback
    onjs(session, observables["_downloadImage"], @js function (args)
        this.Plotly.downloadImage(this.plotElem, options)
    end)

    # Register __get_gd_contents callback
    onjs(session, observables["__get_gd_contents"], @js function (prop)
        if prop == "data"
            $(observables["__gd_contents"])[] = this.plotElem.data
        end

        if prop == "layout"
            $(observables["__gd_contents"])[] = this.plotElem.layout
        end
    end)
end

# Sends a command to the Plotly front end through the observables
function send_command(observables, cmd, args...)
    observables["_commands"][] = [cmd, args...]
    nothing
end

# Command functions =======================================================
# Each of these first updates the Julia object, then sends a command to update the display

function restyle!(
        plt::SyncPlot, 
        ind::Union{Int,AbstractVector{Int}},
        update::AbstractDict=Dict(),
        kwargs...
    )
    restyle!(plt.plot, ind, update; kwargs...) # TODO: Which restyle is being called here? 
    send_command(plt.observables, :restyle, merge(update, prep_kwargs(kwargs)), ind .- 1)
end

function restyle!(plt::SyncPlot, update::AbstractDict=Dict(); kwargs...)
    restyle!(plt.plot, update; kwargs...)
    send_command(plt.observables, :restyle, merge(update, prep_kwargs(kwargs)))
end

function relayout!(plt::SyncPlot, update::AbstractDict=Dict(); kwargs...)
    relayout!(plt.plot, update; kwargs...)
    update!(plt, layout=plt.plot.layout)
end

function react!(plt::SyncPlot, data::AbstractVector{<:AbstractTrace}, layout::Layout)
    react!(plt.plot, data, layout)
    send_command(plt.observables, :react, data, layout)
end

function update!(
    plt::SyncPlot, ind::Union{Int,AbstractVector{Int}},
    update::AbstractDict=Dict();
    layout::Layout=Layout(),
    kwargs...
)
    update!(plt.plot, ind, update; layout=layout, kwargs...)
    send_command(plt.observables, :update, merge(update, prep_kwargs(kwargs)), layout, ind .- 1)
end

function update!(
    plt::SyncPlot, update::AbstractDict=Dict(); layout::Layout=Layout(),
    kwargs...
)
    update!(plt.plot, update; layout=layout, kwargs...)
    send_command(plt.scope, :update, merge(update, prep_kwargs(kwargs)), layout)
end

function addtraces!(plt::SyncPlot, traces::AbstractTrace...)
    addtraces!(plt.plot, traces...)
    send_command(plt.observables, :addTraces, traces)
end

function addtraces!(plt::SyncPlot, i::Int, traces::AbstractTrace...)
    addtraces!(plt.plot, i, traces...)
    send_command(plt.observables, :addTraces, traces, i - 1)
end

function deletetraces!(plt::SyncPlot, inds::Int...)
    deletetraces!(plt.plot, inds...)
    send_command(plt.observables, :deleteTraces, collect(inds) .- 1)
end

function movetraces!(plt::SyncPlot, to_end::Int...)
    movetraces!(plt.plot, to_end...)
    send_command(plt.observables, :moveTraces, traces, collect(to_end) .- 1)
end

function movetraces!(
    plt::SyncPlot, src::AbstractVector{Int}, dest::AbstractVector{Int}
)
    movetraces!(plt.plot, src, dest)
    send_command(plt.observables, :moveTraces, src .- 1, dest .- 1)
end

function redraw!(plt::SyncPlot)
    redraw!(plt.plot)
    send_command(plt.observables, :redraw)
end

function purge!(plt::SyncPlot)
    purge!(plt.plot)
    send_command(plt.observables, :purge)
end

function to_image(plt::SyncPlot; kwargs...)
    to_image(plt.plot)
    plt.observables["image"][] = ""  # reset
    plt.observables["_toImage"][] = Dict(kwargs)

    tries = 0
    while length(plt.observables["image"][]) == 0
        tries == 10 && error("Could not get image")
        sleep(0.25)
        tries += 1
    end
    return plt["image"].val
end

function download_image(plt::SyncPlot; kwargs...)
    download_image(plt.plot)
    plt.observables["_downloadImage"][] = Dict(kwargs)
    nothing
end

# unexported (by plotly.js) api methods
function extendtraces!(
    plt::SyncPlot, 
    update::AbstractDict,
    indices::AbstractVector{Int}=[1], 
    maxpoints=-1;
)
    extendtraces!(plt.plot, update, indices, maxpoints)
    send_command(
        plt.observables, :extendTraces, prep_kwargs(update), indices .- 1, maxpoints
    )
end

function prependtraces!(
    plt::SyncPlot, 
    update::AbstractDict,
    indices::AbstractVector{Int}=[1], 
    maxpoints=-1;
)
    prependtraces!(plt.plot, update, indices, maxpoints)
    send_command(
        plt.observables, :prependTraces, prep_kwargs(update), indices .- 1, maxpoints
    )
end


# TODO: Document what is going on here
for f in [:restyle, :relayout, :update, :addtraces, :deletetraces,
          :movetraces, :redraw, :extendtraces, :prependtraces, :purge, :react]
    f! = Symbol(f, "!")
    @eval function $(f)(plt::SyncPlot, args...; kwargs...)
        out = SyncPlot(deepcopy(plt.plot))
        $(f!)(out, args...; kwargs...)
        out
    end
end

# add extra same extra methods we have on ::Plot for these functions
for f in (:extendtraces!, :prependtraces!)
    @eval begin
        function $(f)(p::SyncPlot, inds::Vector{Int}=[0],
                      maxpoints=-1; update...)
            d = Dict()
            for (k, v) in update
                d[k] = _tovec(v)
            end
            ($f)(p, d, inds, maxpoints)
        end

        function $(f)(p::SyncPlot, ind::Int, maxpoints=-1;
                      update...)
            ($f)(p, [ind], maxpoints; update...)
        end

        function $(f)(p::SyncPlot, update::AbstractDict, ind::Int,
                      maxpoints=-1)
            ($f)(p, update, [ind], maxpoints)
        end
    end
end

for mime in ["text/plain", "application/vnd.plotly.v1+json", "application/prs.juno.plotpane+html"]
    function Base.show(io::IO, m::MIME{Symbol(mime)}, p::SyncPlot, args...)
        show(io, m, p.plot, args...)
    end
end


# Hook up base methods to SyncPlot methods ===============================================================
        PlotlyBase.savejson(sp::SyncPlot, fn::String) = PlotlyBase.savejson(sp.plot, fn)
# Add some basic Julia API methods on SyncPlot that just forward onto the Plot
Base.size(sp::SyncPlot) = size(sp.plot)
Base.copy(sp::SyncPlot) = SyncPlot(copy(sp.plot))

# TODO: Replace this with Electron?
Base.show(io::IO, mm::MIME"application/prs.juno.plotpane+html", p::SyncPlot) = show(io, mm, p.observables)

# TODO: Replace this with Electron/ElectronDisplay
Base.display(::PlotlyJSDisplay, p::SyncPlot) = display_blink(p::SyncPlot)

