# ----------- #
# Blink setup #
# ----------- #

type ElectronDisplay <: AbstractPlotlyDisplay
    w::Nullable{Window}
    js_loaded::Bool
end

typealias ElectronPlot SyncPlot{ElectronDisplay}

ElectronDisplay() = ElectronDisplay(Nullable{Window}(), false)
ElectronPlot(p::Plot) = ElectronPlot(p, ElectronDisplay())

fork(jp::ElectronPlot) = ElectronPlot(fork(jp.plot), ElectronDisplay())

isactive(ed::ElectronDisplay) = isnull(ed.w) ? false : Blink.active(get(ed.w))

Base.close(ed::ElectronDisplay) = isactive(ed) && close(get(ed.w))

function get_window(p::ElectronPlot; kwargs...)
    w, h = size(p.plot)
    get_window(p.view; width=w, height=h, kwargs...)
end

function get_window(ed::ElectronDisplay; kwargs...)
    if !isnull(ed.w) && active(get(ed.w))
        w = get(ed.w)
    else
        w = Window(Blink.AtomShell.shell(), Dict{Any,Any}(kwargs))
        ed.w = Nullable{Window}(w)
        ed.js_loaded = false  # can't have js if we made a new window
    end
    w
end

js_loaded(ed::ElectronDisplay) = ed.js_loaded

function loadjs(ed::ElectronDisplay)
    if !ed.js_loaded
        Blink.loadjs!(get_window(ed), _mathjax_cdn_path)
        Blink.load!(get_window(ed), _js_path)
        ed.js_loaded = true
    end
end

function Base.display(p::ElectronPlot; show=true, resize::Bool=_autoresize[1])
    w = get_window(p, show=show)
    loadjs(p.view)
    if !resize
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
    else
        magic = """
        <script>
        (function() {
        var d3 = Plotly.d3
        var WIDTH_IN_PERCENT_OF_PARENT = 100,
        HEIGHT_IN_PERCENT_OF_PARENT = 100;
        var gd3 = d3.select('body')
        .append('div').attr("id", "$(p.plot.divid)")
        .style({
        width: WIDTH_IN_PERCENT_OF_PARENT + '%',
        'margin-left': (100 - WIDTH_IN_PERCENT_OF_PARENT) / 2 + '%',
        height: HEIGHT_IN_PERCENT_OF_PARENT + 'vh',
        'margin-top': (100 - HEIGHT_IN_PERCENT_OF_PARENT) / 2 + 'vh'
        });
        var gd = gd3.node();
        var data = $(json(p.plot.data))
        var layouts = $(json(p.plot.layout))
        Plotly.newPlot(gd, data, layouts);
        window.onresize = function() {
        Plotly.Plots.resize(gd);
        };
        })();
        thediv = document.getElementById('$(string(p.plot.divid))')
        </script>
        """
        Blink.body!(w, magic)
    end
    p.plot
end

## API Methods for ElectronDisplay
function _img_data(p::ElectronPlot, format::String; show::Bool=false)
    _formats = ["png", "jpeg", "webp", "svg"]
    if !(format in _formats)
        error("Unsupported format $format, must be one of $_formats")
    end

    opened_here = !isactive(p.view)
    opened_here && display(p; show=show, resize=false)

    out = @js p.view begin
        ev = Plotly.Snapshot.toImage(this, d("format"=>$format))
        @new Promise(resolve -> ev.once("success", resolve))
    end
    opened_here && close(p)
    out
end

function svg_data(p::ElectronPlot, format="png")
    opened_here = !isactive(p.view)
    opened_here && display(p; show=false, resize=false)

    out = @js p.view Plotly.Snapshot.toSVG(this, $format)

    opened_here && close(p)

    return out
end

Base.close(p::ElectronPlot) = close(p.view)

function Blink.js(p::ElectronDisplay, code::JSString; callback=true)
    if !isactive(p)
        return
    end
    Blink.js(get_window(p),
             :(Blink.evalwith(thediv, $(Blink.jsstring(code)))), callback=callback)
end

Blink.js(p::ElectronPlot, code::JSString; callback=true) =
    Blink.js(p.view, code; callback=callback)

# Methods from javascript API (docstrings found in api.jl)
relayout!(p::ElectronDisplay, update::Associative=Dict(); kwargs...) =
    @js_ p Plotly.relayout(this, $(merge(update, prep_kwargs(kwargs))))

restyle!(p::ElectronDisplay, ind::Int, update::Associative=Dict(); kwargs...) =
    @js_ p Plotly.restyle(this, $(merge(update, prep_kwargs(kwargs))), $(ind-1))

restyle!(p::ElectronDisplay, inds::AbstractVector{Int}, update::Associative=Dict(); kwargs...) =
    @js_ p Plotly.restyle(this, $(merge(update, prep_kwargs(kwargs))), $(inds-1))

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
    @js_ ed Plotly.extendTraces(this, $(prep_kwargs(update)), $(indices-1), $maxpoints)

prependtraces!(ed::ElectronDisplay, update::Associative=Dict(),
               indices::Vector{Int}=[1], maxpoints=-1;) =
    @js_ ed Plotly.prependTraces(this, $(prep_kwargs(update)), $(indices-1), $maxpoints)
