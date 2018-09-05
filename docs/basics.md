## Basics

[plotly.js][_plotlyjs] figures are constructed by calling the function:

```js
Plotly.newPlot(graphdiv, data, layout)
```

where

- `graphdiv` is an html `div` element where the plot should appear
- `data` is an array of JSON objects describing the various `trace`s in the visualization
- `layout` is a JSON object describing the layout properties of the visualization.

The `graphdiv` argument is handled automatically by one of the supported
frontends, so users of this package will mostly be concerned about constructing
the `data` and `layout` arguments.

For a complete list of traces and their attributes see the [plotly.js chart attribute reference][_plotlyref].

<!-- As of version 0.6.0 of this package you can also view a local version of this
page that is a bit easier to navigate by calling the `PlotlyJS.docs()` function
from the Julia prompt. This will open an electron window with a local webpage
containing a version of that reference page. -->

## Julia types

There are three core types for representing a visualization (not counting the
two abstract types):

```julia
abstract type AbstractTrace end
abstract type AbstractLayout end

mutable struct GenericTrace{T<:AbstractDict{Symbol,Any}} <: AbstractTrace
    kind::ASCIIString
    fields::T
end

mutable struct Layout{T<:AbstractDict{Symbol,Any}} <: AbstractLayout
    fields::T
end

mutable struct Plot{TT<:AbstractTrace}
    data::Vector{TT}
    layout::AbstractLayout
    divid::Base.Random.UUID
end
```

The fields of the `Plot` type map 1-1 to the arguments to the `Plotly.newplot`
function


[_plotlyjs]: https://plot.ly/javascript
[_plotlyref]: https://plot.ly/javascript/reference
