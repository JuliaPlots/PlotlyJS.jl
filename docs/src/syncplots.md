# Putting it together

```@meta
CurrentModule = PlotlyJS
```

We will now look at how to combine traces and a layout to create a plot.

We'll also discuss how to integrate with various front-ends.

## `Plot`

The full definition of the `Plot` object is

```julia
mutable struct Plot{TT<:AbstractVector{<:AbstractTrace},TL<:AbstractLayout,TF<:AbstractVector{<:PlotlyFrame}}
    data::TT
    layout::TL
    frames::TF
    divid::UUID
    config::PlotConfig
end
```

Given one or more traces (with a subtypes of `AbstractTrace`) and optionally a `Layout`, we construct a
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

Notice that none of the recommended constructors require you to pass the `divid`
field manually (this is an internal field to enable the
unique identification and display of multiple plots in a single web page).

### [Convenience methods](@id constructors)

There are also a number of convenience methods to the `Plot` function that will
attempt to construct the traces for you. The following signatures
show the variety of arguments that can be used to create a plot:

```@docs
PlotlyBase.Plot
```

Here are some examples:

```@example plot_methods
using PlotlyJS
p0 = Plot([0, 1, 3], [10, 5, 2])
plot(p0)
```

```@example plot_methods
t = range(0, 3, 41);
p1 = Plot(t, [2sin.(t) 3cos.(t) cos.(t).-sin.(t)], Layout(showlegend=true))
plot(p1)
```

```@example plot_methods
p2 = Plot(x -> (x - 0.6)^2, -2, 2, Layout(showlegend=false))
plot(p2)
```

```@example plot_methods
p3 = Plot([sin, cos], 0, 2*pi)
plot(p3)
```

Especially convenient is the `group` keyword argument when calling
`Plot(::AbstractDataFrame, ... ; ...)`. Here is an example below:

```@example iris_group
using PlotlyJS  # hide
using RDatasets
iris = RDatasets.dataset("datasets", "iris");
p = Plot(iris, x=:SepalLength, y=:SepalWidth, mode="markers", marker_size=8,
         group=:Species,
         Layout(title="Iris Species"))
plot(p)
```

See the section on [Groups](@ref) for more detail.

## `SyncPlot`s

A `Plot` is a pure Julia object and doesn't interact with plotly.js by itself.
This means that we can't view the actual plotly figure that the data represents
until we have a way to display it to the screen.

To do that we need to link the `Plot` to one or more display front-ends.
The (lowercase) `plot()` function is used to set up the link.

To actually connect to the display front-ends we use the
[WebIO.jl](https://github.com/JuliaGizmos/WebIO.jl) package. Our interaction
with WebIO is wrapped up in a type called `SyncPlot` that is defined as
follows:

```julia
mutable struct SyncPlot
    plot::PlotlyBase.Plot
    scope::Scope
    window::Union{Nothing,Blink.Window}
end
```

As its name suggests, a `SyncPlot` will keep the Julia representation of a
plot (the `Plot` instance) in sync with a plot with a front-end.
The `scope` field refers to a `WebIO.Scope` object used for passing messages 
between Julia and JavaScript.

!!! note
    The `Plot` function will create a new `Plot` object while the `plot` function
    will create a new `SyncPlot`. The `plot` function passes all arguments
    to construct a `Plot` and then sets up the display.
    All `Plot` methods are also defined for `plot`.

By leveraging WebIO.jl we can render our figures anywhere WebIO can render. At
time of writing this includes [Jupyter notebooks](https://jupyter.org/),
[Jupyterlab](https://github.com/jupyterlab/jupyterlab),
[Mux.jl](https://github.com/JuliaWeb/Mux.jl) web apps, and
Electron windows from [Blink.jl](https://github.com/JuliaGizmos/Blink.jl).
Please see the 
[WebIO.jl documentation](https://juliagizmos.github.io/WebIO.jl/latest/gettingstarted/)
for additional information.

When using PlotlyJS.jl at the Julia REPL a plot will automatically be displayed
in two possible ways. 
1. A `Plot()` call will create a temporary HTML file with the plot embedded inside.
PlotlyJS.jl code will then try to launch the application that handles `.html`
files on the user's computer, typically their default browser.
2. A `plot()` call will launch a new Electron window. This is a dedicated
browser window we have full control over. To see a plot `p`, just type `p` by
itself at the REPL and execute the line. Alternatively you can call `display(p)`.

In addition to being able to see our charts in many front-end environments,
WebIO also provides a two-way communication bridge between JavaScript and Julia.
In fact, when a `SyncPlot` is constructed, we automatically get listeners for
all [plotly.js javascript events](https://plotly.com/javascript/plotlyjs-events/).


What's more is that we can hook up Julia functions as callbacks when those
events are triggered. In the very contrived example below we have Julia print
out details regarding points on a plot whenever a user hovers over them on the
display:

```julia
using PlotlyJS
using PlotlyJS: WebIO
p = plot(rand(10, 4));
display(p)  # usually optional

WebIO.on(p["hover"]) do data
    if haskey(data, "points")
        pt = first(data["points"])
        println("\nYou hovered over the point x=", pt["x"], ", y=", pt["y"])
    end
end
```

In this next example, whenever we click on a point we change its marker symbol
to a star and marker color to gold:

```julia
using PlotlyJS
using PlotlyJS: WebIO
colors = (fill("red", 10), fill("blue", 10))
symbols = (fill("circle", 10), fill("circle", 10))
ys = (rand(10), rand(10))
p = plot(
    [scatter(y=y, marker=attr(color=c, symbol=s, size=15), line_color=c[1])
    for (y, c, s) in zip(ys, colors, symbols)]
)
display(p)  # usually optional

WebIO.on(p["click"]) do data
    colors = (fill("red", 10), fill("blue", 10))
    symbols = (fill("circle", 10), fill("circle", 10))
    for point in data["points"]
        colors[point["curveNumber"] + 1][point["pointIndex"] + 1] = "gold"
        symbols[point["curveNumber"] + 1][point["pointIndex"] + 1] = "star"
    end
    restyle!(p, marker_color=colors, marker_symbol=symbols)
end
```

While mostly nonsensical, hopefully these examples show you that it is
possible to build rich, interactive, web-based data visualization applications
with business logic implemented entirely in Julia!.

## Display configuration

!!! note
    New in PlotlyBase version 0.6.4 (PlotlyJS version 0.16.3)


When calling `plot` or `Plot`, we can specify some configuration options
using the `config` keyword argument.

The `config` argument must be set to an instance of `PlotConfig`,
which should be constructed using keyword arguments.

As an example, if we were to execute the following code, we would see a static
chart (no hover information or ability to zoom/pan) with 4 lines instead of an
interactive one:

```example plot_config
Plot(rand(10, 4), config=PlotConfig(staticPlot=true))
```

See the API docs for [`PlotConfig`](@ref) for a full list of options.
