Recall that the `Plotly.newPlot` javascript function expects to receive an
array of `trace` objects and, optionally, a `layout` object. In this section we
will learn how to build these object in Julia.  

## Traces

A `Plot` instance will have a vector of `trace`s. These should each be a subtype of `AbstractTrace`.

PlotlyJS.jl defines one such subtype:

```julia
type GenericTrace{T<:Associative{Symbol,Any}} <: AbstractTrace
    kind::ASCIIString
    fields::T
end
```

The `kind` field specifies the type of trace and the `fields` is an Associative object that maps trace attributes to their values.

Let's consider an example. Suppose we would like to build the following JSON
object:

```json
{
  "type": "scatter",
  "x": [1, 2, 3, 4, 5],
  "y": [1, 6, 3, 6, 1],
  "mode": "markers+text",
  "name": "Team A",
  "text": ["A-1", "A-2", "A-3", "A-4", "A-5"],
  "textposition": "top center",
  "textfont": {
    "family":  "Raleway, sans-serif"
  },
  "marker": { "size": 12 }
}
```

One way to do this in Julia is:

```julia
fields = Dict{Symbol,Any}(:type => "scatter",
                          :x => [1, 2, 3, 4, 5],
                          :y => [1, 6, 3, 6, 1],
                          :mode => "markers+text",
                          :name => "Team A",
                          :text => ["A-1", "A-2", "A-3", "A-4", "A-5"],
                          :textposition => "top center",
                          :textfont => Dict(:family =>  "Raleway, sans-serif"),
                          :marker => Dict(:size => 12))
GenericTrace("scatter", fields)
```

A more convenient syntax is:

```julia
t1 = scatter(;x=[1, 2, 3, 4, 5],
              y=[1, 6, 3, 6, 1],
              mode="markers+text",
              name="Team A",
              text=["A-1", "A-2", "A-3", "A-4", "A-5"],
              textposition="top center",
              textfont_family="Raleway, sans-serif",
              marker_size=12)
```

Notice a few things:

- The trace `type` became the function name. There is a similar method for all
plotly.js traces types.
- All other trace attributes were set using keyword arguments. This allows us
to avoid typing out the symbol prefix (`:`) and the arrows (`=>`) that were
necessary when constructing the `Dict`
- We can set nested attributes using underscores. Notice that the JSON
`"marker": { "size": 12 }` was written `marker_size=12`.

We can verify that this is indeed equivalent JSON by printing the JSON obtained
from `JSON.json(t1, 2)` which is (note the order of the attributes is different,
but the content is identical):

```json
{
  "type": "scatter",
  "y": [
    1,
    6,
    3,
    6,
    1
  ],
  "text": [
    "A-1",
    "A-2",
    "A-3",
    "A-4",
    "A-5"
  ],
  "textfont": {
    "family": "Raleway, sans-serif"
  },
  "name": "Team A",
  "x": [
    1,
    2,
    3,
    4,
    5
  ],
  "textposition": "top center",
  "mode": "markers+text",
  "marker": {
    "size": 12
  }
}
```

### Accessing attributes

If we then wanted to extract a particular attribute, we can do so using
`getindex(t1, :attrname)`, or the syntactic sugar `t1[:attrname]`. Note that
both symbols and strings can be used in a call to `getindex`:

```jlcon
julia> t1["marker"]
Dict{Any,Any} with 1 entry:
  :size => 12

julia> t1[:marker]
Dict{Any,Any} with 1 entry:
  :size => 12
```

To access a nested property use `parent.child`

```jlcon
julia> t1["textfont.family"]
"Raleway, sans-serif"
```

### Setting additional attributes

We can also set additional attributes. Suppose we wanted to set `marker.color`
to be red. We can do this with a call to `setindex!(t1, "red", :marker_color)`,
or equivalently `t1["marker_color"] = "red"`:

```jlcon
julia> t1["marker_color"] = "red"
"red"

julia> println(JSON.json(t1, 2))
{
  "type": "scatter",
  "y": [
    1,
    6,
    3,
    6,
    1
  ],
  "text": [
    "A-1",
    "A-2",
    "A-3",
    "A-4",
    "A-5"
  ],
  "textfont": {
    "family": "Raleway, sans-serif"
  },
  "name": "Team A",
  "x": [
    1,
    2,
    3,
    4,
    5
  ],
  "textposition": "top center",
  "mode": "markers+text",
  "marker": {
    "size": 12,
    "color": "red"
  }
}
```

Notice how the `color` attribute was correctly added within the existing
`marker` attribute (alongside `size`), instead of replacing the `marker`
attribute.

You can also use this syntax to add completely new nested attributes:

```jlcon
julia> t1["line_width"] = 5
5

julia> println(JSON.json(t1, 2))
{
  "type": "scatter",
  "y": [
    1,
    6,
    3,
    6,
    1
  ],
  "text": [
    "A-1",
    "A-2",
    "A-3",
    "A-4",
    "A-5"
  ],
  "textfont": {
    "family": "Raleway, sans-serif"
  },
  "name": "Team A",
  "line": {
    "width": 5
  },
  "x": [
    1,
    2,
    3,
    4,
    5
  ],
  "textposition": "top center",
  "mode": "markers+text",
  "marker": {
    "size": 12,
    "color": "red"
  }
}
```

## Layouts

The `Layout` type is defined as

```julia
type Layout{T<:Associative{Symbol,Any}} <: AbstractLayout
    fields::T
end
```

You can construct a layout using the same convenient keyword argument syntax
that we used for traces:

```jlcon
julia> l = Layout(;title="Penguins",
                   xaxis_range=[0, 42.0], xaxis_title="fish",
                   yaxis_title="Weight",
                   xaxis_showgrid=true, yaxis_showgrid=true,
                   legend_y=1.15, legend_x=0.7)
layout with fields legend, margin, title, xaxis, and yaxis


julia> println(JSON.json(l, 2))
{
  "yaxis": {
    "title": "Weight",
    "showgrid": true
  },
  "legend": {
    "y": 1.15,
    "x": 0.7
  },
  "xaxis": {
    "range": [
      0.0,
      42.0
    ],
    "title": "fish",
    "showgrid": true
  },
  "title": "Penguins",
  "margin": {
    "r": 50,
    "l": 50,
    "b": 50,
    "t": 60
  }
}
```

## `attr`

There is a special function named `attr` that allows you to apply the same
keyword magic we saw in the trace and layout functions, but to nested
attributes. Let's revisit the previous example, but use `attr` to build up our
`xaxis` and `legend`:

```jlcon
julia> l2 = Layout(;title="Penguins",
                    xaxis=attr(range=[0, 42.0], title="fish", showgrid=true),
                    yaxis_title="Weight", yaxis_showgrid=true,
                    legend=attr(x=0.7, y=1.15))
layout with fields legend, margin, title, xaxis, and yaxis


julia> println(JSON.json(l2, 2))
{
  "yaxis": {
    "title": "Weight",
    "showgrid": true
  },
  "legend": {
    "y": 1.15,
    "x": 0.7
  },
  "xaxis": {
    "range": [
      0.0,
      42.0
    ],
    "title": "fish",
    "showgrid": true
  },
  "title": "Penguins",
  "margin": {
    "r": 50,
    "l": 50,
    "b": 50,
    "t": 60
  }
}
```

Notice we got the exact same output as before, but we didn't have to resort to
building the `Dict` by hand _or_ prefixing multiple arguments with `xaxis_` or
`legend_`.
