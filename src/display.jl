# ----------- #
# Blink setup #
# ----------- #

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

get_window(p::ElectronPlot, kwargs...) = get_window(p._display; kwargs...)

function get_window(ed::ElectronDisplay, kwargs...)
    if !isnull(ed.w) && active(get(ed.w))
        w = get(ed.w)
    else
        width, height = size(p)
        opts = merge(Dict{Any,Any}(:width=>width, :height=>height), Dict(kwargs))
        w = Window(Blink.AtomShell.shell(), opts)
        ed.w = Nullable{Window}(w)
        ed.js_loaded = false  # can't have js if we made a new window
    end
    w
end

js_loaded(ed::ElectronDisplay) = ed.js_loaded
function loadjs(ed::ElectronDisplay)
    if !ed.js_loaded
        Blink.load!(get_window(ed), _js_path)
        ed.js_loaded = true
    end
end

function Base.display(p::Plot)
    w = get_window(p)
    loadjs(p._display)
    @js w begin
        trydiv = document.getElementById($(string(p.divid)))
        if trydiv == nothing
            thediv = document.createElement("div")
            thediv.id = $(string(p.divid))
            document.body.appendChild(thediv)
        else
            thediv = trydiv
        end
        Plotly.newPlot(thediv, $(p.data),  $(p.layout), d("showLink"=> false))
    end
    show(p)
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


    @eval import IJulia

    IJulia.display_dict(p::Plot) =
        Dict{ASCIIString,ByteString}("text/html" => sprint(writemime, "text/html", p))

    # TODO: maybe add Blink.js to this page and we can reuse all the same api
    # methods?
end
