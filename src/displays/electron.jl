# ----------- #
# Blink setup #
# ----------- #

type ElectronDisplay <: AbstractPlotlyDisplay
    w::Nullable{Window}
    js_loaded::Bool
end

ElectronDisplay() = ElectronDisplay(Nullable{Window}(), false)

isactive(ed::ElectronDisplay) = isnull(ed.w) ? false : Blink.active(get(ed.w))

typealias ElectronPlot{TT<:AbstractTrace} Plot{TT,ElectronDisplay}

function get_window(p::ElectronPlot, kwargs...)
    w, h = size(p)
    get_window(p._display; width=w, height=h, kwargs...)
end

function get_window(ed::ElectronDisplay; kwargs...)
    if !isnull(ed.w) && active(get(ed.w))
        w = get(ed.w)
    else
        w = Window(Blink.AtomShell.shell(), Dict(kwargs))
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
        @var _ = Plotly.newPlot(thediv, $(p.data),  $(p.layout), d("showLink"=> false))
        _.then(()->Promise.resolve())
    end
    show(p)
end
