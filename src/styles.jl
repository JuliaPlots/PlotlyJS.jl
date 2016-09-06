immutable Style
    name::Symbol
    color_cycle::Vector
    layout::Layout
    global_trace::PlotlyAttribute
    trace::Dict{Symbol,PlotlyAttribute}
end

function Style(;name::Symbol=gensym(), color_cycle=[], layout=Layout(),
                   global_trace=attr(),
                   trace=Dict{Symbol,PlotlyAttribute}())
    Style(name, color_cycle, layout, global_trace, trace)
end

function Style(ps1::Style, ps2::Style)
    nm = Symbol(ps1.name, "+", ps2.name)
    cs = isempty(ps2.color_cycle) ? ps1.color_cycle: ps2.color_cycle

    la = deepcopy(ps1.layout)
    for (k, v) in ps2.layout.fields
        la[k] = v
    end

    gta = merge(ps1.global_trace, ps2.global_trace)

    ta = deepcopy(ps1.trace)
    for (k, v) in ps2.trace
        ta_k = get(ta, k, attr())
        merge!(ta_k, v)
        ta[k] = ta_k
    end

    Style(name=nm,
              color_cycle=cs,
              layout=la,
              global_trace=gta,
              trace=ta)
end

const DEFAULT_STYLE = [Style(name=:default)]

function ggplot_style()
    axis = attr(showgrid=true, gridcolor="white", linewidth=1.0,
                      linecolor="white", titlefont_color="#555555",
                      titlefont_size=14, ticks="outside",
                      tickcolor="#555555"
                      )
    layout = Layout(Dict{Symbol,Any}(:plot_bgcolor => "#E5E5E5",
                                     :paper_bgcolor => "white");
                                     font_size=10,
                                     xaxis=axis,
                                     yaxis=axis,
                                     titlefont_size=14)

    gta = attr(marker_line_width=0.5, marker_line_color="#348ABD")

    colors = ["#E24A33", "#348ABD", "#988ED5", "#777777", "#FBC15E",
              "#8EBA42", "#FFB5B8"]
    Style(name=:ggplot, layout=layout, color_cycle=colors,
              global_trace=gta)
end

function fivethirtyeight_style()
    ta = Dict(:scatter=>attr(line_width=4))
    axis = attr(showgrid=true, gridcolor="#cbcbcb", linewidth=1.0,
                      ticklen=0.0,
                      linecolor="#f0f0f0", titlefont_color="#555555",
                      titlefont_size=12, ticks="outside", showgrid=true,
                      tickcolor="#555555"
                      )
    layout = Layout(plot_bgcolor="#f0f0f0",
                    paper_bgcolor="#f0f0f0",
                    font_size=14,
                    xaxis=axis,
                    yaxis=axis,
                    legend=attr(borderwidth=1.0,
                                bgcolor="f0f0f0", bordercolor="f0f0f0"),
                    titlefont_size=14)
    colors = ["#008fd5", "#fc4f30", "#e5ae38", "#6d904f",
              "#8b8b8b", "#810f7c"]
    Style(name=:fivethirtyeight, layout=layout, color_cycle=colors,
              trace=ta)
end

function seaborn_style()
    ta = Dict(:heatmap=>attr(colorscale="Greys"),
              :scatter=>attr(marker=attr(size=7, line_width=0.0),
                             line_width=1.75))
    axis = attr(showgrid=true, gridcolor="white", linewidth=1.0,
                      ticklen=0.0, showgrid=true,
                      linecolor="white", titlefont_color="#555555",
                      titlefont_size=12, ticks="outside",
                      tickfont_size=10,
                      tickcolor="#555555"
                      )
    # TODO: no concept of major vs minor ticks...
    layout = Layout(plot_bgcolor="EAEAF2",
                    paper_bgcolor="white",
                    width=800,
                    height=550, # TODO: what does font_color=0.15 mean??
                    font=attr(family="Arial", size=14, color=0.15),
                    xaxis=axis,
                    yaxis=axis,
                    legend=attr(font_size=10,
                                bgcolor="white", bordercolor="white"),
                    titlefont_size=14)
    colors = ["#4C72B0", "#55A868", "#C44E52", "#8172B2", "#CCB974", "#64B5CD"]
    Style(name=:fivethirtyeight, color_cycle=colors, trace=ta,
              layout=layout)
end

reset_style!() = DEFAULT_STYLE[1] = Style(name=:default)

use_style!(sty::Symbol) =
    DEFAULT_STYLE[1] = style(sty)

function style(sty::Symbol)
    sty == :ggplot ? ggplot_style() :
    sty == :fivethirtyeight ? fivethirtyeight_style() :
    sty == :seaborn ? seaborn_style() :
    sty == :default ? Style(name=:default) :
    error("Uknown style $sty")
end
