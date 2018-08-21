Recall that the `Plotly.newPlot` javascript function expects to receive an
array of `trace` objects and, optionally, a `layout` object. In this section we
will learn how to build these object in Julia.  

## Traces

A `Plot` instance will have a vector of `trace`s. These should each be a subtype of `AbstractTrace`.

PlotlyJS.jl defines one such subtype:

```julia
mutable struct GenericTrace{T<:AbstractDict{Symbol,Any}} <: AbstractTrace
    kind::ASCIIString
    fields::T
end
```

The `kind` field specifies the type of trace and the `fields` is an AbstractDict object that maps trace attributes to their values.

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
mutable struct Layout{T<:AbstractDict{Symbol,Any}} <: AbstractLayout
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


## Using `DataFrame`s

!!! note
    New in version 0.6.0

You can also construct traces using the columns of any subtype of
`AbstractDataFrame` (e.g. the `DataFrame` type from DataFrames.jl).

To demonstrate this functionality let's load the famous iris data set:

```jlcon
julia> using DataFrames, RDatasets

julia> iris = dataset("datasets", "iris");

julia> head(iris)
6×5 DataFrames.DataFrame
│ Row │ SepalLength │ SepalWidth │ PetalLength │ PetalWidth │ Species  │
├─────┼─────────────┼────────────┼─────────────┼────────────┼──────────┤
│ 1   │ 5.1         │ 3.5        │ 1.4         │ 0.2        │ "setosa" │
│ 2   │ 4.9         │ 3.0        │ 1.4         │ 0.2        │ "setosa" │
│ 3   │ 4.7         │ 3.2        │ 1.3         │ 0.2        │ "setosa" │
│ 4   │ 4.6         │ 3.1        │ 1.5         │ 0.2        │ "setosa" │
│ 5   │ 5.0         │ 3.6        │ 1.4         │ 0.2        │ "setosa" │
│ 6   │ 5.4         │ 3.9        │ 1.7         │ 0.4        │ "setosa" │
```

Suppose that we wanted to construct a scatter trace with the  `SepalLength`
column as the x variable and the `SepalWidth` columns as the y variable. We
do this by calling

```jlcon
julia> my_trace = scatter(iris, x=:SepalLength, y=:SepalWidth, marker_color=:red)
scatter with fields marker, type, x, and y

julia> [my_trace[:x][1:5] my_trace[:y][1:5]]
5×2 DataArrays.DataArray{Float64,2}:
 5.1  3.5
 4.9  3.0
 4.7  3.2
 4.6  3.1
 5.0  3.6

julia> my_trace[:marker_color]
:red
```

How does this work? The basic rule is that if the value of any keyword argument
is a Julia Symbol (i.e. created with `:something`), then the function creating
the trace checks if that symbol is one of the column names in the DataFrame.
If so, it extracts the column from the DataFrame and sets that as the value
for the keyword argument. Otherwise it passes the symbol directly through.

In the above example, when we constructed `my_trace` the value of the keyword
argument `x` was set to the Symbol `:SepalLength`. This did match a column name
from `iris` so that column was extracted and replaced `:SepalLength` as the
value for the `x` argument. The same holds for `y` and `SepalWidth`.

However, when setting `marker_color=:red` we found that `:red` is not one of
the column names, so the value for the `marker_color` keyword argument remained
`:red`.

