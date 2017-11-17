Starting with v0.4.0, PlotlyJS.jl now has support for styles. A style is
defined as an instance of the following type:

```julia
struct Style
    layout::Layout
    global_trace::PlotlyAttribute
    trace::Dict{Symbol,PlotlyAttribute}
end
```

Let's go over the fields one by one:

- `layout`: A `Layout` object defining style attributes for the layout
- `global_trace`: A `PlotlyAttribute` (created with the `attr` function) that
contains trace attributes to be applied to traces of all types
- `trace`: A dictionary mapping trace types into attributes to be applied to
that type of trace

## `Cycler`s

Starting with v0.7.1, PlotlyJS.jl has a new type called `Cycler` that can be
used to set style properties that should be cycled through for each trace.

For example, to have all traces alternate between being colored green and red,
I could define:

```julia
mystyle = Style(global_trace=attr(marker_color=["green", "red"]))
```

If I were then to define a plot

```julia
p = plot(rand(10, 3), style=mystyle)
```

The first and third plots would be green, while the second would be red.

As usual, if the `marker_color` attribute on a trace was already set, then
it will not be altered. For example:

```julia
p = plot(
    [
        scatter(y=rand(4)),
        scatter(y=rand(4), marker_color="black"),
        scatter(y=rand(4)),
        scatter(y=rand(4)),
    ],
    style=mystyle
)
```

Then the first and fourth traces would be red, the second black, and the third
green.

## Defining `Style`s

There are 3 ways to define a `Style`:

### 1. `Style`s from scratch

To define a brand new style, you simply construct one or more of the fields and
assign it using the keyword argument `Style` constructor. For example, this is
how the `ggplot` style is defined (as of time of writing):

```julia
ggplot = let
    axis = attr(showgrid=true, gridcolor="white", linewidth=1.0,
                linecolor="white", titlefont_color="#555555",
                titlefont_size=14, ticks="outside",
                tickcolor="#555555"
                )
    layout = Layout(plot_bgcolor="#E5E5E5",
                    paper_bgcolor="white",
                    font_size=10,
                    xaxis=axis,
                    yaxis=axis,
                    titlefont_size=14)

    colors = Cycler([
        "#E24A33", "#348ABD", "#988ED5", "#777777", "#FBC15E",
        "#8EBA42", "#FFB5B8"
    ])
    gta = attr(
        marker_line_width=0.5, marker_line_color="#348ABD", marker_color=colors
    )
    Style(layout=layout, global_trace=gta)
end
```

When displayed in the REPL we see the following:

```
Style with:
  - layout with fields font, margin, paper_bgcolor, plot_bgcolor, titlefont, xaxis, and yaxis
  - global_trace: PlotlyAttribute with field marker
```

Notice that we didn't have to define the `trace` field. When building new
`Style`s you only need to define the fields of the `Style` type that you
actually use in your style.

### 2. From other `Style`s

The second approach is to define a new `Style`, starting from an existing
style. Suppose that I liked the `ggplot` style, but wanted to make sure that
the marker symbol on scatter traces was always a square. I could define the
following style:

```julia
square_ggplot = Style(ggplot,
                      trace=Dict(:scatter => attr(marker_symbol="square")))
```

When displayed in the REPL we see the following:

```
Style with:
  - layout with fields font, margin, paper_bgcolor, plot_bgcolor, titlefont, xaxis, and yaxis
  - global_trace: PlotlyAttribute with field marker
  - trace:
    - scatter: PlotlyAttribute with field marker
```

Notice that all the information for `color_cycle`, `layout` and `global_trace`
is the same as in the `ggplot` case above, but we now have the addition of
another section for the `trace` field as it is no longer empty.

### 3. Composition

The final method for constructing new `Style`s is to compose existing styles.

Suppose that we want the ability to easily change the font size on the plot
title to be large, say at a level of 20. We might want to apply this
transformation to multiple existing styles. One way we could achieve this is by
defining

