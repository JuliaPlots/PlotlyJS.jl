## Scatter Trace Type

The scatter trace type can be used to represent scatter charts (one point or marker per observation), line charts (a line drawn between each point), or bubble charts (points with size proportional to a dimension of the observation).

To draw a scatter chart, use the `scatter` trace type and set the `mode` parameter to `markers`.

```@example
using PlotlyJS
# x and y given as arrays
plot(scatter(x=1:10, y=rand(10), mode="markers"))
```

```@example
# x and y given as DataFrame columns
using PlotlyJS, RDatasets
df = RDatasets.dataset("datasets", "iris")
plot(scatter(df, x=:SepalWidth, y=:SepalLength, mode="markers"))
```

#### Set size and color with column names

Note that you can set `marker_size` via column name and generate multiple traces using `group`.

```@example
using PlotlyJS, DataFrames

df = PlotlyJS.dataset(DataFrame, "iris")
plot(df, x=:sepal_width, y=:sepal_length, color=:species,
	marker=attr(size=:petal_length, sizeref=maximum(df.petal_length) / (20^2), sizemode="area"),
	mode="markers")
```

## Line plots

By setting `mode` to `lines`, you can draw a line chart.

```@example
using PlotlyJS
t = 0:0.01:2π
plot(scatter(x=t, y=cos.(t), mode="lines"),
    Layout(yaxis_title="cos(t)", xaxis_title="t"))
```

You can also plot functions directly:

```@example
using PlotlyJS
plot(cos, 0, 2π, mode="lines", Layout(title="cos(t)"))
```

As well as DataFrames:

```@example
using PlotlyJS, DataFrames

df = dataset(DataFrame, "gapminder")
df_ocean = df[df.continent .== "Oceania", :]
plot(df_ocean, x=:year, y=:lifeExp, color=:country, mode="lines")
```

#### Line and Scatter Plots

Use `mode` argument to choose between markers, lines, or a combination of both.

```@example
using PlotlyJS, Random

Random.seed!(42)

N = 100
random_x = range(0, stop=1, length=N)
random_y0 = randn(N) .+ 5
random_y1 = randn(N)
random_y2 = randn(N) .- 5

plot([scatter(x=random_x, y=random_y0, mode="markers", name="markers"),
      scatter(x=random_x, y=random_y1, mode="lines", name="lines"),
      scatter(x=random_x, y=random_y2, mode="markers+lines", name="markers+lines")])
```

#### Bubble Scatter Plots

In [bubble charts](https://en.wikipedia.org/wiki/Bubble_chart), a third dimension of the data is shown through the size of markers. For more examples, see the [bubble chart docs](https://plotly.com/julia/bubble-charts/)

```@example
using PlotlyJS

plot(scatter(x=1:4, y=10:13, mode="markers", marker=attr(size=40:20:100, color=0:3)))
```

#### Style Scatter Plots

There are many properties of the scatter trace type that control differetn aspects of the appearance of the trace. Here are a few examples

```@example
using PlotlyJS

p = plot([sin, cos], 0, 10, mode="markers", marker=attr(size=10, line_width=2),
         Layout(title="Styled Scatter", yaxis_zeroline=false, xaxis_zeroline=false))
restyle!(p, 1, marker_color="rgba(152, 0, 0, 0.8)")
restyle!(p, 2, marker_color="rgba(255, 182, 193, 0.9)")
p
```

#### Data Labels on Hover

```@example
using PlotlyJS, RDatasets

df = RDatasets.dataset("car", "States")
plot(df, x=:State, y=:Pop, mode="markers", text=:State, marker_color=:Pop,
	Layout(title="Populations of USA States"))
```

#### Scatter with a Color Dimension

```@example
using PlotlyJS

plot(scatter(y=randn(500), mode="markers",
    marker=attr(size=16, color=rand(500), colorscale="Viridis", showscale=true)
))
```

#### Large Data Sets

Now in Plotly you can implement WebGL with `scattergl()` in place of
`scatter()` for increased speed, improved interactivity, and the
ability to plot even more data!

```@example
using PlotlyJS

N = 3000
plot(scattergl(x=randn(N), y=randn(N), mode="markers",
               marker=attr(color=randn(N), colorscale="Viridis", line_width=1)))
```

### Reference

More information on [scatter](https://plotly.com/julia/reference/scatter/) or [scattergl](https://plotly.com/julia/reference/scattergl/).
