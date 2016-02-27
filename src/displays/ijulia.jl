# ---------------------- #
# Jupyter notebook setup #
# ---------------------- #

immutable JupyterDisplay <: AbstractPlotlyDisplay
end

typealias JupyterPlot SyncPlot{ElectronDisplay}

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
        Dict{ASCIIString,ByteString}("text/html" => sprint(writemime, "text/html", p))

    IJulia.display_dict(p::JupyterPlot) = IJulia.display_dict(p.plot)

    # TODO: maybe add Blink.js to this page and we can reuse all the same api
    # methods?
else
    js_loaded(::JupyterDisplay) = false
end
