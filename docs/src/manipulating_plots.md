<!-- TODO: create API docs from docstrings and add link below -->

There are various methods defined on the `Plot` type. We will cover a few of
them here, but consult the (forthcoming) API docs for more exhaustive coverage.

## Julia functions

`Plot` and `SyncPlot` both have implementations of common Julia methods:

- `size`: returns the `width` and `layout` attributes in the plot's layout
- `copy`: create a shallow copy of all traces in the plot and the layout, but
create a new `divid`

## API functions

All exported functions from the plotly.js
[API](https://plotly.com/javascriptplotlyjs-function-reference/) have been
exposed to Julia and operate on both `Plot` and `SyncPlot` instances. Each of
these functions has semantics that match the semantics of plotly.js

In PlotlyJS.jl these functions are spelled:

- [`restyle!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlyrestyle): edit attributes on one or more traces
- [`relayout!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlyrelayout): edit attributes on the layout
- [`update!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlyupdate): combination of `restyle!` and `relayout!`
- [`react!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlyreact): In place updating of all traces and layout in plot. More efficient than constructing an entirely new plot from scratch, but has the same effect.
- [`addtraces!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlyaddtraces): add traces to a plot at specified indices
- [`deletetraces!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlydeletetraces): delete specific traces from a plot
- [`movetraces!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlymovetraces): reorder traces in a plot
- [`redraw!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlyredraw): for a redraw of an entire plot
- [`purge!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlypurge): completely remove all data and layout from the chart
- [`extendtraces!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlyextendtraces): Extend specific attributes of one or more traces with more data by appending to the end of the attribute
- [`prependtraces!`](https://plotly.com/javascriptplotlyjs-function-reference/#plotlyprependtraces): Prepend additional data to specific attributes on one or more traces


When any of these routines is called on a `SyncPlot` the underlying `Plot`
object (in the `plot` field on the `SyncPlot`) is updated and the plotly.js
function is called. This is where `SyncPlot` gets its name: when modifying a
plot, it keeps the Julia object and the display in sync.

<!-- TODO: create API docs from docstrings and add link below -->

For more details on which methods are available for each of the above functions
consult the docstrings or (forthcoming) API documentation.

!!! note
    Be especially careful when trying to use `restyle!`, `extendtraces!`, and
    `prependtraces!` to set attributes that are arrays. The semantics are a bit
    subtle. Check the docstring for details and examples

## Subplots

A common task is to construct subpots, or plots with more than one set of axes.
This is possible using the declarative plotly.js syntax, but can be tedious at
best.

PlotlyJS.jl provides a conveient syntax for constructing what we will
call regular grids of subplots. By regular we mean a square grid of plots.

To do this we will make a pun of the `vcat`, `hcat`, and `hvcat` functions from
`Base` and leverage the array construction syntax to build up our subplots.

Suppose we are working with the following plots:

```@repl subplots
using PlotlyJS  # hide
p1 = Plot(scatter(;y=randn(3)))
p2 = Plot(histogram(;x=randn(50), nbinsx=4))
p3 = Plot(scatter(;y=cumsum(randn(12)), name="Random Walk"))
p4 = Plot([scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy"),
           scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")])
```

If we wanted to combine `p1` and `p2` as subplots side-by-side, we would do

```@example subplots
[p1 p2]
```

If instead we wanted two rows and one column we could

```@example subplots
[p3, p4]
```

Finally, we can make a 2x2 grid of subplots:

```@example subplots
[p1 p2
 p3 p4]
```

## Saving figures


Figures can be saved in a variety of formats using the `savefig` function.

!!! note
   Note that the docs below are shown for the `PlotlyBase.Plot` type, but are also defined for `PlotlyJS.SyncPlot`. Thus, you can use these methods after calling either `plot` or `Plot`.

This function has a few methods:

**1**

```@docs
savefig(::Union{PlotlyBase.Plot}, ::String)
```

When using this method the format of the file is inferred based on the extension
of the second argument. The examples below show the possible export formats:

```julia
savefig(p::Union{Plot,SyncPlot}, "output_filename.pdf")
savefig(p::Union{Plot,SyncPlot}, "output_filename.html")
savefig(p::Union{Plot,SyncPlot}, "output_filename.json")
savefig(p::Union{Plot,SyncPlot}, "output_filename.png")
savefig(p::Union{Plot,SyncPlot}, "output_filename.svg")
savefig(p::Union{Plot,SyncPlot}, "output_filename.jpeg")
savefig(p::Union{Plot,SyncPlot}, "output_filename.webp")
```

**2**

```julia
savefig(
    io::IO,
    p::Plot;
    width::Union{Nothing,Int}=nothing,
    height::Union{Nothing,Int}=nothing,
    scale::Union{Nothing,Real}=nothing,
    format::String="png"
)
```

This method allows you to save a plot directly to an open IO stream.

See the [`savefig(::IO, ::PlotlyBase.Plot)`](@ref) API docs for more information.

**3**

```julia
Base.show(::IO, ::MIME, ::Union{PlotlyBase.Plot})
```

This method hooks into Julia's rich display system.

Possible arguments for the second argument are shown in the examples below:

```julia
savefig(io::IO, ::MIME"application/pdf", p::Union{Plot,SyncPlot})
savefig(io::IO, ::MIME"image/png", p::Union{Plot,SyncPlot})
savefig(io::IO, ::MIME"image/svg+xml", p::Union{Plot,SyncPlot})
savefig(io::IO, ::MIME"image/eps", p::Union{Plot,SyncPlot})
savefig(io::IO, ::MIME"image/jpeg", p::Union{Plot,SyncPlot})
savefig(io::IO, ::MIME"application/json", p::Union{Plot,SyncPlot})
savefig(io::IO, ::MIME"application/json; charset=UTF-8", p::Union{Plot,SyncPlot})
```

!!! note
    You can also save the json for a figure by calling
    `savejson(p::Union{Plot,SyncPlot}, filename::String)`.
