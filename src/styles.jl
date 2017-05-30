#=
Note that the following styles used values from the matplotlib style library
(https://github.com/matplotlib/matplotlib/tree/master/lib/matplotlib/mpl-data/stylelib):

- ggplot
- fivethirtyeight
- seaborn

=#

@compat struct Style
    color_cycle::Vector
    layout::Layout
    global_trace::PlotlyAttribute
    trace::Dict{Symbol,PlotlyAttribute}
end

function Style(;color_cycle=[], layout=Layout(), global_trace=attr(),
                trace=Dict{Symbol,PlotlyAttribute}())
    Style(color_cycle, layout, global_trace, trace)
end

function Style(ps1::Style, ps2::Style)
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

    Style(color_cycle=cs, layout=la, global_trace=gta, trace=ta)
end

Style(pss::Style...) = foldl(Style, pss[1], pss[2:end])

function Style(base::Style; color_cycle=[], layout=Layout(),
               global_trace=attr(), trace=Dict{Symbol,PlotlyAttribute}())
    new_style = Style(color_cycle, layout, global_trace, trace)
    Style(base, new_style)
end

@compat function Base.show(io::IO, ::MIME"text/plain", s::Style)
    println(io, "Style with:")

    if !isempty(s.color_cycle)
        println(io, "  - color_cycle: ", s.color_cycle)
    end

    if !isempty(s.layout)
        print(io, "  - "); show(io, MIME"text/plain"(), s.layout)
    end

    if !isempty(s.global_trace)
        print(io, "  - global_trace: ")
        show(io, MIME"text/plain"(), s.global_trace)
    end

    if !isempty(s.trace)
        println(io, "  - trace: ")
        for (k, v) in s.trace
            print(io, "    - ", k, ": "); show(io, MIME"text/plain"(), v)
        end
    end
end

function ==(s1::Style, s2::Style)
    all(nm -> getfield(s1, nm) == getfield(s2, nm), fieldnames(s1))
end

function ggplot_style()
    axis = attr(showgrid=true, gridcolor="white", linewidth=1.0,
                linecolor="white", titlefont_color="#555555",
                titlefont_size=14, ticks="outside",
                tickcolor="#555555"
                )
    layout = Layout(plot_bgcolor="#E5E5E5",
                    paper_bgcolor="white",
                    font_size=10,
                    xaxis=axis,
                    yaxis=axis,
                    titlefont_size=14)

    gta = attr(marker_line_width=0.5, marker_line_color="#348ABD")

    colors = ["#E24A33", "#348ABD", "#988ED5", "#777777", "#FBC15E",
              "#8EBA42", "#FFB5B8"]
    Style(layout=layout, color_cycle=colors, global_trace=gta)
end

function fivethirtyeight_style()
    ta = Dict(:scatter=>attr(line_width=4))
    axis = attr(showgrid=true, gridcolor="#cbcbcb",
                linewidth=1.0, linecolor="#f0f0f0",
                ticklen=0.0, tickcolor="#555555", ticks="outside",
                titlefont_size=12, titlefont_color="#555555")
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
    Style(layout=layout, color_cycle=colors, trace=ta)
end

function seaborn_style()
    ta = Dict(:heatmap=>attr(colorscale="Greys"),
              :scatter=>attr(marker=attr(size=7, line_width=0.0),
                             line_width=1.75))
    axis = attr(showgrid=true, gridcolor="white",
                linewidth=1.0, linecolor="white",
                ticklen=0.0, tickcolor="#555555", ticks="outside", tickfont_size=10,
                titlefont_size=12, titlefont_color="#555555")
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
    Style(color_cycle=colors, trace=ta, layout=layout)
end

# This theme was taken from here:
# https://github.com/dcjones/Gadfly.jl/blob/cb28d6aca6b031d01e44146799e520b8bb0d349b/src/theme.jl#L342-L409
function gadfly_dark_style()
    label_color = colorant"#a1a1a1"
    bgcolor = colorant"#222831"
    grid_color = colorant"#575757"

    color_cycle = ["#FE4365", "#ECA25C", "#3F9778", "#EEDBFF", "#236EAD",
                   "#60F6FF", "#D4EC9F", "#7E674B", "#9E7EC1", "#7CB5FB"]

    axis = attr(showgrid=true, gridcolor=grid_color, gridwidth=0.35,
                linecolor=grid_color, titlefont_color=label_color,
                linewidth=1.2, titlefont_size=14, tickcolor=label_color
                )

    layout = Layout(plot_bgcolor=bgcolor,
                    paper_bgcolor=bgcolor,
                    font_size=10,
                    xaxis=axis,
                    yaxis=axis,
                    font_color=label_color,
                    titlefont_size=14,
                    margin=attr(l=40, r=10, t=10, b=30))


    Style(color_cycle=color_cycle, layout=layout)
end

function tomorrow_night_eighties_style()

    bgcolor = colorant"#2d2d2d"  # Background
    grid_color = colorant"#515151"  # Selection
    label_color = colorant"#cccccc"  # Comment
    color_cycle = [
                    "#cc99cc",
                    "#66cccc",
                    "#f2777a",
                    "#ffcc66",
                    "#99cc99",
                    "#f99157",
                    "#6699cc",
                   ]

    axis = attr(showgrid=true, gridcolor=grid_color, gridwidth=0.35,
                linecolor=grid_color, titlefont_color=label_color,
                linewidth=1.2, titlefont_size=14, tickcolor=label_color
                )

    layout = Layout(plot_bgcolor=bgcolor,
                    paper_bgcolor=bgcolor,
                    font_size=10,
                    xaxis=axis,
                    yaxis=axis,
                    font_color=label_color,
                    titlefont_size=14,
                    margin=attr(l=65, r=65, t=65, b=65))


    Style(color_cycle=color_cycle, layout=layout)
end

function style(sty::Symbol)
    sty == :ggplot ? ggplot_style() :
    sty == :fivethirtyeight ? fivethirtyeight_style() :
    sty == :seaborn ? seaborn_style() :
    sty == :gadfly_dark ? gadfly_dark_style() :
    sty == :tomorrow_night_eighties ? tomorrow_night_eighties_style() :
    sty == :default ? _default_style() :
    error("Uknown style $sty")
end

const STYLES = [:default, :ggplot, :fivethirtyeight, :seaborn, :gadfly_dark,
                :tomorrow_night_eighties]

function _default_style()
    env = Symbol(get(ENV, "PLOTLYJS_STYLE", ""))

    env in STYLES ? style(env) :
    Juno.isactive() ? style(:gadfly_dark) : Style()
end

reset_style!() = DEFAULT_STYLE[1] = _default_style()
use_style!(sty::Symbol) = DEFAULT_STYLE[1] = style(sty)
use_style!(s::Style) = DEFAULT_STYLE[1] = s
