We will now look at how to combine traces and a layout to create a plot.

We'll also discuss how to integrate with various frontends

## `Plot`

Recall that the definition of the `Plot` object is

```julia
type Plot{TT<:AbstractTrace}
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
Plot{T<:AbstractTrace}(data::AbstrractVector{T}, layout::AbstractLayout)

# A vector of traces -- default layout supplied
Plot{T<:AbstractTrace}(data::AbstrractVector{T})

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

To do this in a simple and reliable way we introduce the concept of a
`SyncPlot`, which is defined as:

```julia
abstract AbstractPlotlyDisplay

immutable SyncPlot{TD<:AbstractPlotlyDisplay}
    plot::Plot
    view::TD
end
```

As its name suggests, a `SyncPlot` will sync a plot with a frontend. To see the
figure behind a `SyncPlot` named `p` you can simply call `display(p)`.
The `display` of a `SyncPlot` follows the standard Julia mechanisms and
`display` called automatically if you ask Julia to echo back a `SyncPlot` at
the REPL or in a Jupyter notebook.

!!! note
    The `Plot` function will create a new `Plot` object and the `plot` function
    will create a new `SyncPlot`. Which frontend is selected will depend on
    context: if the Jupyter notebook is active the `JupyterDisplay` is chosen,
    otherwise the `ElectronDisplay` will be used. The `plot` function simply
    constructs a `Plot` object and picks a default display by wrapping the
    `Plot`in a `SyncPlot`. All methods for `Plot` apply similarly to `plot`

As of the time of writing there are two supported frontends...

### `ElectronPlot`

The first subtype of `AbstractPlotlyDisplay` is `ElectronDisplay`. This display
will utilize [Blink.jl](https://github.com/JunoLab/Blink.jl) to create a
dedicated display GUI for PlotlyJS using GitHub's
[Electron](http://electron.atom.io).

By hooking into Electron, we have full 2-way communication between Julia and
javascript. We are able to evaluate arbitrary javascript expressions as if we
were entering them at the browser's devtools javascript console. The output of
evaluated expressions can be returned to Julia and re-constructed into Julia
datatypes.

This enables many features:

- Updating attributes on a trace or the layout
- Extending a trace by adding new attributes or appending to existing
attributes
- Asking plotly.js to return the raw svg data for the plot, so we can further
process it and save to pdf, png, jpeg, or eps files
- A steaming workflow where we can efficiently update portions of the plot
- (_Not implemented yet_) using Julia functions as callbacks to
[plotly.js events](https://plot.ly/javascript/#chart-events)

This is the most feature complete frontend and is a key feature of this
package.

A convenient typealias has been defined for `SyncPlot`s with the
`ElectronDisplay` frontend:

```julia
typealias ElectronPlot SyncPlot{ElectronDisplay}
```

Please note that the Electron frontend also allows PlotlyJS.jl figures to be
displayed inside the Atom text editor when using the
[atom-julia-client](https://github.com/JunoLab/atom-julia-client) environment.

### `JupyerPlot`

We also have `JupyterDisplay <: AbstractPlotlyDisplay`, which can be used to
display PlotlyJS figures in Jupyter notebooks. Because the notebook is inside
a running web browser we can make arbitrary calls to plotly.js, enabling many
of the features above.

However, communication within the notebook is only Julia -> javascript right
now. This means that we have not implemented features that require Julia to
receive a return value from javascript. This includes obtaining raw svg data
for the plot as well as registering Julia functions as callbacks.

A `SyncPlot` with a `JupyterDisplay` also has a typealias:

```julia
typealias JupyterPlot SyncPlot{JupyterDisplay}
```

Please note that the `JupyterPlot` frontend also allows PlotlyJS.jl figures to
be viewed inside the Atom text editor when using the
[hydrogen](https://github.com/nteract/hydrogen) package and inside the [nteract
notebook](https://nteract.io).

!!! note
    2 way communication between javascript and Julia is possible in the
    notebook, it just has not been implemented
