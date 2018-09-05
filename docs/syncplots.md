We will now look at how to combine traces and a layout to create a plot.

We'll also discuss how to integrate with various frontends

## `Plot`

Recall that the definition of the `Plot` object is

```julia
mutable struct Plot{TT<:AbstractTrace}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
end
```

Given one or more `AbstractTrace`s and optionally a `layout`, we construct a
`Plot` object with any of the following constructors

```julia
# A blank canvas no traces or a layout
Plot()

# A vector of traces and a layout
Plot{T<:AbstractTrace}(data::AbstractVector{T}, layout::AbstractLayout)

# A vector of traces -- default layout supplied
Plot{T<:AbstractTrace}(data::AbstractVector{T})

# a single trace: will be put into a vector -- default layout supplied
Plot(data::AbstractTrace)

# a single trace and a layout (trace put into a vector)
Plot(data::AbstractTrace, layout::AbstractLayout)
```

Notice that none of the recommended constructors have you pass the `divid`
field manually. This is an internal field used to allow the display and
unique identification of multiple plots in a single web page.

### Convenience methods

There are also a number of convenience methods to the `Plot` function that will
attempt to construct the traces for you. They have the following signatures

```julia
# Build a trace of type `kind` from x and y -- apply all kwargs to this trace
Plot(x::AbstractVector, y::AbstractVector, l::Layout=Layout(); kind="scatter", kwargs...)

# Build one trace of type `kind` for each column of the matrix `y`. Repeat the
# `x` argument for all traces. Apply `kwargs` identically to all traces
Plot(x::AbstractVector, y::AbstractMatrix, l::Layout=Layout(); kind="scatter", kwargs...)

# For `x` and `y` with the same number of columns, build one trace of type
# `kind` for each column pair, applying all `kwargs` identically do all traces
Plot(x::AbstractMatrix, y::AbstractMatrix, l::Layout=Layout(); kind="scatter", kwargs...)

# For any array of eltype `_Scalar` (really data, see PlotlyJS._Scalar), call
# the method `Plot(1:size(y, 1), y, l; kwargs...)` described above
Plot{T<:_Scalar}(y::AbstractArray{T}, l::Layout=Layout(); kwargs...)

# Create one trace by applying `f` at 50 evenly spaced points from `x0` to `x1`
Plot(f::Function, x0::Number, x1::Number, l::Layout=Layout(); kwargs...)

# Create one trace for each function `f ∈ fs` by applying `f` at 50 evenly
# spaced points from `x0` to `x1`
Plot(fs::AbstractVector{Function}, x0::Number, x1::Number, l::Layout=Layout(); kwargs...)

# Construct one or more traces using data from the DataFrame `df` when possible
# If `group` is a symbol and that symbol matches one of the column names of
# `df`, make one trace for each unique value in the column `df[group]` (see
# example below)
Plot(df::AbstractDataFrame, l::Layout=Layout(); group=nothing, kwargs...)

# Use the column `df[x]` as the x value on each trace. Similar for `y`
Plot(df::AbstractDataFrame, x::Symbol, y::Symbol, l::Layout=Layout(); group=nothing, kwargs...)

# Use the column `df[y]` as the y value on each trace
Plot(df::AbstractDataFrame, y::Symbol, l::Layout=Layout(); group=nothing, kwargs...)
```

For more information on how these methods work please see the docstring for the
`Plot` function by calling `?Plot` from the REPL.

Especially convenient is the `group` keyword argument when calling
`Plot(::AbstractDataFrame, ... ; ...)`. Here is an example below:

```jlcon
julia> using RDatasets

julia> iris = dataset("datasets", "iris");

julia> p = Plot(iris, x=:SepalLength, y=:SepalWidth, mode="markers", marker_size=8, group=:Species)
data: [
  "scatter with fields marker, mode, name, type, x, and y",
  "scatter with fields marker, mode, name, type, x, and y",
  "scatter with fields marker, mode, name, type, x, and y"
]

layout: "layout with field margin"

```

