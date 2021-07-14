# Building Blocks

```@setup traces_layous
using PlotlyJS, JSON
```

Recall that the `Plotly.newPlot` javascript function expects to receive an
array of `trace` objects and, optionally, a `layout` object. In this section we
will learn how to build these object in Julia.

## Traces

A `Plot` instance will have a vector of `trace`s. These should each be a subtype of `AbstractTrace`.

PlotlyJS.jl defines one such subtype:

```julia
mutable struct GenericTrace{T <: AbstractDict{Symbol,Any}} <: AbstractTrace
    fields::T
end
```

The `fields` is an AbstractDict object that maps trace attributes to their values.

We create this wrapper around a Dict to provide some convnient syntax as described below.

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

```@example traces_layous
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

```@setup traces_layous
using PlotlyJS, JSON
```

```@example traces_layous
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

We can verify that this is indeed equivalent JSON by printing the JSON: (note the order of the attributes is different, but the content is identical):

```@example traces_layous
print(JSON.json(t1, 2))
```

### Accessing attributes

If we then wanted to extract a particular attribute, we can do so using
`getindex(t1, :attrname)`, or the syntactic sugar `t1[:attrname]`. Note that
both symbols and strings can be used in a call to `getindex`:

```@repl traces_layous
t1["marker"]
t1[:marker]
```

To access a nested property use `parent.child`

```@repl traces_layous
t1["textfont.family"]
```

### Setting additional attributes

We can also set additional attributes. Suppose we wanted to set `marker.color`
to be red. We can do this with a call to `setindex!(t1, "red", :marker_color)`,
or equivalently `t1["marker_color"] = "red"`:

```@repl traces_layous
t1["marker_color"] = "red"

println(JSON.json(t1, 2))
```

Notice how the `color` attribute was correctly added within the existing
`marker` attribute (alongside `size`), instead of replacing the `marker`
attribute.

You can also use this syntax to add completely new nested attributes:

```@repl traces_layous
t1["line_width"] = 5
println(JSON.json(t1, 2))
```

## Layouts

The `Layout` type is defined as

```julia
mutable struct Layout{T <: AbstractDict{Symbol,Any}} <: AbstractLayout
    fields::T
    subplots::_Maybe{Subplots}
end
```

You can construct a layout using the same convenient keyword argument syntax
that we used for traces:

```@repl traces_layous
l = Layout(;title="Penguins",
            xaxis_range=[0, 42.0], xaxis_title="fish",
            yaxis_title="Weight",
            xaxis_showgrid=true, yaxis_showgrid=true,
            legend_y=1.15, legend_x=0.7)
println(JSON.json(l, 2))
```

## `attr`

There is a special function named `attr` that allows you to apply the same
keyword magic we saw in the trace and layout functions, but to nested
attributes. Let's revisit the previous example, but use `attr` to build up our
`xaxis` and `legend`:

```@repl traces_layous
l2 = Layout(;title="Penguins",
             xaxis=attr(range=[0, 42.0], title="fish", showgrid=true),
             yaxis_title="Weight", yaxis_showgrid=true,
             legend=attr(x=0.7, y=1.15))
println(JSON.json(l2, 2))
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

```@repl traces_layous
using DataFrames, RDatasets
iris = dataset("datasets", "iris");
first(iris, 10)
```

Suppose that we wanted to construct a scatter trace with the  `SepalLength`
column as the x variable and the `SepalWidth` columns as the y variable. We
do this by calling

```@repl traces_layous
my_trace = scatter(iris, x=:SepalLength, y=:SepalWidth, marker_color=:red)
[my_trace[:x][1:5] my_trace[:y][1:5]]
my_trace[:marker_color]
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
the [convenience methods](@ref constructors) section of the
documentation for more information.

!!! note
    New in version 0.9.0

As of version 0.9.0, you can construct groups of traces using the DataFrame
api. This is best understood by example, so let's see it in action:

```@repl traces_layous
iris = dataset("datasets", "iris");
unique(iris[:Species])
traces = scatter(
    iris, group=:Species, x=:SepalLength, y=:SepalWidth, mode="markers", marker_size=8
)
[t[:name] for t in traces]
```

Notice how there are three `Species` in the `iris` DataFrame, and when passing
`group=:Species` to `scatter` we obtained three traces.

We can pass a `Vector{Symbol}` as group, to split the data on the value in more
than one column:

```@repl traces_layous
tips = dataset("reshape2", "tips");
unique(tips[:Sex])
unique(tips[:Day])
traces = violin(tips, group=[:Sex, :Day], x=:TotalBill, orientation="h")
[t[:name] for t in traces]
```

Also new in version 0.9.0, when using the DataFrame API you are allowed to pass
a function as the value for a keyword argument. When the each trace is
constructed, the value will be replaced by calling the function on whatever
DataFrame is being used. When used in conjunction with the `group` argument,
this allows you to _compute_ group specific trace attributes on the fly.

See the docstring for `GenericTrace` and the `violin_side_by_side` example on
the [Violin](@ref) example page more details.

### Facets

!!! note
    New in PlotlyBase version 0.6.5 (PlotlyJS version 0.16.4)

When plotting a `DataFrame` (let's call it `df`), the keyword arguments `facet_row` and `facet_col` allow you to create a matrix of subplots. The rows of this matrix correspond `unique(df[:facet_row])`, where `:facet_row` is a placeholder for the actual value passed as the `facet_row` argument. Similarly, the columns of the matrix of subplots come from `unique(df[:facet_col])`.

Each subplot will have the same structure, as defined by the keyword arguments passed to `plot`, but will only show data for a single value of `facet_row` and `facet_col` at a time.

Below is an example of how this works

```@repl facets
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "tips")

plot(
    df, x=:total_bill, y=:tip, xbingroyp="x", ybingroup="y", kind="histogram2d",
    facet_row=:sex, facet_col=:smoker
)
```
