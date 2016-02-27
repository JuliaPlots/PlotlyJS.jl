# ---------------------- #
# Jupyter notebook setup #
# ---------------------- #

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


    @eval import IJulia

    IJulia.display_dict(p::Plot) =
        Dict{ASCIIString,ByteString}("text/html" => sprint(writemime, "text/html", p))

    # TODO: maybe add Blink.js to this page and we can reuse all the same api
    # methods?
end
