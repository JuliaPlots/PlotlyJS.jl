"""
Given the number of rows and columns, return an NTuple{4, Int} containing
`(width, height, vspace, hspace)`, where `width` and `height` are the
width and height of each subplot and `vspace` and `hspace` are the vertical
and horizonal spacing between subplots, respectively.
"""
function sizes(nr::Int, nc::Int)
    dx = 0.2 / nc
    dy = 0.3 / nr
    width = (1. - dx * (nc - 1)) / nc
    height = (1. - dy * (nr - 1)) / nr
    vspace = nr == 1 ? 0.0 : (1 - height*nr)/(nr-1)
    hspace = nc == 1 ? 0.0 : (1 - width*nc)/(nc-1)
    width, height, vspace, hspace
end

function gen_layout(nr, nc)
    w, h, dy, dx = sizes(nr, nc)

    x = 0.0  # start from left
    y = 1.0  # start from top

    out = Layout()
    for col in 1:nc

        y = 1.0 # reset y as we start a new col
        for row in 1:nr
            subplot = sub2ind((nc, nr), col, row)

            out["xaxis$subplot"] = Dict{Any,Any}("domain"=>[x, x+w],
                                                 "anchor"=>"y$subplot")
            out["yaxis$subplot"] = Dict{Any,Any}("domain"=>[y-h, y],
                                                 "anchor"=>"x$subplot")

            y -= nr == 1 ? 0.0 : h + dy
         end

         x += nc == 1 ? 0.0 : w + dx
    end

    out

end

function _cat(nr::Int, nc::Int, ps::Plot...)

    copied_plots = Plot[copy(p) for p in ps]
    layout = gen_layout(nr, nc)

    for col in 1:nc, row in 1:nr
        ix = sub2ind((nc, nr), col, row)

        for trace in copied_plots[ix].data
            trace["xaxis"] = "x$ix"
            trace["yaxis"] = "y$ix"
        end

        layout["xaxis$ix"] = merge(copied_plots[ix].layout["xaxis"], layout["xaxis$ix"])
        layout["yaxis$ix"] = merge(copied_plots[ix].layout["yaxis"], layout["yaxis$ix"])
    end

    Plot(vcat([p.data for p in copied_plots]...), layout)
end

Base.hcat(ps::Plot...) = _cat(1, length(ps), ps...)
Base.vcat(ps::Plot...) = _cat(length(ps), 1,  ps...)
Base.vect(ps::Plot...) = vcat(ps...)

function Base.hvcat(rows::Tuple{Vararg{Int}}, ps::Plot...)
    nr = length(rows)
    nc = rows[1]

    for (i, c) in enumerate(rows[2:end])
        c == nc || error("Saw $c columns in row $(i+1), expected $nc")
    end
    _cat(nr, nc, ps...)
end
