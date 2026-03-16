## Preliminaries

PlotlyJS is a Julia package that relies on the [plotly.js](https://plotly.com/javascript/) JavaScript library.

In that library, figures are constructed by calling the function:

```js
Plotly.newPlot(divid, data, layout, config, frames)
```

where

- `data` is an array of JSON objects describing the various _traces_ (see Note) in the visualization
- `layout` is a JSON object describing the layout properties of the visualization.
- `config` is a JSON object describing the configuration properties of the visualization 
    (see more detail [here](https://plotly.com/julia/configuration-options/))
- `frames` can contain data and layout objects, which define any changes to be animated, and a traces object that defines which traces to animate.

The `divid` argument is an [html `<div>` element](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/div) 
to control the plot on a page and is handled automatically by one of the supported
front-ends. Users of this package will mostly be concerned about constructing
the `data` and the `layout`, and (optionally) `config` and `frames` arguments.

!!! note
    A _trace_ is a general term for how data is shown graphically on a plot,
    whether it is a scatter plot, bar chart, 3D surface, choropleth map or something else.
    A trace is fundamentally a collection of data and the specifications of how that data should be plotted.
    For a complete list of traces and their attributes see the
    [plotly.js chart attribute reference](https://plotly.com/julia/reference/).

## Julia types

There are a handful of core Julia types for representing a visualization.

The `data`, `layout`, `frames`, `divid` and `config` fields of the `Plot` type, shown below,
map to the arguments to the `Plotly.newplot` function.
These types are defined in the PlotlyBase.jl package (a dependency of PlotlyJS.jl).
These are shown (in a simplified form) here:

```julia
abstract type AbstractTrace end
abstract type AbstractLayout end

mutable struct GenericTrace{T <: AbstractDict{Symbol,Any}} <: AbstractTrace
    fields::T
end

mutable struct Layout{T <: AbstractDict{Symbol,Any}} <: AbstractLayout
    fields::T
    subplots::Subplots
end

mutable struct PlotlyFrame{T <: AbstractDict{Symbol,Any}} <: AbstractPlotlyAttribute
    fields::T
end

mutable struct PlotConfig
    scrollZoom::Union{Nothing,Bool} = true
    editable::Union{Nothing,Bool} = false
    staticPlot::Union{Nothing,Bool} = false
...
end

mutable struct Plot
    data::Vector{<:AbstractTrace}
    layout::AbstractLayout
    frames::Vector{<:PlotlyFrame}
    divid::UUID
    config::PlotConfig
end
```

The `data` field of the `Plot` type can be a single trace or a vector of multiple traces.
Each trace is itself made up of a `Dict` type holding information about the type of trace
and its data along with attributes for customising the plotting of that data.