# ----------------------------------------- #
# SyncPlot -- sync Plot object with display #
# ----------------------------------------- #
mutable struct SyncPlot
    plot::PlotlyBase.Plot
    scope::Scope
    window::Union{Nothing,Blink.Window}
end

Base.getindex(p::SyncPlot, key) = p.scope[key] # look up Observables

@WebIO.register_renderable(SyncPlot) do plot
    return WebIO.render(plot.scope)
end

function Base.show(io::IO, mm::MIME"text/html", p::SyncPlot)
    # if we are rendering docs -- short circuit and display html
    if get_renderer() == DOCS
        return show(io, mm, p.plot, full_html=false, include_plotlyjs="require-loaded", include_mathjax=missing)
    end
    show(io, mm, p.scope)
end
Base.show(io::IO, mm::MIME"juliavscode/html", p::SyncPlot) = show(io, mm, p.scope)

# using @eval instead of Union{} to avoid ambiguity with other methods
for mime in [MIME"text/plain", MIME"application/vnd.plotly.v1+json", MIME"juliavscode/html"]
    @eval Base.show(io::IO, mm::$mime, p::SyncPlot, args...; kwargs...) = show(io, mm, p.plot, args...; kwargs...)
end

function SyncPlot(
        p::Plot;
        kwargs...
    )
    lowered = JSON.lower(p)
    id = string("#plot-", p.divid)

    # setup scope
    deps = [
        "Plotly" => _js_path,
        joinpath(@__DIR__, "..", "assets", "plotly_webio.bundle.js")
    ]
    scope = Scope(imports=deps)
    scope.dom = dom"div"(id=string("plot-", p.divid))

    # INPUT: Observables for plot events
    scope["hover"] = Observable(Dict())
    scope["selected"] = Observable(Dict())
    scope["click"] = Observable(Dict())
    scope["relayout"] = Observable(Dict())
    scope["image"] = Observable("")
    scope["__gd_contents"] = Observable{Any}(Dict())  # for testing

    # OUTPUT: setup an observable which sends modify commands
    scope["_commands"] = Observable{Any}([])
    scope["_toImage"] = Observable(Dict())
    scope["_downloadImage"] = Observable(Dict())
    scope["__get_gd_contents"] = Observable("")

    onjs(scope["_toImage"], @js function (options)
        this.Plotly.toImage(this.plotElem, options).then(function (data)
            $(scope["image"])[] = data
        end)
    end)

    onjs(scope["__get_gd_contents"], @js function (prop)
        if prop == "data"
            $(scope["__gd_contents"])[] = this.plotElem.data
        end

        if prop == "layout"
            $(scope["__gd_contents"])[] = this.plotElem.layout
        end
    end)

    onjs(scope["_downloadImage"], @js function (options)
        this.Plotly.downloadImage(this.plotElem, options)
    end)

    # Do the respective action when _commands is triggered
    onjs(scope["_commands"], @js function (args)
        @var fn = args.shift()
        @var elem = this.plotElem
        @var Plotly = this.Plotly
        args.unshift(elem) # use div as first argument
        Plotly[fn].apply(this, args)
    end)

    onimport(scope, JSExpr.@js function (Plotly, PlotlyWebIO)
        # Add the PlotlyCommands object to the WebIO JS instance
        PlotlyWebIO.init(WebIO)

        # set up container element
        @var gd = this.dom.querySelector($id);

        # save some vars for later
        this.plotElem = gd
        this.Plotly = Plotly
        if (window.Blink !== undefined)
            # set css style for auto-resize
            gd.style.width = "100%";
            gd.style.height = "100vh";
            gd.style.marginLeft = "0%";
            gd.style.marginTop = "0vh";
        end

        window.onresize = () -> Plotly.Plots.resize(gd)

        # Draw plot in container
        Plotly.newPlot(
            gd,
            $(lowered[:data]),
            $(lowered[:layout]),
            $(lowered[:config]),
        )

        # hook into plotly events
        gd.on("plotly_hover", function (data)
            @var filtered_data = WebIO.PlotlyCommands.filterEventData(gd, data, "hover");
            if !(filtered_data.isnil)
                $(scope["hover"])[] = filtered_data.out
            end
        end)

        gd.on("plotly_unhover", () -> $(scope["hover"])[] = Dict())

        gd.on("plotly_selected", function (data)
            @var filtered_data = WebIO.PlotlyCommands.filterEventData(gd, data, "selected");
            if !(filtered_data.isnil)
                $(scope["selected"])[] = filtered_data.out
            end
        end)

        gd.on("plotly_deselect", () -> $(scope["selected"])[] = Dict())

        gd.on("plotly_relayout", function (data)
            @var filtered_data = WebIO.PlotlyCommands.filterEventData(gd, data, "relayout");
            if !(filtered_data.isnil)
                $(scope["relayout"])[] = filtered_data.out
            end
        end)

        gd.on("plotly_click", function (data)
            @var filtered_data = WebIO.PlotlyCommands.filterEventData(gd, data, "click");
            if !(filtered_data.isnil)
                $(scope["click"])[] = filtered_data.out
            end
        end)
    end)

    # create no-op `on` callback for image so it is _always_ sent
    # to us
    on(scope["image"]) do x end

    SyncPlot(p, scope, nothing)
end

