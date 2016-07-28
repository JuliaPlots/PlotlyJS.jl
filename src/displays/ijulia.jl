# ---------------------- #
# Jupyter notebook setup #
# ---------------------- #

type JupyterDisplay <: AbstractPlotlyDisplay
    divid::Base.Random.UUID
    displayed::Bool
    cond::Condition  # for getting data back from js
end

typealias JupyterPlot SyncPlot{JupyterDisplay}

JupyterDisplay(p::Plot) = JupyterDisplay(p.divid, false, Condition())
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

_isijulia() = isdefined(Main, :IJulia) && Main.IJulia.inited

function init_notebook(force=false)
    # TODO: figure out a way to ask the notebook if the js is currently loaded
    #       and active.


    # if we're in IJulia call setup the notebook js interop
    if _isijulia()
        # borrowed from https://github.com/plotly/plotly.py/blob/2594076e29584ede2d09f2aa40a8a195b3f3fc66/plotly/offline/offline.py#L64-L71
        # and https://github.com/JuliaLang/Interact.jl/blob/cc5f4cfd34687000bc6bc70f0513eaded1a7c950/src/IJulia/setup.jl#L15
        if !js_loaded(JupyterDisplay) || force
            _ijulia_js = readall(joinpath(dirname(@__FILE__), "ijulia.js"))

            # three script tags for loading ijulia setup, mathjax, and plotly
            display("text/html", """
            <script charset="utf-8" type='text/javascript'>
                $(_ijulia_js)
            </script>

             <script charset="utf-8" type='text/javascript'>
                 define('plotly', function(require, exports, module) {
                     $(open(readall, _js_path, "r"))
                 });
                 require(['plotly'], function(Plotly) {
                     window.Plotly = Plotly;
                 });
             </script>
             <p>Plotly javascript loaded.</p>
             <p>To load again call <pre>init_notebook(true)</pre></p>
             """)
            _jupyter_js_loaded[1] = true
        end
    end
end

# --------------------------------------------- #
# Code to run once when the notebook starts up! #
# --------------------------------------------- #

if _isijulia()

    init_notebook()

    @eval begin
        import IJulia
        import IJulia.CommManager: Comm, send_comm
    end

    # set up the comms we will use to send js messages to be executed
    const _ijulia_eval_comm = Comm(:plotlyjs_eval)
    const _ijulia_return_comms = Dict{Base.Random.UUID,Comm}()

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

# ---------------- #
# Helper functions #
# ---------------- #

_call_js(jd::JupyterDisplay, code) =
    send_comm(_ijulia_eval_comm, Dict("code" => code))

## API Methods for JupyterDisplay
_the_div_js(jd::JupyterDisplay) = "document.getElementById('$(jd.divid)')"
_the_div_js(jp::JupyterPlot) = _the_div_js(jp.view)

# function _img_data(jp::JupyterPlot, format::String)
#     _formats = ["png", "jpeg", "webp", "svg"]
#     if !(format in _formats)
#         error("Unsupported format $format, must be one of $_formats")
#     end
#
#     if format == "svg"
#         return svg_data(jp)
#     end
#
#     code =  """
#     ev = Plotly.Snapshot.toImage($(_the_div_js(jp)), {format: '$(format)'});
#     new Promise(function(resolve) {ev.once("success", resolve)});
#     """
#     _call_js_return(jp.view, code)
# end
#
# function svg_data(jp::JupyterPlot, format="png")
#     code =  "Plotly.Snapshot.toSVG($(_the_div_js(jp)), '$(format)')"
#     _call_js_return(jp.view, code)
# end

function _call_plotlyjs(jd::JupyterDisplay, func::AbstractString, args...)
    arg_str = length(args) > 0 ? string(",", join(map(json, args), ", ")) : ""
    code = "Plotly.$func($(_the_div_js(jd)) $arg_str)"
    jd.displayed && _call_js(jd, code)
    nothing
end

# ---------------------- #
# Javascript API methods #
# ---------------------- #

relayout!(jd::JupyterDisplay, update::Associative=Dict(); kwargs...) =
    _call_plotlyjs(jd, "relayout", merge(update, prep_kwargs(kwargs)))

restyle!(jd::JupyterDisplay, ind::Int, update::Associative=Dict(); kwargs...) =
    _call_plotlyjs(jd, "restyle", merge(update, prep_kwargs(kwargs)), ind-1)

function restyle!(jd::JupyterDisplay, inds::AbstractVector{Int},
                  update::Associative=Dict();  kwargs...)
    _call_plotlyjs(jd, "restyle", merge(update, prep_kwargs(kwargs)), inds-1)
end

restyle!(jd::JupyterDisplay, update::Associative=Dict(); kwargs...) =
    _call_plotlyjs(jd, "restyle", merge(update, prep_kwargs(kwargs)))

addtraces!(jd::JupyterDisplay, traces::AbstractTrace...) =
    _call_plotlyjs(jd, "addTraces", traces)

addtraces!(jd::JupyterDisplay, where::Int, traces::AbstractTrace...) =
    _call_plotlyjs(jd, "addTraces", traces, where-1)

deletetraces!(jd::JupyterDisplay, traces::Int...) =
    _call_plotlyjs(jd, "deleteTraces", collect(traces)-1)

movetraces!(jd::JupyterDisplay, to_end::Int...) =
    _call_plotlyjs(jd, "moveTraces", collect(to_end)-1)

movetraces!(jd::JupyterDisplay, src::AbstractVector{Int}, dest::AbstractVector{Int}) =
    _call_plotlyjs(jd, "moveTraces", src-1, dest-1)

redraw!(jd::JupyterDisplay) = _call_plotlyjs(jd, "redraw")

# unexported (by plotly.js) api methods
extendtraces!(jd::JupyterDisplay, update::Associative=Dict(),
              indices::Vector{Int}=[1], maxpoints=-1;) =
    _call_plotlyjs(jd, "extendTraces", update, indices-1, maxpoints)

prependtraces!(jd::JupyterDisplay, update::Associative=Dict(),
               indices::Vector{Int}=[1], maxpoints=-1;) =
    _call_plotlyjs(jd, "prependTraces", update, indices-1, maxpoints)