which would result in the following plot

<div id="96cd7dc8-c066-4ffe-b09e-952ba53e14bf" class="plotly-graph-div"></div>

<script>
window.PLOTLYENV=window.PLOTLYENV || {};
window.PLOTLYENV.BASE_URL="https://plot.ly";
Plotly.newPlot('96cd7dc8-c066-4ffe-b09e-952ba53e14bf', [{"y":[3.5,3.0,3.2,3.1,3.6,3.9,3.4,3.4,2.9,3.1,3.7,3.4,3.0,3.0,4.0,4.4,3.9,3.5,3.8,3.8,3.4,3.7,3.6,3.3,3.4,3.0,3.4,3.5,3.4,3.2,3.1,3.4,4.1,4.2,3.1,3.2,3.5,3.6,3.0,3.4,3.5,2.3,3.2,3.5,3.8,3.0,3.8,3.2,3.7,3.3],"name":"setosa","type":"scatter","x":[5.1,4.9,4.7,4.6,5.0,5.4,4.6,5.0,4.4,4.9,5.4,4.8,4.8,4.3,5.8,5.7,5.4,5.1,5.7,5.1,5.4,5.1,4.6,5.1,4.8,5.0,5.0,5.2,5.2,4.7,4.8,5.4,5.2,5.5,4.9,5.0,5.5,4.9,4.4,5.1,5.0,4.5,4.4,5.0,5.1,4.8,5.1,4.6,5.3,5.0],"marker":{"size":8},"mode":"markers"},{"y":[3.2,3.2,3.1,2.3,2.8,2.8,3.3,2.4,2.9,2.7,2.0,3.0,2.2,2.9,2.9,3.1,3.0,2.7,2.2,2.5,3.2,2.8,2.5,2.8,2.9,3.0,2.8,3.0,2.9,2.6,2.4,2.4,2.7,2.7,3.0,3.4,3.1,2.3,3.0,2.5,2.6,3.0,2.6,2.3,2.7,3.0,2.9,2.9,2.5,2.8],"name":"versicolor","type":"scatter","x":[7.0,6.4,6.9,5.5,6.5,5.7,6.3,4.9,6.6,5.2,5.0,5.9,6.0,6.1,5.6,6.7,5.6,5.8,6.2,5.6,5.9,6.1,6.3,6.1,6.4,6.6,6.8,6.7,6.0,5.7,5.5,5.5,5.8,6.0,5.4,6.0,6.7,6.3,5.6,5.5,5.5,6.1,5.8,5.0,5.6,5.7,5.7,6.2,5.1,5.7],"marker":{"size":8},"mode":"markers"},{"y":[3.3,2.7,3.0,2.9,3.0,3.0,2.5,2.9,2.5,3.6,3.2,2.7,3.0,2.5,2.8,3.2,3.0,3.8,2.6,2.2,3.2,2.8,2.8,2.7,3.3,3.2,2.8,3.0,2.8,3.0,2.8,3.8,2.8,2.8,2.6,3.0,3.4,3.1,3.0,3.1,3.1,3.1,2.7,3.2,3.3,3.0,2.5,3.0,3.4,3.0],"name":"virginica","type":"scatter","x":[6.3,5.8,7.1,6.3,6.5,7.6,4.9,7.3,6.7,7.2,6.5,6.4,6.8,5.7,5.8,6.4,6.5,7.7,7.7,6.0,6.9,5.6,7.7,6.3,6.7,7.2,6.2,6.1,6.4,7.2,7.4,7.9,6.4,6.3,6.1,7.7,6.3,6.4,6.0,6.9,6.7,6.9,5.8,6.8,6.7,6.7,6.3,6.5,6.2,5.9],"marker":{"size":8},"mode":"markers"}],
          {"margin":{"r":50,"l":50,"b":50,"t":60}}, {showLink: false});

</script>

## `SyncPlot`s

A `Plot` is a pure Julia object and doesn't interact with plotly.js by itself.
This means that we can't view the actual plotly figure the data represents.

