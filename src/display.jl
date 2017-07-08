# ----------------------- #
# Display-esque functions #
# ----------------------- #

function html_body(p::Plot)
    """
    <div id="$(p.divid)" class="plotly-graph-div"></div>

    <script>
        window.PLOTLYENV=window.PLOTLYENV || {};
        window.PLOTLYENV.BASE_URL="https://plot.ly";
        $(script_content(p))
     </script>
    """
end

function script_content(p::Plot)
    lowered = JSON.lower(p)
    """
    Plotly.newPlot('$(p.divid)', $(json(lowered[:data])),
                   $(json(lowered[:layout])), {showLink: false});
    """
end


function stringmime(::MIME"text/html", p::Plot, js::Symbol=:local)

    if js == :local
        script_txt = "<script src=\"$(_js_path)\"></script>"
    elseif js == :remote
        script_txt = "<script src=\"$(_js_cdn_path)\"></script>"
    elseif js == :embed
        script_txt = "<script>$(@compat readstring(_js_path))</script>"
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

@compat Base.show(io::IO, ::MIME"text/html", p::Plot, js::Symbol=:local) =
    print(io, stringmime(MIME"text/html"(), p, js))

@compat function Base.show(io::IO, ::MIME"text/plain", p::Plot)
    println(io, """
    data: $(json(map(_describe, p.data), 2))
    layout: "$(_describe(p.layout))"
    """)
end

Base.show(io::IO, p::Plot) = @compat show(io, MIME("text/plain"), p)

# ----------------------------------------- #
# SyncPlot -- sync Plot object with display #
# ----------------------------------------- #
immutable SyncPlot{TD<:AbstractPlotlyDisplay}
    plot::Plot
    view::TD
end

plot(args...; kwargs...) = SyncPlot(Plot(args...; kwargs...))

## API methods for SyncPlot
for f in [:restyle!, :relayout!, :addtraces!, :deletetraces!, :movetraces!,
          :redraw!, :extendtraces!, :prependtraces!, :purge!, :to_image,
          :download_image]
    @eval function $(f)(sp::SyncPlot, args...; kwargs...)
        $(f)(sp.plot, args...; kwargs...)
        $(f)(sp.view, args...; kwargs...)
    end

    no_!_method = Symbol(string(f)[1:end-1])
    @eval function $(no_!_method)(sp::SyncPlot, args...; kwargs...)
        sp2 = fork(sp)
        $f(sp2.plot, args...; kwargs...)  # only need to update the julia side
        sp2  # return so we display fresh
    end
end

# add extra same extra methods we have on ::Plot for these functions
for f in (:extendtraces!, :prependtraces!)
    @eval begin
        function $(f)(p::AbstractPlotlyDisplay, inds::Vector{Int}=[0],
                      maxpoints=-1; update...)
            ($f)(p, Dict(map(x->(x[1], _tovec(x[2])), update)), inds, maxpoints)
        end

        function $(f)(p::AbstractPlotlyDisplay, ind::Int, maxpoints=-1;
                      update...)
            ($f)(p, [ind], maxpoints; update...)
        end

        function $(f)(p::AbstractPlotlyDisplay, update::Associative, ind::Int,
                      maxpoints=-1)
            ($f)(p, update, [ind], maxpoints)
        end
    end
end

@compat Base.show(io::IO, ::MIME"text/html", sp::SyncPlot, js::Symbol=:local) =
    print(io, stringmime(MIME"text/html"(), sp.plot, js))

# Add some basic Julia API methods on SyncPlot that just forward onto the Plot
Base.size(sp::SyncPlot) = size(sp.plot)
Base.copy(sp::SyncPlot) = fork(sp)  # defined by each SyncPlot{TD}

# ----------------- #
# Display frontends #
# ----------------- #

include("displays/juno.jl")
include("displays/electron.jl")
include("displays/ijulia.jl")

# methods to convert from one frontend to another
let
    all_frontends = [:ElectronPlot, :JupyterPlot]
    for fe_to in all_frontends
        for fe_from in all_frontends
            @eval $(fe_to)(sp::$(fe_from)) = $(fe_to)(sp.plot)
        end
    end
end

# -------- #
# Defaults #
# -------- #
