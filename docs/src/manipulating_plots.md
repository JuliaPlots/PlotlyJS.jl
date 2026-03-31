# Working with plots

There are various methods defined on the `Plot` type. We will cover a few of
them here, but consult the package [API Documentation](@ref) for more exhaustive coverage.

## Julia functions

`Plot` and `SyncPlot` both have implementations of common Julia methods:

- `size`: returns the `width` and `layout` attributes in the plot's layout
- `copy`: creates a shallow copy of all traces in the plot and the layout
   (but creates a new `divid` for controlling interaction with HTML layouts).
- `show`: draws the plot, where the specific form it takes depends on the
   context it is called in (such as the REPL, a notebook or for a web page).

## Plotly API functions

All exported functions from the [plotly.js API](https://plotly.com/javascript/plotlyjs-function-reference/) 
have been exposed to Julia and operate on both `Plot` and `SyncPlot` instances.
Each of these functions has semantics that match the semantics of plotly.js library.


In PlotlyJS.jl these functions are spelled:

- [`restyle!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlyrestyle): Edit attributes on one or more traces
- [`relayout!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlyrelayout): Edit attributes on the layout
- [`update!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlyupdate): A combination of `restyle!` and `relayout!`
- [`react!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlyreact): In-place updating of all traces and layout in plot. More efficient than constructing an entirely new plot from scratch, but has the same effect.
- [`addtraces!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlyaddtraces): Add traces to a plot at specified indices
- [`deletetraces!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlydeletetraces): Delete specific traces from a plot
- [`movetraces!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlymovetraces): Reorder traces in a plot
- [`redraw!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlyredraw): Redraw an entire plot
- [`purge!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlypurge): Completely remove all data and layout from the chart
- [`extendtraces!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlyextendtraces): Extend specific attributes of one or more traces with more data by appending to the end of the attribute
- [`prependtraces!`](https://plotly.com/javascript/plotlyjs-function-reference/#plotlyprependtraces): Prepend additional data to specific attributes on one or more traces


When any of these routines is called on a `SyncPlot` the underlying `Plot`
object (in the `plot` field on the `SyncPlot`) is updated and the plotly.js
function is called. This is where `SyncPlot` gets its name: when modifying a
plot, it keeps the Julia object and the display in sync.

For more details on which methods are available for each of the above functions
consult the docstrings or [API Documentation](@ref).

!!! note
    Be especially careful when trying to use `restyle!`, `extendtraces!`, and
    `prependtraces!` to set attributes that are arrays. The semantics are a bit
    subtle. Check the docstring for details and examples

## Subplots

A common task is to construct subpots, or plots with more than one set of axes.
This is possible using the declarative plotly.js syntax, but can be tedious at
best.

PlotlyJS.jl provides a convenient syntax for constructing what we will
call regular grids of subplots. By regular we mean a square grid of plots like a matrix.

To do this we adapt the `vcat`, `hcat`, and `hvcat` functions from
`Base` and leverage the array construction syntax to build up our subplots.

Suppose we are working with the following plots:

```@repl subplots
using PlotlyJS  # hide
p1 = plot(scatter(;y=randn(3)))
p2 = plot(histogram(;x=randn(50), nbinsx=4))
p3 = plot(scatter(;y=cumsum(randn(12)), name="Random Walk"))
p4 = plot([scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy"),
           scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")])
```

If we wanted to combine `p1` and `p2` as subplots side-by-side, we would do

```@example subplots
[p1 p2]
```

If instead we wanted two rows and one column we could

```@example subplots
[p2 p3; p4]
```

Finally, we can make a 2x2 grid of subplots:

```@example subplots
[p1 p2
 p3 p4]
```

!!! note
    New in PlotlyBase version 0.6.5 (PlotlyJS version 0.16.4)


We can also create a non-rectangular grid of subplots using this syntax.

For example:

```@example subplots
[p1 p2 p3 p4; p2 p4; p1]
```

### The `make_subplots` function

!!! note
    New in PlotlyBase version 0.6.4 (PlotlyJS version 0.16.3)

There is another option for creaing subplots: the `make_subplots` function.

This function takes a number of keyword arguments and allows fine grained control over the layout and labels for subplots.

Consider the example below:

```@example subplots
sp = make_subplots(
    rows=5, cols=2,
    specs=[Spec() Spec(rowspan=2)
           Spec() missing
           Spec(rowspan=2, colspan=2) missing
           missing missing
           Spec() Spec()]
)

add_trace!(sp, scatter(x=[1, 2], y=[1, 2], name="(1,1)"), row=1, col=1)
add_trace!(sp, scatter(x=[1, 2], y=[1, 2], name="(1,2)"), row=1, col=2)
add_trace!(sp, scatter(x=[1, 2], y=[1, 2], name="(2,1)"), row=2, col=1)
add_trace!(sp, scatter(x=[1, 2], y=[1, 2], name="(3,1)"), row=3, col=1)
add_trace!(sp, scatter(x=[1, 2], y=[1, 2], name="(5,1)"), row=5, col=1)
add_trace!(sp, scatter(x=[1, 2], y=[1, 2], name="(5,2)"), row=5, col=2)

relayout!(sp, height=600, width=600, title_text="specs examples")
plot(sp.plot)
```

You can view the docs for [`make_subplots`](@ref) to get a further idea of what else is possible.

## Saving figures

Figures can be saved in a variety of formats using the [`savefig`](@ref) function.

!!! note
    Note that the docs below are shown for the `PlotlyBase.Plot` type, but are also defined for `PlotlyJS.SyncPlot`.
    Thus, you can use these methods after calling either `plot` or `Plot`.

The `savefig` function can be called in a few ways:

**Save into a file**

`savefig(p, filename)` saves the plot `p` into `filename`.
Unless explicitly specified, the format of the file is inferred from the `filename` extension.
The examples demonstrate the supported formats:

```julia
savefig(p, "output_filename.pdf")
savefig(p, "output_filename.html")
savefig(p, "output_filename.json")
savefig(p, "output_filename.png")
savefig(p, "output_filename.svg")
savefig(p, "output_filename.jpeg")
savefig(p, "output_filename.webp")
```

**Save into a stream**

`savefig(io, p)` saves the plot `p` into the open `io` stream.
The figure format could be specified with the `format` keyword, the default format is *PNG*.

**Display on the screen**

PlotlyJS.jl overloads the `Base.show` method to hook into Julia's rich display system:
```julia
Base.show(io::IO, ::MIME, p::Union{PlotlyBase.Plot, PlotlyJS.SyncPlot})
```
Internally, this `Base.show` implementation calls `savefig(io, p)`,
and the `MIME` argument allows to specify the output format.

The following MIME formats are supported:
* `::MIME"application/pdf`
* `::MIME"image/png`
* `::MIME"image/svg+xml`
* `::MIME"image/eps`
* `::MIME"image/jpeg`
* `::MIME"application/json"`
* `::MIME"application/json; charset=UTF-8"`

```@docs
savefig
```
!!! note
    You can also save the json for a figure by calling
    `savejson(p::Union{Plot,SyncPlot}, filename::String)`.