To do that we need to link the `Plot` to one or more display frontends.

To actually connect to the display frontends we use the
[WebIO.jl](https://github.com/JuliaGizmos/WebIO.jl) package. Our interaction
with WebIO is wrapped up in a type called `SyncPlot` that is defined as
follows:

```julia
mutable struct SyncPlot
    plot::PlotlyBase.Plot
    scope::Scope
    events::Dict
    options::Dict
end
```

As its name suggests, a `SyncPlot` will keep the Julia representation of the a
plot (the `Plot` instance) in sync with a plot with a frontend.

!!! note
    The `Plot` function will create a new `Plot` object and the `plot` function
    will create a new `SyncPlot`. The `plot` function passes all arguments
    (except the `options` keyword argument -- see below) to construct a `Plot`
    and then sets up the display. All `Plot` methods are also defined for
    `plot`

By leveraging WebIO.jl we can render our figures anywhere WebIO can render. At
time of writing this includes [Jupyter notebooks](http://jupyter.org/),
[Jupyterlab](https://github.com/jupyterlab/jupyterlab),
[Mux.jl](https://github.com/JuliaWeb/Mux.jl) web apps, the
[Juno](http://junolab.org/) Julia environment inside the Atom text editor, and
Electron windows from [Blink.jl](https://github.com/JunoLab/Blink.jl). Please
see the [WebIO.jl readme]((https://github.com/JuliaGizmos/WebIO.jl)) for
additional (and up to date!) information.

When using PlotlyJS.jl at the Julia REPL a plot will automatically be displayed
in an Electron window. This is a dedicated browser window we have full control
over. To see a plot `p`, just type `p` by itself at the REPL and execute the
line. Alternatively you can call `display(p)`.

In addition to being able to see our charts in many front-end environments,
WebIO also provides a 2-way communication bridge between javascript and Julia.
In fact, when a `SyncPlot` is constructed, we automatically get listeners for
all [plotly.js javascript events](https://plot.ly/javascript/plotlyjs-events/).
What's more is that we can hook up Julia functions as callbacks when those
events are triggered. In the very contrived example below we have Julia print
out details regarding points on a plot whenever a user hovers over them on the
display:

```julia
using WebIO
p = plot(rand(10, 4));
display(p)  # usually optional

on(p["hover"]) do data
    println("\nYou hovered over", data)
end
```

In this next example, whenever we click on a point we change its marker symbol
to a star and marker color to gold:

```julia
using WebIO
colors = (fill("red", 10), fill("blue", 10))
symbols = (fill("circle", 10), fill("circle", 10))
ys = (rand(10), rand(10))
p = plot(
    [scatter(y=y, marker=attr(color=c, symbol=s, size=15), line_color=c[1])
    for (y, c, s) in zip(ys, colors, symbols)]
)
display(p)  # usually optional

on(p["click"]) do data
    colors = (fill("red", 10), fill("blue", 10))
    symbols = (fill("circle", 10), fill("circle", 10))
    for point in data["points"]
        colors[point["curveNumber"] + 1][point["pointIndex"] + 1] = "gold"
        symbols[point["curveNumber"] + 1][point["pointIndex"] + 1] = "star"
    end
    restyle!(p, marker_color=colors, marker_symbol=symbols)
end
```

While completely nonsensical, hopefully these examples show you that it is
possible to build rich, interactive, web-based data visualization applications
with business logic implemented entirely in Julia!.

### Display configuration

When calling `plot` the `options` keyword argument is given special treatment.
It should be an instance of `AbstractDict` and its contents are passed as
display options to the plotly.js library. For details on which options are
supported, see the [plotly.js documentation on the
subject](https://plot.ly/javascript/configuration-options/).

As an example, if we were to execute the following code, we would see a static
chart (no hover information or ability to zoom/pan) with 4 lines instead of an
interactive one:

```
plot(rand(10, 4), options=Dict(:staticPlot => true))
```
