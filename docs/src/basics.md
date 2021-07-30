## Basics

[plotly.js][_plotlyjs] figures are constructed by calling the function:

```js
Plotly.newPlot(divid, data, layout, config, frames)
```

where

- `divid` is an html `div` element where the plot should appear
- `data` is an array of JSON objects describing the various `trace`s in the visualization
- `layout` is a JSON object describing the layout properties of the visualization.
- `config` is a JSON object describing the configuration properties of the visualization. See more detail [here](https://plotly.com/javascript/configuration-options/)
- `frames` can contain data and layout objects, which define any changes to be animated, and a traces object that defines which traces to animate.

The `divid` argument is handled automatically by one of the supported
frontends, so users of this package will mostly be concerned about constructing
the `data`, `layout`, and (optionally) `config` and `frames` arguments.

For a complete list of traces and their attributes see the [plotly.js chart attribute reference][_plotlyref].

<!-- As of version 0.6.0 of this package you can also view a local version of this
page that is a bit easier to navigate by calling the `PlotlyJS.docs()` function
from the Julia prompt. This will open an electron window with a local webpage
containing a version of that reference page. -->

## Julia types

There are a handful of core Julia types for representing a visualization

These are

```julia
abstract type AbstractTrace end
abstract type AbstractLayout end

mutable struct GenericTrace{T <: AbstractDict{Symbol,Any}} <: AbstractTrace
    fields::T
end

mutable struct Layout{T <: AbstractDict{Symbol,Any}} <: AbstractLayout
    fields::T
    subplots::_Maybe{Subplots}
end

mutable struct PlotlyFrame{T <: AbstractDict{Symbol,Any}} <: AbstractPlotlyAttribute
    fields::T
end

mutable struct Plot{TT<:AbstractVector{<:AbstractTrace},TL<:AbstractLayout,TF<:AbstractVector{<:PlotlyFrame}}
    data::TT
    layout::TL
    divid::UUID
    config::PlotConfig
    frames::TF
end
```

The `data`, `layout`, `divid`, `config`, and `frames` fields of the `Plot` type map 1-1 to the arguments to the `Plotly.newplot` function.


[_plotlyjs]: https://plotly.com/javascript/
[_plotlyref]: https://plotly.com/julia/reference/
