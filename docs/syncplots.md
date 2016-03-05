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
Plot{T<:AbstractTrace}(data::Vector{T}, layout::AbstractLayout)

# A vector of traces -- default layout supplied
Plot{T<:AbstractTrace}(data::Vector{T})

# a single trace: will be put into a vector -- default layout supplied
Plot(data::AbstractTrace)

# a single trace and a layout (trace put into a vector)
Plot(data::AbstractTrace, layout::AbstractLayout)
```

Notice that none of the recommended constructors have you pass the `divid`
field manually. This is an internal field used to allow the display and
unique identification of multiple plots in a single web page.

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

**Note:** 2 way communication between javascript and Julia is possible in the
notebook, it just has not been implemented
