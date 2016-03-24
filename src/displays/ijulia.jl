# ---------------------- #
# Jupyter notebook setup #
# ---------------------- #

type JupyterDisplay <: AbstractPlotlyDisplay
    divid::Base.Random.UUID
    displayed::Bool
end

typealias JupyterPlot SyncPlot{JupyterDisplay}

JupyterDisplay(p::Plot) = JupyterDisplay(p.divid, false)
JupyterPlot(p::Plot) = JupyterPlot(p, JupyterDisplay(p))

fork(jp::JupyterPlot) = JupyterPlot(fork(jp.plot))

const _jupyter_js_loaded = [false]
js_loaded(::JupyterDisplay) = _jupyter_js_loaded[1]
js_loaded(::Type{JupyterDisplay}) = _jupyter_js_loaded[1]

function html_body(p::JupyterPlot)
    """
    <div id="$(p.view.divid)" class="plotly-graph-div"></div>

    <script>
        window.PLOTLYENV=window.PLOTLYENV || {};
        window.PLOTLYENV.BASE_URL="https://plot.ly";
        require(['plotly'], function(Plotly) {
            $(script_content(p.plot))
        });
     </script>
    """
end

# if we're in IJulia call setupnotebook to load js and css
if isdefined(Main, :IJulia) && Main.IJulia.inited
    # borrowed from https://github.com/plotly/plotly.py/blob/2594076e29584ede2d09f2aa40a8a195b3f3fc66/plotly/offline/offline.py#L64-L71
    if !js_loaded(JupyterDisplay)
        display("text/html", """
            <script type='text/javascript'>
                define('plotly', function(require, exports, module) {
                    $(open(readall, _js_path, "r"))
                });
                require(['plotly'], function(Plotly) {
                    window.Plotly = Plotly;
                });
            </script>""")
        _jupyter_js_loaded[1] = true
        display("text/html", "<p>Plotly javascript loaded.</p>")
    end

    @eval import IJulia

    IJulia.display_dict(p::Plot) =
        Dict("text/plain" => sprint(writemime, "text/plain", p))

    function IJulia.display_dict(p::JupyterPlot)
        if p.view.displayed
            Dict()
        else
            p.view.displayed = true
            Dict("text/html" => html_body(p))
        end
    end
end

## API Methods for JupyterDisplay
function _img_data(p::JupyterPlot, format::ASCIIString)
    # _formats = ["png", "jpeg", "webp", "svg"]
    # if !(format in _formats)
    #     error("Unsupported format $format, must be one of $_formats")
    # end
    #
    # # make sure plot has been displayed
    # display(p)
    #
    # # TODO: figure out how to resolve the promise
    # display("text/html", """<script>
    #     ev = Plotly.Snapshot.toImage(this, {'format': '$format'})
    #     new Promise(resolve -> ev.once("success", resolve))
    # </script>""")
    error("Not implemented (yet). Use Electron frontend to save figures")
end

function svg_data(jp::JupyterPlot, format="png")
    # display("text/html", """<script>
    #     var thediv = document.getElementById('$(jp.view.divid)');
    #     foobar = Plotly.Snapshot.toSVG(thediv, '$format')
    # </script>""")
    error("Not implemented (yet). Use Electron frontend to save figures")
end


function call_plotlyjs(jd::JupyterDisplay, func::AbstractString, args...)
    arg_str = length(args) > 0 ? string(",", join(map(json, args), ", ")) :
                                 ""
    if jd.displayed  # only do this if the plot has been displayed
        display("text/html", """<script>
            var thediv = document.getElementById('$(jd.divid)');
            Plotly.$func(thediv $arg_str)
        </script>""")
    end
end

# Methods from javascript API
relayout!(jd::JupyterDisplay, update::Associative=Dict(); kwargs...) =
    call_plotlyjs(jd, "relayout", merge(update, prep_kwargs(kwargs)))

restyle!(jd::JupyterDisplay, ind::Int, update::Associative=Dict(); kwargs...) =
    call_plotlyjs(jd, "restyle", merge(update, prep_kwargs(kwargs)), ind-1)

function restyle!(jd::JupyterDisplay, inds::AbstractVector{Int},
                  update::Associative=Dict();  kwargs...)
    call_plotlyjs(jd, "restyle", merge(update, prep_kwargs(kwargs)), inds-1)
end

restyle!(jd::JupyterDisplay, update::Associative=Dict(); kwargs...) =
    call_plotlyjs(jd, "restyle", merge(update, prep_kwargs(kwargs)))

addtraces!(jd::JupyterDisplay, traces::AbstractTrace...) =
    call_plotlyjs(jd, "addTraces", traces)

addtraces!(jd::JupyterDisplay, where::Int, traces::AbstractTrace...) =
    call_plotlyjs(jd, "addTraces", traces, where-1)

deletetraces!(jd::JupyterDisplay, traces::Int...) =
    call_plotlyjs(jd, "deleteTraces", collect(traces)-1)

movetraces!(jd::JupyterDisplay, to_end::Int...) =
    call_plotlyjs(jd, "moveTraces", collect(to_end)-1)

movetraces!(jd::JupyterDisplay, src::AbstractVector{Int}, dest::AbstractVector{Int}) =
    call_plotlyjs(jd, "moveTraces", src-1, dest-1)

redraw!(jd::JupyterDisplay) = call_plotlyjs(jd, "redraw")

# unexported (by plotly.js) api methods
extendtraces!(jd::JupyterDisplay, update::Associative=Dict(),
              indices::Vector{Int}=[1], maxpoints=-1;) =
    call_plotlyjs(jd, "extendTraces", update, indices-1, maxpoints)

prependtraces!(jd::JupyterDisplay, update::Associative=Dict(),
               indices::Vector{Int}=[1], maxpoints=-1;) =
    call_plotlyjs(jd, "prependTraces", update, indices-1, maxpoints)
