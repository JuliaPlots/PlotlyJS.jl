# ----------- #
# Blink setup #
# ----------- #

const _js_path = joinpath(dirname(dirname(@__FILE__)),
                          "deps", "plotly-latest.min.js")

function html_body(p::Plot)
    """
    <div id="$(p.divid)"></div>

    <script>
       thediv = document.getElementById('$(p.divid)');
       var data = $(json(p.data))
       var layout = $(json(p.layout))

       Plotly.plot(thediv, data,  layout, {showLink: false});
     </script>
    """
end

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
    Blink.body!(w, html_body(p))
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

# -------------- #
# Javascript API #
# -------------- #

Blink.js(p::Plot, code::JSString; callback = true) =
    Blink.js(get_window(p), :(Blink.evalwith(thediv, $(Blink.jsstring(code)))), callback = callback)

prep_kwarg(pair) = (symbol(replace(string(pair[1]), "_", ".")), pair[2])
prep_kwargs(pairs) = Dict(map(prep_kwarg, pairs))

restyle!(p::Plot, update = Dict(); kwargs...) =
    @js_ p Plotly.restyle(this, $(merge(update, prep_kwargs(kwargs))))

restyle!(p::Plot, traces::Integer...; kwargs...) =
    @js_ p Plotly.restyle(this, $(prep_kwargs(kwargs)), $(collect(traces)))

# TODO: consider the array stuff

relayout!(p::Plot, update = Dict(); kwargs...) =
    @js_ p Plotly.relayout(this, $(merge(update, prep_kwargs(kwargs))))

addtraces!(p::Plot, traces::AbstractTrace...) =
    @js_ p Plotly.addtraces(this, $traces)

# TODO: add method for where to add trace

deletetraces!(p::Plot, traces::Int...) =
    @js_ p Plotly.deleteTraces(this, $(collect(traces)))

movetraces!(p::Plot, to_end) =
    @js_ p Plotly.moveTraces(this, $to_end)

movetraces!(p::Plot, to_end...) = movetraces!(p, collect(to_end))

movetraces!(p::Plot, src::Vector{Int}, dest::Vector{Int}) =
    @js_ p Plotly.moveTraces(this, $src, $dest)

redraw!(p::Plot) =
    @js_ p Plotly.redraw(this)
