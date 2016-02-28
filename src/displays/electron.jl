# ----------- #
# Blink setup #
# ----------- #

type ElectronDisplay <: AbstractPlotlyDisplay
    w::Nullable{Window}
    js_loaded::Bool
end

typealias ElectronPlot SyncPlot{ElectronDisplay}

ElectronDisplay() = ElectronDisplay(Nullable{Window}(), false)

fork(jp::ElectronPlot) = ElectronPlot(fork(jp.plot), ElectronDisplay())

isactive(ed::ElectronDisplay) = isnull(ed.w) ? false : Blink.active(get(ed.w))

function get_window(p::ElectronPlot, kwargs...)
    w, h = size(p.plot)
    get_window(p.view; width=w, height=h, kwargs...)
end

function get_window(ed::ElectronDisplay; kwargs...)
    if !isnull(ed.w) && active(get(ed.w))
        w = get(ed.w)
    else
        w = Window(Blink.AtomShell.shell(), Dict(kwargs))
        ed.w = Nullable{Window}(w)
        ed.js_loaded = false  # can't have js if we made a new window
    end
    w
end

js_loaded(ed::ElectronDisplay) = ed.js_loaded
function loadjs(ed::ElectronDisplay)
    if !ed.js_loaded
        Blink.load!(get_window(ed), _js_path)
        ed.js_loaded = true
    end
end

function Base.display(p::ElectronPlot)
    w = get_window(p)
    loadjs(p.view)
    @js w begin
        trydiv = document.getElementById($(string(p.plot.divid)))
        if trydiv == nothing
            thediv = document.createElement("div")
            thediv.id = $(string(p.plot.divid))
            document.body.appendChild(thediv)
        else
            thediv = trydiv
        end
        @var _ = Plotly.newPlot(thediv, $(p.plot.data),
                                $(p.plot.layout),
                                d("showLink"=> false))
        _.then(()->Promise.resolve())
    end
    p.plot
end

## API Methods for ElectronDisplay
getdiv(p::ElectronDisplay) = :(document.getElementById($(string(p.plot.divid))))

Blink.js(p::ElectronDisplay, code::JSString; callback=true) =
    Blink.js(get_window(p), :(Blink.evalwith(thediv, $(Blink.jsstring(code)))), callback=callback)

relayout!(p::ElectronDisplay, update::Associative=Dict(); kwargs...) =
    @js_ p Plotly.relayout(this, $(merge(update, prep_kwargs(kwargs))))

restyle!(p::ElectronDisplay, ind::Int, update::Associative=Dict(); kwargs...) =
    @js_ p Plotly.restyle(this, $(prep_kwargs(kwargs)), $(ind-1))

restyle!(p::ElectronDisplay, inds::AbstractVector{Int}, update::Associative=Dict(); kwargs...) =
    @js_ p Plotly.restyle(this, $(prep_kwargs(kwargs)), $(inds-1))

restyle!(p::ElectronDisplay, update=Dict(); kwargs...) =
    @js_ p Plotly.restyle(this, $(merge(update, prep_kwargs(kwargs))))

addtraces!(p::ElectronDisplay, traces::AbstractTrace...) =
    @js_ p Plotly.addTraces(this, $traces)

addtraces!(p::ElectronDisplay, where::Int, traces::AbstractTrace...) =
    @js_ p Plotly.addTraces(this, $traces, $(where-1))

deletetraces!(p::ElectronDisplay, traces::Int...) =
    @js_ p Plotly.deleteTraces(this, $(collect(traces)-1))

movetraces!(p::ElectronDisplay, to_end::Int...) =
    @js_ p Plotly.moveTraces(this, $(collect(to_end)-1))

movetraces!(p::ElectronDisplay, src::AbstractVector{Int}, dest::AbstractVector{Int}) =
    @js_ p Plotly.moveTraces(this, $(src-1), $(dest-1))

redraw!(p::ElectronDisplay) =
    @js_ p Plotly.redraw(this)

# unexported (by plotly.js) api methods
extendtraces!(ed::ElectronDisplay, update::Associative=Dict(),
              indices::Vector{Int}=[1], maxpoints=-1;) =
    @js_ p Plotly.extendTraces(this, $update, $(indices-1), $maxpoints)

prependtraces!(ed::ElectronDisplay, update::Associative=Dict(),
               indices::Vector{Int}=[1], maxpoints=-1;) =
    @js_ p Plotly.prependTraces(this, $update, $(indices-1), $maxpoints)
