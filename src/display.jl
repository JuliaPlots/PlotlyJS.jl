# ----------- #
# Blink setup #
# ----------- #


function get_blink()
    global _blink
    if !isdefined(current_module(), :_blink) || !active(_blink)
        _blink = Blink.AtomShell.init()
    end
    _blink
end

function html_body(p::Plot)
    if isempty(p.data)
        data = """
        [{x: [1, 2, 3, 4, 5],
                     y: [1, 2, 4, 8, 16] }];
        """
    else
        data = json(p.data)
    end

    """
    <div id="$(p.divid)"></div>

    <script>
       thediv = document.getElementById('$(p.divid)');
       var data = $data

       var layouts = { margin: { t: 50 } };

       Plotly.plot(thediv, data,  layouts, {showLink: false});
     </script>
    """
end

stringmime(::MIME"text/html", p::Plot) =  """
    <html>
    <head>
       $(include_js())
    </head>

    <body>
      $(html_body(p))
    </body>
    </html>
    """

Base.writemime(io::IO, ::MIME"text/html", p::Plot) =
    print(io, stringmime(MIME"text/html"(), p))

function get_window(p::Plot)
    if !isnull(p.window) && active(get(p.window))
        w = get(p.window)
    else
        w = Window(get_blink())
        p.window = Nullable{Window}(w)
    end
    w
end

function Base.show(p::Plot)
    w = get_window(p)
    Blink.loadjs!(w, "plotly-latest.min.js")
    Blink.body!(w, html_body(p))
    p
end

# -------------- #
# Javascript API #
# -------------- #

prep_kwarg{T}(a::Tuple{Symbol,T}) = (symbol(replace(string(a[1]), "_", ".")), a[2])

function restyle!(p::Plot, update; kwargs...)
    thediv = "document.getElementById('$(p.divid)')"
    update = json(merge(update, Dict(map(prep_kwarg, kwargs))))
    Blink.js(get_window(p), Blink.JSString("Plotly.restyle($thediv, $update);"))
end

function restyle!(p::Plot; kwargs...)
    thediv = "document.getElementById('$(p.divid)')"
    update = json(Dict(map(prep_kwarg, kwargs)))
    Blink.js(get_window(p), Blink.JSString("Plotly.restyle($thediv, $update);"))
end

# function restyle!(p::Plot, stuff::AbstractPlotlyElement...)
#     thediv = "document.getElementById('$(p.divid)')"
#     Blink.js(w, Blink.JSString("Plotly.restyle($thediv, $update);"))
# end
