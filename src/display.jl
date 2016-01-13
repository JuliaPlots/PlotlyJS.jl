# ----------- #
# Blink setup #
# ----------- #

const _js_path = joinpath(dirname(dirname(@__FILE__)),
                          "deps", "plotly-latest.min.js")

function html_body(p::Plot)
    """
    <div id="$(p.divid)"></div>

    <script>
       $(script_content(p))
     </script>
    """
end

script_content(p::Plot) = """
    thediv = document.getElementById('$(p.divid)');
    var data = $(json(p.data))
    var layout = $(json(p.layout))

    Plotly.plot(thediv, data,  layout, {showLink: false});
    """

stringmime(::MIME"text/html", p::Plot) =  """
    <html>
    <head>
        <script src="$(_js_path)"></script>
    </head>

    <body>
      $(html_body(p))
    </body>
    </html>
    """

Base.writemime(io::IO, ::MIME"text/html", p::Plot) =
    print(io, stringmime(MIME"text/html"(), p))


get_blink() = Blink.AtomShell.shell()

function get_window(p::Plot, kwargs...)
    if !isnull(p.window) && active(get(p.window))
        w = get(p.window)
    else
        width, height = size(p)
        opts = merge(Dict(kwargs), Dict{Any,Any}(:width=>width, :height=>height))
        w = Window(get_blink(), opts)
        p.window = Nullable{Window}(w)
    end
    w
end

function Base.show(p::Plot; kwargs...)
    w = get_window(p, kwargs...)
    Blink.load!(w, _js_path)
    @js w begin
        @var thediv = document.createElement("div")
        thediv.id = $(string(p.divid));
        document.body.appendChild(thediv);
        Plotly.plot(thediv, $(p.data),  $(p.layout), d("showLink"=> false))
    end
    p
end

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
end