```julia
big_title = Style(layout=Layout(titlefont_size=20))
```

and then composing `big_title` with an existing `Style` (e.g. `ggplot` from
above) by calling

```julia
big_ggplot = Style(ggplot, big_title)
```

It is important that we put `big_title` _after_ `ggplot` as the composing
`Style` constructor has the same behavior as the function `Base.merge` where
fields that appear in both the left and right arguments are set to the value of
the rightmost appearance.

The only thing we've gained over method number 2 for defining styles is that we
can now reuse the `big_title` `Style` as many times as we'd like. This is
great, but doesn't actually show off the power of composing `Style`s.
Composition becomes more powerful when you use more than two styles. Consider
the following example:

```julia
square = Style(trace=Dict(:scatter => attr(marker_symbol="square")))
big_square_ggplot = Style(ggplot, square, big_title)
```

Here the order of `square` and `big_title` was not important as they don't
define any of the same attributes.

## Using `Style`s

Now that we know how to build a `Style`, how do we use it?. There are two main
ways to use a `Style`:

- Global mode: call the `use_style!(::Style)` function to set a global style
for all _subsequent_ plots (styles are not applied retroactively to plots that
were created before this function is called).
- Plot by plot mode: All methods of the `plot` and `Plot` functions accept a
keyword argument `style::Style` that sets the style for that plot only.

!!! note
    Styles do not transfer to parent plots when creating subplots. If you want
    to apply a `Style` to a plot containing subplots you must either use the
    global mode or construct the plot and set the `style` field on the parent
    after subplots are created (e.g. `p = [p1 p2]; p.style=ggplot`, where
    `ggplot` is defined as above)

## Built in `Style`s

There are a few built in styles that come with PlotlyJS.jl. More will be added
over time. To see which styles are currently built in look at the unexported
`PlotlyJS.STYLES` variable.

To obtain a built in style use the method `style(s::Symbol)`, where `s` is one
of the symbols in `PlotlyJS.STYLES`.

To use a built in style globally use the method `use_style!(s::Symbol)`, where
again `s` is a symbol from `PlotlyJS.STYLES`.

## Appendix: How `Style`s work

The best way to think about styles is that they will apply default values for
attributes, only if the attribute is not already defined. For example, suppose
we had the following style:

```julia
goofy = Style(global_trace=attr(marker_color="red"),
              trace=Dict(:scatter => attr(mode="markers")))
```

two plots:

```julia
p1 = plot(scatter(y=1:3, mode="lines", marker_symbol="square"), style=goofy)
p2 = plot(scatter(y=1:3, marker_color="green"), style=goofy)
```

If we inspect the json from these two plots we see:

```
julia> print(json(p1, 2))
{
  "layout": {
    "margin": {
      "r": 50,
      "l": 50,
      "b": 50,
      "t": 60
    }
  },
  "data": [
    {
      "y": [
        1,
        2,
        3
      ],
      "type": "scatter",
      "mode": "lines",
      "marker": {
        "symbol": "square",
        "color": "red"
      }
    }
  ]
}

julia> print(json(p2, 2))
{
  "layout": {
    "margin": {
      "r": 50,
      "l": 50,
      "b": 50,
      "t": 60
    }
  },
  "data": [
    {
      "y": [
        1,
        2,
        3
      ],
      "type": "scatter",
      "marker": {
        "color": "green"
      },
      "mode": "markers"
    }
  ]
}
```

Notice that on p1:

- the `marker.color` attribute was set to red
- `marker.symbol` remained square
- `mode` was not changed from `lines` to `markers`.

On the other hand, in `p2` we see that the

- `mode` was set to `markers`
- `marker.color` was not changed from green to red

This happened because the scatter in p1 defined the `mode` attribute, but not
`marker_color` whereas the scatter in p2 defined `marker_color` but not `mode`.
In both cases the attributes inside the `Style` became a default value for
fields that were not already set inside the trace.
