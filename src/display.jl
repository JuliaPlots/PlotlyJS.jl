# ----------------------- #
# Display-esque functions #
# ----------------------- #


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

function Base.writemime(io::IO, ::MIME"text/plain", p::Plot)
    println(io, """
    data: $(json(map(_describe, p.data), 2))
    layout: "$(_describe(p.layout))"
    """)
end

Base.show(io::IO, p::Plot) = writemime(io, MIME("text/plain"), p)

# -------------- #
# Other displays #
# -------------- #
include("displays/electron.jl")
include("displays/ijulia.jl")
