"""
Given the number of rows and columns, return an NTuple{4,Float64} containing
`(width, height, hspace, vspace)`, where `width` and `height` are the
width and height of each subplot and `vspace` and `hspace` are the vertical
and horizonal spacing between subplots, respectively.
"""
function subplot_size(nr::Int, nc::Int, subplot_titles::Bool=false)
    # NOTE: the logic of this function was mostly borrowed from plotly.py
    dx = 0.2 / nc
    dy = subplot_titles ? 0.55 / nr : 0.3 / nr
    width = (1. - dx * (nc - 1)) / nc
    height = (1. - dy * (nr - 1)) / nr
    vspace = nr == 1 ? 0.0 : (1 - height*nr)/(nr-1)
    hspace = nc == 1 ? 0.0 : (1 - width*nc)/(nc-1)
    width, height, hspace, vspace
end

function subplots_layout(nr, nc, subplot_titles::Bool=false)
    w, h, dx, dy = subplot_size(nr, nc, subplot_titles)

    out = Layout()

    x = 0.0  # start from left
    for col in 1:nc

        y = 1.0  # start from top
        for row in 1:nr
            subplot = sub2ind((nr, nc), row, col)

            out["xaxis$subplot"] = Dict{Any,Any}(:domain=>[x, x+w], :anchor=> "y$subplot")
            out["yaxis$subplot"] = Dict{Any,Any}(:domain=>[y-h, y], :anchor=> "x$subplot")

            y -= h + dy
        end

        x += w + dx
    end

    out
end

hastitle(layout::Layout) = haskey(layout.fields, "title") || haskey(layout.fields, :title)
hastitle(plot::Plot) = hastitle(plot.layout)

function add_subplot_annotation!(big_layout::Layout, sub_layout::Layout, ix::Integer)
    hastitle(sub_layout) || return big_layout

    # check for symbol or string
    subtitle = pop!(sub_layout.fields, haskey(sub_layout.fields, "title") ? "title" : :title)

    # add text annotation with the subplot title
    ann = Dict{Any,Any}(:font => Dict{Any,Any}(:size => 16),
                        :showarrow => false,
                        :text => subtitle,
                        :x => mean(big_layout["xaxis$(ix).domain"]),
                        :xanchor => "center",
                        :xref => "paper",
                        :y => big_layout["yaxis$(ix).domain"][2],
                        :yanchor => "bottom",
                        :yref => "paper")
    anns = get(big_layout.fields, :annotations, Dict{Any,Any}[])
    push!(anns, ann)
    big_layout[:annotations] = anns
    big_layout
end

function arrange(layout::Layout, subplots::AbstractVector{<:Plot})
    copied_subplots = Plot[copy(p) for p in subplots]

    for (ix, plot) in enumerate(copied_subplots)
        for trace in plot.data
            trace["xaxis"] = "x$ix"
            trace["yaxis"] = "y$ix"
        end

        add_subplot_annotation!(layout, plot.layout, ix)
        layout["xaxis$ix"] = merge(plot.layout["xaxis"], layout["xaxis$ix"])
        layout["yaxis$ix"] = merge(plot.layout["yaxis"], layout["yaxis$ix"])
    end

    Plot(vcat([p.data for p in copied_subplots]...), layout)
end

arrange(layout::Layout, subplots::AbstractVector{<:SyncPlot}) =
    arrange(layout, [sp.plot for sp in subplots])
arrange(layout::Layout, subplots::Union{Plot, SyncPlot}...) = arrange(layout, [subplots...])

arrange(subplots::AbstractVector{<:Union{Plot, SyncPlot}}) = arrange(subplots_layout(length(subplots), 1, any(hastitle, subplots)), vec(subplots))
arrange(subplots::AbstractMatrix{<:Union{Plot, SyncPlot}}) = arrange(subplots_layout(size(subplots)..., any(hastitle, subplots)), vec(subplots))
