# ---------------------- #
# Jupyter notebook setup #
# ---------------------- #

type JupyterDisplay <: AbstractPlotlyDisplay
    divid::Base.Random.UUID
    displayed::Bool
end

JupyterDisplay(p::Plot) = JupyterDisplay(p.divid, false)

typealias JupyterPlot SyncPlot{JupyterDisplay}

JupyterPlot(p::Plot) = JupyterPlot(p, JupyterDisplay(p))

# if we're in IJulia call setupnotebook to load js and css
if isdefined(Main, :IJulia) && Main.IJulia.inited
    # the first script is some hack I needed to do in order for the notebook
    # to not complain about Plotly being undefined
    display("text/html", """
        <script type="text/javascript">
            require=requirejs=define=undefined;
        </script>
        <script type="text/javascript">
            $(open(readall, _js_path, "r"))
        </script>
     """)
    display("text/html", "<p>Plotly javascript loaded.</p>")
    js_loaded(::JupyterDisplay) = true

    @eval import IJulia

    IJulia.display_dict(p::Plot) =
        Dict("text/plain" => sprint(writemime, "text/plain", p))

    function IJulia.display_dict(p::JupyterPlot)
        if p.view.displayed
            nothing
        else
            p.view.displayed = true
            Dict("text/html" => sprint(writemime, "text/html", p.plot))
        end
    end

    # TODO: maybe add Blink.js to this page and we can reuse all the same api
    # methods?
else
    js_loaded(::JupyterDisplay) = false
end

## API Methods for JupyterDisplay
function call_plotlyjs(jd::JupyterDisplay, func::AbstractString, args...)
    arg_str = join(map(json, args), ", ")
    display("text/html", """<script>
        var thediv = document.getElementById('$(jd.divid)');
        Plotly.$func(thediv, $arg_str)
    </script>""")
end

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