plot(args...; kwargs...) = SyncPlot(Plot(args...; kwargs...))

# Add some basic Julia API methods on SyncPlot that just forward onto the Plot
Base.size(sp::SyncPlot) = size(sp.plot)
Base.copy(sp::SyncPlot) = SyncPlot(copy(sp.plot))

Base.display(::PlotlyJSDisplay, p::SyncPlot) = display_blink(p::SyncPlot)

function display_blink(p::SyncPlot)
    sizeBuffer = 1.15
    plotSize = size(p.plot)
    windowOptions = Dict(
        "width" => floor(Int, plotSize[1] * sizeBuffer),
        "height" => floor(Int, plotSize[2] * sizeBuffer)
    )
    p.window = Blink.Window(windowOptions)
    Blink.body!(p.window, p.scope)
end

function Base.close(p::SyncPlot)
    if p.window !== nothing && Blink.active(p.window)
        close(p.window)
    end
end

function send_command(scope, cmd, args...)
    # The handler for _commands is set up when plot is constructed
    scope["_commands"][] = [cmd, args...]
    nothing
end

function add_trace!(p::SyncPlot, trace::GenericTrace; kw...)
    add_trace!(p.plot, trace; kw...)
    send_command(p.scope, :react, p.plot.data, p.plot.layout)
end


# ----------------------- #
# Plotly.js api functions #
# ----------------------- #

# for each of these we first update the Julia object, then update the display

function restyle!(
        plt::SyncPlot, ind::Union{Int,AbstractVector{Int}},
        update::AbstractDict=Dict();
        kwargs...
    )
    restyle!(plt.plot, ind, update; kwargs...)
    send_command(plt.scope, :restyle, merge(update, prep_kwargs(kwargs)), ind .- 1)
end

function restyle!(plt::SyncPlot, update::AbstractDict=Dict(); kwargs...)
    restyle!(plt.plot, update; kwargs...)
    send_command(plt.scope, :restyle, merge(update, prep_kwargs(kwargs)))
end

function relayout!(plt::SyncPlot, update::AbstractDict=Dict(); kwargs...)
    relayout!(plt.plot, update; kwargs...)
    update!(plt, layout=plt.plot.layout)
end

function react!(plt::SyncPlot, data::AbstractVector{<:AbstractTrace}, layout::Layout)
    react!(plt.plot, data, layout)
    send_command(plt.scope, :react, data, layout)
end

function update!(
        plt::SyncPlot, ind::Union{Int,AbstractVector{Int}},
        update::AbstractDict=Dict();
        layout::Layout=Layout(),
        kwargs...)
    update!(plt.plot, ind, update; layout=layout, kwargs...)
    send_command(plt.scope, :update, merge(update, prep_kwargs(kwargs)), layout, ind .- 1)
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
    send_command(plt.scope, :addTraces, traces)
end

function addtraces!(plt::SyncPlot, i::Int, traces::AbstractTrace...)
    addtraces!(plt.plot, i, traces...)
    send_command(plt.scope, :addTraces, traces, i - 1)
end

function deletetraces!(plt::SyncPlot, inds::Int...)
    deletetraces!(plt.plot, inds...)
    send_command(plt.scope, :deleteTraces, collect(inds) .- 1)
end

function movetraces!(plt::SyncPlot, to_end::Int...)
    movetraces!(plt.plot, to_end...)
    send_command(plt.scope, :moveTraces, traces, collect(to_end) .- 1)
end

function movetraces!(
        plt::SyncPlot, src::AbstractVector{Int}, dest::AbstractVector{Int}
    )
    movetraces!(plt.plot, src, dest)
    send_command(plt.scope, :moveTraces, src .- 1, dest .- 1)
end

function redraw!(plt::SyncPlot)
    redraw!(plt.plot)
    send_command(plt.scope, :redraw)
end

function purge!(plt::SyncPlot)
    purge!(plt.plot)
    send_command(plt.scope, :purge)
end

function to_image(plt::SyncPlot; kwargs...)
    to_image(plt.plot)
    plt.scope["image"][] = ""  # reset
    plt.scope["_toImage"][] = Dict(kwargs)

    tries = 0
    while length(plt.scope["image"][]) == 0
        tries == 10 && error("Could not get image")
        sleep(0.25)
        tries += 1
    end
    return plt["image"].val
end

function download_image(plt::SyncPlot; kwargs...)
    download_image(plt.plot)
    plt.scope["_downloadImage"][] = Dict(kwargs)
    nothing
end

# unexported (by plotly.js) api methods
function extendtraces!(plt::SyncPlot, update::AbstractDict,
              indices::AbstractVector{Int}=[1], maxpoints=-1;)
    extendtraces!(plt.plot, update, indices, maxpoints)
    send_command(
        plt.scope, :extendTraces, prep_kwargs(update), indices .- 1, maxpoints
    )
end

function prependtraces!(plt::SyncPlot, update::AbstractDict,
               indices::AbstractVector{Int}=[1], maxpoints=-1;)
    prependtraces!(plt.plot, update, indices, maxpoints)
    send_command(
        plt.scope, :prependTraces, prep_kwargs(update), indices .- 1, maxpoints
    )
end

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

PlotlyBase.savejson(sp::SyncPlot, fn::String) = PlotlyBase.savejson(sp.plot, fn)
