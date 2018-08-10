# ----------- #
# Blink setup #
# ----------- #

mutable struct ElectronDisplay <: AbstractPlotlyDisplay
    divid::Base.Random.UUID
    w
end

const ElectronPlot = SyncPlot{ElectronDisplay}

ElectronDisplay() = ElectronDisplay(Base.Random.uuid4(), nothing)
ElectronDisplay(divid::Base.Random.UUID) = ElectronDisplay(divid, nothing)
ElectronDisplay(p::Plot) = ElectronDisplay(p.divid)
ElectronPlot(p::Plot) = ElectronPlot(p, ElectronDisplay(p.divid))

PlotlyBase.fork(jp::ElectronPlot) = ElectronPlot(fork(jp.plot), ElectronDisplay())

# define some core methods on the display

"""
Return true if the display has been initialized and is still open, else false
"""
isactive(ed::ElectronDisplay) = ed.w === nothing ? false : Blink.active(get(ed.w))

"""
If the display is active, close the window
"""
Base.close(ed::ElectronDisplay) = isactive(ed) && close(get(ed.w))


"Variable we can query to see if the plot has finished rendering"
function done_var(ed::ElectronDisplay)
    Symbol("done_$(split(string(ed.divid), "-")[1])")
end

"variable to store the svg data in"
function svg_var(ed::ElectronDisplay)
    Symbol("svg_$(split(string(ed.divid), "-")[1])")
end

"""
Return true if the display is active and the plot has finished rendering, else
false
"""
function Base.isready(ed::ElectronDisplay)
    !isactive(ed) && return false
    Blink.js(ed, done_var(ed))
end

# helper method to obtain a Blink window, given some options
get_window(opts::Dict) = Window(opts)

"""
Initialize a Blink window for displaying the a plot. This will return an
existing window if it has been initialized and is still active, otherwise it
creates one.

Part of the creation process here is loading the plotly javascript.
"""
function get_window(ed::ElectronDisplay; kwargs...)
    if ed.w !== nothing && active(get(ed.w))
        w = get(ed.w)
    else
        w = get_window(Dict(kwargs))
        isa(w, Blink.Window) && wait(w.content)  # wait for window to be ready to accept messages
        ed.w = w
        # load the js here
        Blink.loadjs!(w, "/pkg/PlotlyJS/plotly-latest.min.js")
        Blink.loadjs!(w, _mathjax_cdn_path)
        Blink.js(w, :($(done_var(ed)) = false))
        Blink.js(w, :($(svg_var(ed)) = undefined))

        # make sure plotly has been loaded
        done = false
        while !done
            try
                @js w Plotly
                done = true
            catch e
                continue
            end
        end
    end
    w
end

# the corresponding methods for ElectronPlot can (for the most part)
# just forward on to the view
Base.isready(p::ElectronPlot) = isready(p.view)

done_var(p::ElectronPlot) = done_var(p.view)
svg_var(p::ElectronPlot) = svg_var(p.view)

"""
Close the plot window (if active) and reset the fields and reset the `w` field
on the display to be `nothing`.
"""
function Base.close(p::ElectronPlot)
    close(p.view)
    p.view.w = nothing
    nothing
end

"""
Use the plot width and height to open a window of the correct size
"""
function get_window(p::ElectronPlot; kwargs...)
    w, h = size(p.plot)
    get_window(p.view; width=w, height=h, kwargs...)
end

Base.display(p::ElectronPlot; show = true, resize::Bool=_autoresize[1]) =
  display_blink(p; show = show, resize = resize)

function display_blink(p::ElectronPlot; show=true, resize::Bool=_autoresize[1],)
    w = get_window(p, show=show)

    done = done_var(p)
    svg = svg_var(p)

    save_svg_func = """
    function reset_svg() {
        $(svg) = undefined;
        $(done) = false;
    }
    function save_svg(gd){
         $(done) = true;
         Plotly.toImage(gd, {"format": "svg"}).then(function(img_data) {
             var svg_data = img_data.replace(/^data:image\\/svg\\+xml,/, "");
             $(svg) = decodeURIComponent(svg_data);
          });
    };
    """

    if !resize
        code = """
        <script>
        $(save_svg_func)
        gd = (function(){
            var gd = Plotly.d3.select("body")
                .append("div")
                .attr("id", "$(p.plot.divid)")
                .node();
            var plot_json = $(json(p.plot));
            var data = plot_json.data;
            var layout = plot_json.layout;
            Plotly.newPlot(gd, data, layout).then(save_svg);
            return gd;
        })();
        </script>
        """
        @js(w, Blink.fill("body", $code))
    else
        #= this is the same as above, with a few differences:

        - when we create the div, set some style attributes so the div itself
        grows with the display window
        - After obtaining the image data, we delete the width and height
        properties on the layout so that if the user happened to have set them
        on the Julia side, they will be removed -- allowing the plot to always
        fill the div
        =#
        magic = """
        <script>
        $(save_svg_func)
        gd = (function() {
            var WIDTH_IN_PERCENT_OF_PARENT = 100
            var HEIGHT_IN_PERCENT_OF_PARENT = 100;
            var gd = Plotly.d3.select('body')
                .append('div').attr("id", "$(p.plot.divid)")
                .style({
                    width: WIDTH_IN_PERCENT_OF_PARENT + '%',
                    'margin-left': (100 - WIDTH_IN_PERCENT_OF_PARENT) / 2 + '%',
                    height: HEIGHT_IN_PERCENT_OF_PARENT + 'vh',
                    'margin-top': (100 - HEIGHT_IN_PERCENT_OF_PARENT) / 2 + 'vh'
                })
                .node();
            var plot_json = $(json(p.plot));
            var data = plot_json.data;
            var layout = plot_json.layout;
            Plotly.newPlot(gd, data, layout).then(save_svg);
            window.onresize = function() {
                Plotly.Plots.resize(gd);
                };
            return gd;
        })();
        </script>
        """
        @js(w, Blink.fill("body", $magic))
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