The DataFrame interface becomes more useful when constructing whole plots. See
the [convenience methods](syncplots.md#convenience-methods) section of the
documentation for more information.

!!! note
    New in version 0.9.0

As of version 0.9.0, you can construct groups of traces using the DataFrame
api. This is best understood by example, so let's see it in action:

```jlcon
julia> using RDatasets

julia> iris = dataset("datasets", "iris");

julia> unique(iris[:Species])
3-element DataArrays.DataArray{String,1}:
 "setosa"
 "versicolor"
 "virginica"

julia> traces = scatter(iris, group=:Species, x=:SepalLength, y=:SepalWidth, mode="markers", marker_size=8)
3-element Array{PlotlyJS.GenericTrace,1}:
 PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:x, [5.1, 4.9, 4.7, 4.6, 5.0, 5.4, 4.6, 5.0, 4.4, 4.9  …  5.0, 4.5, 4.4, 5.0, 5.1, 4.8, 5.1, 4.6, 5.3, 5.0]),Pair{Symbol,Any}(:mode, "markers"),Pair{Symbol,Any}(:y, [3.5, 3.0, 3.2, 3.1, 3.6, 3.9, 3.4, 3.4, 2.9, 3.1  …  3.5, 2.3, 3.2, 3.5, 3.8, 3.0, 3.8, 3.2, 3.7, 3.3]),Pair{Symbol,Any}(:type, "scatter"),Pair{Symbol,Any}(:name, "setosa"),Pair{Symbol,Any}(:marker, Dict{Any,Any}(Pair{Any,Any}(:size, 8)))))
 PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:x, [7.0, 6.4, 6.9, 5.5, 6.5, 5.7, 6.3, 4.9, 6.6, 5.2  …  5.5, 6.1, 5.8, 5.0, 5.6, 5.7, 5.7, 6.2, 5.1, 5.7]),Pair{Symbol,Any}(:mode, "markers"),Pair{Symbol,Any}(:y, [3.2, 3.2, 3.1, 2.3, 2.8, 2.8, 3.3, 2.4, 2.9, 2.7  …  2.6, 3.0, 2.6, 2.3, 2.7, 3.0, 2.9, 2.9, 2.5, 2.8]),Pair{Symbol,Any}(:type, "scatter"),Pair{Symbol,Any}(:name, "versicolor"),Pair{Symbol,Any}(:marker, Dict{Any,Any}(Pair{Any,Any}(:size, 8)))))
 PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:x, [6.3, 5.8, 7.1, 6.3, 6.5, 7.6, 4.9, 7.3, 6.7, 7.2  …  6.7, 6.9, 5.8, 6.8, 6.7, 6.7, 6.3, 6.5, 6.2, 5.9]),Pair{Symbol,Any}(:mode, "markers"),Pair{Symbol,Any}(:y, [3.3, 2.7, 3.0, 2.9, 3.0, 3.0, 2.5, 2.9, 2.5, 3.6  …  3.1, 3.1, 2.7, 3.2, 3.3, 3.0, 2.5, 3.0, 3.4, 3.0]),Pair{Symbol,Any}(:type, "scatter"),Pair{Symbol,Any}(:name, "virginica"),Pair{Symbol,Any}(:marker, Dict{Any,Any}(Pair{Any,Any}(:size, 8)))))

julia> [t[:name] for t in traces]
3-element Array{String,1}:
 "setosa"
 "versicolor"
 "virginica"
```

Notice how there are three `Species` in the `iris` DataFrame, and when passing
`group=:Species` to `scatter` we obtained three traces.

We can pass a `Vector{Symbol}` as group, to split the data on the value in more
than one column:

```jlcon
julia> tips = dataset("reshape2", "tips");

julia> unique(tips[:Sex])
2-element DataArrays.DataArray{String,1}:
 "Female"
 "Male"

julia> unique(tips[:Day])
4-element DataArrays.DataArray{String,1}:
 "Sun"
 "Sat"
 "Thur"
 "Fri"

julia> traces = violin(tips, group=[:Sex, :Day], x=:TotalBill, orientation="h")
8-element Array{PlotlyJS.GenericTrace,1}:
  PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:type, "violin"),Pair{Symbol,Any}(:name, "(Female, Fri)"),Pair{Symbol,Any}(:orientation, "h"),Pair{Symbol,Any}(:x, [5.75, 16.32, 22.75, 11.35, 15.38, 13.42, 15.98, 16.27, 10.09])))
  PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:type, "violin"),Pair{Symbol,Any}(:name, "(Female, Sat)"),Pair{Symbol,Any}(:orientation, "h"),Pair{Symbol,Any}(:x, [20.29, 15.77, 19.65, 15.06, 20.69, 16.93, 26.41, 16.45, 3.07, 17.07  …  10.59, 10.63, 12.76, 13.27, 28.17, 12.9, 30.14, 22.12, 35.83, 27.18])))
  PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:type, "violin"),Pair{Symbol,Any}(:name, "(Female, Sun)"),Pair{Symbol,Any}(:orientation, "h"),Pair{Symbol,Any}(:x, [16.99, 24.59, 35.26, 14.83, 10.33, 16.97, 10.29, 34.81, 25.71, 17.31, 29.85, 25.0, 13.39, 16.21, 17.51, 9.6, 20.9, 18.15])))
  PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:type, "violin"),Pair{Symbol,Any}(:name, "(Female, Thur)"),Pair{Symbol,Any}(:orientation, "h"),Pair{Symbol,Any}(:x, [10.07, 34.83, 10.65, 12.43, 24.08, 13.42, 12.48, 29.8, 14.52, 11.38  …  18.64, 11.87, 19.81, 43.11, 13.0, 12.74, 13.0, 16.4, 16.47, 18.78])))
  PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:type, "violin"),Pair{Symbol,Any}(:name, "(Male, Fri)"),Pair{Symbol,Any}(:orientation, "h"),Pair{Symbol,Any}(:x, [28.97, 22.49, 40.17, 27.28, 12.03, 21.01, 12.46, 12.16, 8.58, 13.42])))
  PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:type, "violin"),Pair{Symbol,Any}(:name, "(Male, Sat)"),Pair{Symbol,Any}(:orientation, "h"),Pair{Symbol,Any}(:x, [20.65, 17.92, 39.42, 19.82, 17.81, 13.37, 12.69, 21.7, 9.55, 18.35  …  15.69, 11.61, 10.77, 15.53, 10.07, 12.6, 32.83, 29.03, 22.67, 17.82])))
  PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:type, "violin"),Pair{Symbol,Any}(:name, "(Male, Sun)"),Pair{Symbol,Any}(:orientation, "h"),Pair{Symbol,Any}(:x, [10.34, 21.01, 23.68, 25.29, 8.77, 26.88, 15.04, 14.78, 10.27, 15.42  …  34.63, 34.65, 23.33, 45.35, 23.17, 40.55, 20.69, 30.46, 23.1, 15.69])))
  PlotlyJS.GenericTrace{Dict{Symbol,Any}}(Dict{Symbol,Any}(Pair{Symbol,Any}(:type, "violin"),Pair{Symbol,Any}(:name, "(Male, Thur)"),Pair{Symbol,Any}(:orientation, "h"),Pair{Symbol,Any}(:x, [27.2, 22.76, 17.29, 19.44, 16.66, 32.68, 15.98, 13.03, 18.28, 24.71  …  9.78, 7.51, 28.44, 15.48, 16.58, 7.56, 10.34, 13.51, 18.71, 20.53])))

julia> [t[:name] for t in traces]
8-element Array{String,1}:
 "(Female, Fri)"
 "(Female, Sat)"
 "(Female, Sun)"
 "(Female, Thur)"
 "(Male, Fri)"
 "(Male, Sat)"
 "(Male, Sun)"
 "(Male, Thur)"
```

Also new in version 0.9.0, when using the DataFrame API you are allowed to pass
a function as the value for a keyword argument. When the each trace is
constructed, the value will be replaced by calling the function on whatever
DataFrame is being used. When used in conjunction with the `group` argument,
this allows you to _compute_ group specific trace attributes on the fly.

See the docstring for `GenericTrace` and the `violin_side_by_side` example on
the [violin example page](examples/violin.md) more details.
