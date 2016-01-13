# ----------- #
# Blink setup #
# ----------- #

const _js_path = joinpath(dirname(dirname(@__FILE__)),
                          "deps", "plotly-latest.min.js")
const _js_cdn_path = "https://cdn.plot.ly/plotly-latest.min.js"


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


function stringmime(::MIME"text/html", p::Plot, js::Symbol=:local)

    if js == :local
        script_txt = "<script src=\"$(_js_path)\"></script>"
    elseif js == :remote
        script_txt = "<script src=\"$(_js_cdn_path)\"></script>"
    elseif js == :embed
        script_txt = "<script>$(readall(_js_path))</script>"
    else
        msg = """
        Unknown value for argument js: $js.
        Possible choices are `:local`, `:remote`, `:embed`
            """
        throw(ArgumentError(msg))
    end
    

    """
    <html>
    <head>
         $script_txt
    </head>
    <body>
         $(html_body(p))
    </body>
    </html>
    """

end


Base.writemime(io::IO, ::MIME"text/html", p::Plot, js::Symbol=:local) =
    print(io, stringmime(MIME"text/html"(), p, js))


get_blink() = Blink.AtomShell.shell()

function get_window(p::Plot)
    if !isnull(p.window) && active(get(p.window))
        w = get(p.window)
    else
        width, height = size(p)
        w = Window(get_blink(), Dict{Any,Any}(:width=>width, :height=>height))
        p.window = Nullable{Window}(w)
    end
    w
end

function Base.show(p::Plot)
    w = get_window(p)
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