function svg_data(p::ElectronPlot, format="png", robust=false)
    opened_here = !isactive(p.view)
    opened_here && (display(p; show=false, resize=false); sleep(0.1))

    out = nothing
    while out === nothing
        out = @js p $(svg_var(p))
        # wait for plot to render
        sleep(0.2)
    end

    opened_here && close(p)

    return out
end

function Blink.js(p::ElectronDisplay, code::JSString; callback=true)
    if !isactive(p)
        return
    end

    Blink.js(get_window(p),
             :(Blink.evalwith(document.getElementById($(string(p.divid))),
                              $(Blink.jsstring(code)))),
             callback=callback)
end

Blink.js(p::ElectronPlot, code::JSString; callback=true) =
    Blink.js(p.view, code; callback=callback)

# Methods from javascript API (docstrings found in api.jl)
function relayout!(p::ElectronDisplay, update::AbstractDict=Dict(); kwargs...)
    @js_ p begin reset_svg(); Plotly.relayout(this, $(merge(update, prep_kwargs(kwargs)))).then(save_svg) end
end

function restyle!(p::ElectronDisplay, ind::Int, update::AbstractDict=Dict(); kwargs...)
    @js_ p begin reset_svg(); Plotly.restyle(this, $(merge(update, prep_kwargs(kwargs))), $(ind-1)).then(save_svg) end
end

function restyle!(p::ElectronDisplay, inds::AbstractVector{Int}, update::AbstractDict=Dict(); kwargs...)
    @js_ p begin reset_svg(); Plotly.restyle(this, $(merge(update, prep_kwargs(kwargs))), $(inds-1)).then(save_svg) end
end

function restyle!(p::ElectronDisplay, update=Dict(); kwargs...)
    @js_ p begin reset_svg(); Plotly.restyle(this, $(merge(update, prep_kwargs(kwargs)))).then(save_svg) end
end

function update!(p::ElectronDisplay, ind::Int, update::AbstractDict=Dict(); layout::Layout=Layout(), kwargs...)
    @js_ p begin reset_svg(); Plotly.update(this, $(merge(update, prep_kwargs(kwargs))), $(layout), $(ind-1)).then(save_svg) end
end

function update!(p::ElectronDisplay, inds::AbstractVector{Int}, update::AbstractDict=Dict(); layout::Layout=Layout(), kwargs...)
    @js_ p begin reset_svg(); Plotly.update(this, $(merge(update, prep_kwargs(kwargs))), $(layout), $(inds-1)).then(save_svg) end
end

function update!(p::ElectronDisplay, update=Dict(); layout::Layout=Layout(), kwargs...)
    @js_ p begin reset_svg(); Plotly.update(this, $(merge(update, prep_kwargs(kwargs))), $(layout)).then(save_svg) end
end

function addtraces!(p::ElectronDisplay, traces::AbstractTrace...)
    @js_ p begin reset_svg(); Plotly.addTraces(this, $traces).then(save_svg) end
end

function addtraces!(p::ElectronDisplay, where::Int, traces::AbstractTrace...)
    @js_ p begin reset_svg(); Plotly.addTraces(this, $traces, $(where-1)).then(save_svg) end
end

function deletetraces!(p::ElectronDisplay, traces::Int...)
    @js_ p begin reset_svg(); Plotly.deleteTraces(this, $(collect(traces)-1)).then(save_svg) end
end

function movetraces!(p::ElectronDisplay, to_end::Int...)
    @js_ p begin reset_svg(); Plotly.moveTraces(this, $(collect(to_end)-1)).then(save_svg) end
end

function movetraces!(p::ElectronDisplay, src::AbstractVector{Int}, dest::AbstractVector{Int})
    @js_ p begin reset_svg(); Plotly.moveTraces(this, $(src-1), $(dest-1)).then(save_svg) end
end

function redraw!(p::ElectronDisplay)
    @js_ p begin reset_svg(); Plotly.redraw(this).then(save_svg) end
end

function purge!(p::ElectronDisplay)
    @js_ p begin reset_svg(); Plotly.purge(this) end
end

function to_image(p::ElectronDisplay; kwargs...)
    @js p Plotly.toImage(this, $(Dict(kwargs)))
end

function download_image(p::ElectronDisplay; kwargs...)
    @js p Plotly.downloadImage(this, $(Dict(kwargs)))
end

# unexported (by plotly.js) api methods
function extendtraces!(ed::ElectronDisplay, update::AbstractDict=Dict(),
              indices::Vector{Int}=[1], maxpoints=-1;)
    @js_ ed begin reset_svg(); Plotly.extendTraces(this, $(prep_kwargs(update)), $(indices-1), $maxpoints).then(save_svg) end
end

function prependtraces!(ed::ElectronDisplay, update::AbstractDict=Dict(),
               indices::Vector{Int}=[1], maxpoints=-1;)
    @js_ ed begin reset_svg(); Plotly.prependTraces(this, $(prep_kwargs(update)), $(indices-1), $maxpoints).then(save_svg) end
end
