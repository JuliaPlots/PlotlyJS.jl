immutable PlotStyle
    name::Symbol
    color_cycle::Vector
    layout_attrs::Layout
    global_trace_attrs::PlotlyAttribute
    trace_attrs::Dict{Symbol,PlotlyAttribute}
end

function PlotStyle(;name::Symbol=gensym(), color_cycle=[], layout_attrs=Layout(),
                   global_trace_attrs=attr(),
                   trace_attrs=Dict{Symbol,PlotlyAttribute}())
    PlotStyle(name, color_cycle, layout_attrs, global_trace_attrs, trace_attrs)
end

function PlotStyle(ps1::PlotStyle, ps2::PlotStyle)
    nm = Symbol(ps1.name, "+", ps2.name)
    cs = isempty(ps2.color_cycle) ? ps1.color_cycle: ps2.color_cycle

    la = deepcopy(ps1.layout_attrs)
    for (k, v) in ps2.layout_attrs.fields
        la[k] = v
    end

    gta = merge(ps1.global_trace_attrs, ps2.global_trace_attrs)

    ta = deepcopy(ps1.trace_attrs)
    for (k, v) in ps2.trace_attrs
        ta_k = get(ta, k, attr())
        merge!(ta_k, v)
        ta[k] = ta_k
    end

    PlotStyle(name=nm,
              color_cycle=cs,
              layout_attrs=la,
              global_trace_attrs=gta,
              trace_attrs=ta)
end

const DEFAULT_STYLE = [PlotStyle(name=:default)]

function ggplot_style()
    axis_attrs = attr(showgrid=true, gridcolor="white", linewidth=1.0,
                      linecolor="white", titlefont_color="#555555",
                      titlefont_size=12, ticks="outside",
                      tickcolor="#555555"
                      )
    layout = Layout(Dict{Symbol,Any}(:plot_bgcolor => "#E5E5E5",
                                     :paper_bgcolor => "white");
                                     font_size=10,
                                     xaxis=axis_attrs,
                                     yaxis=axis_attrs,
                                     titlefont_size=14)

    colors = ["#E24A33", "#348ABD", "#988ED5", "#777777", "#FBC15E",
              "#8EBA42", "#FFB5B8"]
    PlotStyle(name=:ggplot, layout_attrs=layout, color_cycle=colors)
end

function fivethirtyeight_style()
end

reset_style!() = DEFAULT_STYLE[1] = PlotStyle(name=:default)

use_style!(sty::Symbol) =
    DEFAULT_STYLE[1] = style(sty)

function style(sty::Symbol)
    if sty == :ggplot
        ggplot_style()
    elseif sty == :fivethirtyeight
        fivethirtyeight_style()
    elseif sty == :default
        PlotStyle(:default)
    else
        error("Uknown style $sty")
    end
end
