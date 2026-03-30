# Building blocks

```@setup traces_layouts
using PlotlyJS
import JSON
```

In [Preliminaries](@ref) we saw that the `Plotly.newPlot` javascript function
expects to receive an array of `trace` objects and, optionally, a `layout` object. 

In this section we will learn how to build the trace and layout objects in Julia
that make up the core elements of a plot.


## Traces

A `Plot` instance will have a single trace or a vector of traces. 
These should each be a subtype of `AbstractTrace`.

PlotlyBase.jl provides one such general-purpose subtype `GenericTrace`
defined as

```julia
mutable struct GenericTrace{T <: AbstractDict{Symbol,Any}} <: AbstractTrace
    fields::T
end
```

Here `fields` is an `AbstractDict` object that pairs a trace's attributes to their values.
The `GenericTrace` subtype allows us to generically include data to describe the appearance
of a trace, such as point locations, marker shape and size, text annotations and more.
The reason we create a `GenericTrace` as a wrapper around a `Dict` is to provide some convenient syntax,
as described below.

Let's consider an example.

!!! note
    The next example can be used as a guide to translating examples using
    the plotly.js JavaScript library to their equivalent Julia versions.

Suppose we would like to build a `Plot` to include a `scatter`-type trace
as described here using [JSON](https://developer.mozilla.org/en-US/docs/Glossary/JSON):

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

One way to do this in Julia is to create an equivalent dictionary:

```@example traces_layouts
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

A more convenient approach uses the syntax of the `scatter` function:

```@example traces_layouts
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
  necessary when constructing the `Dict`.
- We can set nested attributes using underscores. Notice that the JSON
  `"marker": { "size": 12 }` was written `marker_size=12`.

We can verify that this is indeed equivalent JSON by printing the JSON.
Note the order of the attributes is different, but the content is identical:

```@example traces_layouts
import JSON

print(JSON.json(t1, 2))
```

### Accessing attributes

If we then wanted to extract a particular attribute, we can do so using
`getindex(t1, :attrname)`, or more directly, `t1[:attrname]`. Note that
both symbols and strings can be used in a call to `getindex`:

```@repl traces_layouts
t1["marker"]
t1[:marker]
```

To access a nested property use a string of the form `parent.child`

```@repl traces_layouts
t1["textfont.family"]
```

or nested dictionaries

```@repl traces_layouts
t1[:textfont][:family]
```

!!! warn
    Nested dictionaries will error on missing symbol keys, however using 
    unrecognised or unassigned strings as keys will return empty dictionaries.
    For example,
    ```@repl traces_layouts
    t1[:textfont][:color]
    ```
    returns an error while
    ```@repl traces_layouts
    t1["textfont.color"]
    ```
    is an empty `Dict`.

### Setting additional attributes

We can also set additional attributes. Suppose we wanted to set `marker.color`
to be red. We can do this with a call to `setindex!(t1, "red", :marker_color)`,
or equivalently `t1["marker_color"] = "red"`:

```@repl traces_layouts
t1["marker_color"] = "red"

println(JSON.json(t1, 2))
```

Notice how the `color` attribute was correctly added within the existing
`marker` attribute (alongside `size`), instead of replacing the `marker`
attribute.

You can also use this syntax to add completely new nested attributes:

```@repl traces_layouts
t1["line_width"] = 5
println(JSON.json(t1, 2))
```

## Layouts

The `Layout` type is defined as

```julia
mutable struct Layout{T <: AbstractDict{Symbol,Any}} <: AbstractLayout
    fields::T
    subplots::Subplots
end
```

You can construct a layout using the same convenient keyword argument syntax
that we used for traces:

```@repl traces_layouts
l = Layout(;title="Penguins",
            xaxis_range=[0, 42.0], 
            xaxis_title="Fish Count",
            yaxis_title="Weight",
            xaxis_showgrid=true,
            yaxis_showgrid=true,
            legend_x=0.7, legend_y=1.15,)
```

Here we set different attributes for determining the non-data layout of the plot
such as the `range` and `title` of the horizontal (`xaxis`) and vertical (`yaxis`) axes
of the plot, whether the grid lines are drawn and the position of the legend.

!!! note
    A _layout_ is a general term for how non-data elements are displayed on a plot.
    There is only one layout object used for any given plot (while we may have multiple traces).
    For a complete list of layout attributes see the
    [layout reference documentation](https://plotly.com/julia/reference/layout/).


## The `attr` function

There is a special function named `attr` that allows you to apply the same
keyword magic we saw in the trace and layout functions with underscores,
but to nested attributes at the same level.

Let's revisit the previous example, but use `attr` to build up our
`xaxis` or `legend` attributes in a way that groups things together:

```@repl traces_layouts
l2 = Layout(;title="Penguins",
             xaxis=attr(range=[0, 42.0], title="Fish Count", showgrid=true),
             yaxis_title="Weight", yaxis_showgrid=true,
             legend=attr(x=0.7, y=1.15))
```

Notice we obtain exactly the same layout as before, but we didn't have to resort to
building a `Dict` by hand _or_ prefixing multiple arguments with `xaxis_` or
`legend_`. Notice also that we can mix the different approaches in the one object.


## Using `DataFrame`s

!!! note
    DataFrame support was added in version 0.6.0.

You can also construct traces using the columns of any subtype of
`AbstractDataFrame`, such as the `DataFrame` type from the DataFrames.jl
package in particular.

To demonstrate this functionality let's load the well-known "iris" data set:

```@repl traces_layouts
using DataFrames
import RDatasets

iris = RDatasets.dataset("datasets", "iris");
first(iris, 10)
```

Suppose that we wanted to construct a scatter trace with the `SepalLength`
column as the `x` variable and the `SepalWidth` columns as the `y` variable.
We do this by calling `scatter()` with a dataframe as the first argument:

```@repl traces_layouts
my_trace = scatter(iris, x=:SepalLength, y=:SepalWidth, marker_color=:red)
```

How does this work? The basic rule is that if the value of any keyword argument
is a Julia `Symbol` (i.e. starting with `:`, such as `:one`), then the function creating
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

We can access and inspect the values of the resulting trace object:
```@repl traces_layouts
[my_trace[:x][1:5] my_trace[:y][1:5]]
my_trace[:marker_color]
```

The DataFrame interface becomes more useful when constructing whole plots. See
the [convenience methods](@ref constructors) section of the
documentation for more information.


### Groups

!!! note
    New in version 0.9.0:

You can construct _groups of traces_ using the DataFrame interface
through the `group` keyword.
This is best understood by example, so let's see it in action:

```@repl traces_layouts
iris = RDatasets.dataset("datasets", "iris");
unique(iris[:,:Species])
traces = scatter(
    iris, group=:Species, x=:SepalLength, y=:SepalWidth, mode="markers", marker_size=8
)
[t[:name] for t in traces]
```

Notice how there are three `Species` in the `iris` DataFrame, and by passing
`group=:Species` to `scatter` we obtained three traces.

We can pass a `Vector{Symbol}` with the `group` keyword, to split the data according
to the values of more than one column. 

Here we split data by day of the week and time:

```@repl traces_layouts
tips = RDatasets.dataset("reshape2", "tips");
unique(tips[:,:Sex])
unique(tips[:,:Day])
traces = violin(tips, group=[:Day, :Time], x=:TotalBill, orientation="h")
[t[:name] for t in traces]
```

### Functions

When using the DataFrame interface you may pass
a function as the value for a keyword argument. When each trace is
constructed, the value will be replaced by calling the function on whatever
DataFrame is being used. When used in conjunction with the `group` argument,
this allows you to _compute_ group specific trace attributes on the fly,
such as dynamically annotating a plot based on the data.
For example, you might want to show the sample length with the `text` attribute:

```
text=(df) -> "Sample length $(size(df, 1))"
```

See the docstring for `GenericTrace` and the `violin_side_by_side` example on
the [Violin](@ref) example page more details.

### Facets

!!! note
    New in PlotlyBase version 0.6.5 / PlotlyJS version 0.16.4:

A _facet_ is another name for a plot displaying a subset of a larger dataset.

When plotting a `DataFrame` (let's call it `df`), the keyword arguments
`facet_row` and `facet_col` allow you to create a _matrix_ of [subplots](@ref Subplots).

The rows of this matrix correspond to the array `unique(df[:facet_row])`,
where `:facet_row` is a placeholder for the actual symbol passed as the `facet_row` argument.
Similarly, the columns of the matrix of subplots come from `unique(df[:facet_col])`.

Each subplot will have the same structure, as defined by the keyword arguments passed to `plot`,
but will only show data for a single value of `facet_row` and `facet_col` at a time.

Below is an example of how this works. We have a distinction of Male and Female between rows
and a distinction of Smoker or Non-Smoker between columns, creating a two-by-two matrix of
four plots:

```@repl facets
using PlotlyJS
using DataFrames

df = PlotlyJS.dataset(DataFrame, "tips")

plot(
    df, x=:total_bill, y=:tip, xbingroup="x", ybingroup="y", kind="histogram2d",
    facet_row=:sex, facet_col=:smoker
)
```
