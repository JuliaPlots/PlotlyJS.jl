# ---------------------- #
# Jupyter notebook setup #
# ---------------------- #

mutable struct JupyterDisplay <: AbstractPlotlyDisplay
    divid::UUIDs.UUID
    displayed::Bool
    cond::Condition  # for getting data back from js
end

const JupyterPlot = SyncPlot{JupyterDisplay}

function JupyterDisplay(p::Plot)
    # _ijulia_eval_comm[] = IJulia.CommManager.Comm(:plotlyjs_eval)
    JupyterDisplay(p.divid, false, Condition())
end

JupyterPlot(p::Plot) = JupyterPlot(p, JupyterDisplay(p))

PlotlyBase.fork(jp::JupyterPlot) = JupyterPlot(fork(jp.plot))

const _jupyter_js_loaded = [false]
js_loaded(::JupyterDisplay) = _jupyter_js_loaded[1]
js_loaded(::Type{JupyterDisplay}) = _jupyter_js_loaded[1]

function html_body(p::JupyterPlot)
    lowered = JSON.lower(p.plot)
    suffix = split(string(p.plot.divid, "-"), "-")[1]
    unpack_json = """
    var data_$(suffix) = $(json(lowered[:data]));
    var layout_$(suffix) = $(json(lowered[:layout]));
    """

    plot_code = """
    Plotly.newPlot('$(p.plot.divid)',
        data_$(suffix), layout_$(suffix),
        {showLink: false}
    );
    """

    """
    <div id="$(p.view.divid)" class="plotly-graph-div"></div>

    <script>
        (function() {
            $(unpack_json)
            if (!requirejs.specified('plotly')) {
              requirejs.config({
                paths: {
                  'plotly_cdn': ['https://cdn.plot.ly/plotly-latest.min']
                },
              });
              require(['plotly_cdn'], function(Plotly) {
                $(plot_code)
              });
            } else {
              require(['plotly'], function(Plotly) {
                $(plot_code)
                if (window.Plotly == undefined) {
                    window.Plotly = Plotly;
                }
              });
            }
        })();
     </script>
    """
end

function init_notebook(force=false)
    if !(isdefined(Main, :IJulia) && Main.IJulia.inited)
        return
    end
    # borrowed from https://github.com/plotly/plotly.py/blob/2594076e29584ede2d09f2aa40a8a195b3f3fc66/plotly/offline/offline.py#L64-L71
    # and https://github.com/JuliaLang/Interact.jl/blob/cc5f4cfd34687000bc6bc70f0513eaded1a7c950/src/IJulia/setup.jl#L15
    if !force
        extra_text = """
        <p>Plotly javascript loaded.</p>
        <p>To load again call <pre>init_notebook(true)</pre></p>
        """
    else
        extra_text = ""
    end

    if !js_loaded(JupyterDisplay) || force
        _ijulia_js = read(joinpath(dirname(@__FILE__), "ijulia.js"), String)

        # three script tags for loading ijulia setup, and plotly
        display("text/html", """
        <script charset="utf-8" type='text/javascript'>
            $(_ijulia_js)
        </script>

        <script charset="utf-8" type='text/javascript'>
            define('plotly', function(require, exports, module) {
                $(open(f->read(f, String), _js_path, "r"))
            });
            require(['plotly'], function(Plotly) {
                window.Plotly = Plotly;
            });
        </script>
        $(extra_text)
        """)
        _jupyter_js_loaded[1] = true
    end
end

# ---------------- #
# Helper functions #
# ---------------- #

_call_js(jd::JupyterDisplay, code) =
    send_comm(_ijulia_eval_comm[], Dict("code" => code))

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

relayout!(jd::JupyterDisplay, update::AbstractDict=Dict(); kwargs...) =
    _call_plotlyjs(jd, "relayout", merge(update, prep_kwargs(kwargs)))

restyle!(jd::JupyterDisplay, ind::Int, update::AbstractDict=Dict(); kwargs...) =
    _call_plotlyjs(jd, "restyle", merge(update, prep_kwargs(kwargs)), ind-1)

function restyle!(jd::JupyterDisplay, inds::AbstractVector{Int},
                  update::AbstractDict=Dict();  kwargs...)
    _call_plotlyjs(jd, "restyle", merge(update, prep_kwargs(kwargs)), inds-1)
end

restyle!(jd::JupyterDisplay, update::AbstractDict=Dict(); kwargs...) =
    _call_plotlyjs(jd, "restyle", merge(update, prep_kwargs(kwargs)))

function update!(
        jd::JupyterDisplay, ind::Int, update::AbstractDict=Dict();
        layout::Layout=Layout(), kwargs...
    )
    _call_plotlyjs(jd, "update", merge(update, prep_kwargs(kwargs)), layout, ind-1)
end

function update!(
        jd::JupyterDisplay, inds::AbstractVector{Int},
        update::AbstractDict=Dict(); layout::Layout=Layout(), kwargs...
    )
    _call_plotlyjs(jd, "update", merge(update, prep_kwargs(kwargs)), layout, inds-1)
end

function update!(
        jd::JupyterDisplay, update::AbstractDict=Dict();
        layout::Layout=Layout(),  kwargs...
    )
    _call_plotlyjs(jd, "update", merge(update, prep_kwargs(kwargs)), layout)
end

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
purge!(jd::JupyterDisplay) = _call_plotlyjs(jd, "purge")

to_image(jd::JupyterDisplay; kwargs...) =
    _call_plotlyjs(jd, "to_image", Dict(kwargs))

download_image(jd::JupyterDisplay; kwargs...) =
    _call_plotlyjs(jd, "download_image", Dict(kwargs))

# unexported (by plotly.js) api methods
extendtraces!(jd::JupyterDisplay, update::AbstractDict=Dict(),
              indices::Vector{Int}=[1], maxpoints=-1;) =
    _call_plotlyjs(jd, "extendTraces", update, indices-1, maxpoints)

prependtraces!(jd::JupyterDisplay, update::AbstractDict=Dict(),
               indices::Vector{Int}=[1], maxpoints=-1;) =
    _call_plotlyjs(jd, "prependTraces", update, indices-1, maxpoints)
