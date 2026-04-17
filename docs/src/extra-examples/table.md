`table` provides a Table object for detailed data viewing. The data are arranged in
a grid of rows and columns. Most styling can be specified for header, columns, rows or individual cells. Table is using a column-major order, i.e. the grid is represented as a vector of column vectors.

#### Basic Table

```@example
using PlotlyJS

plot(table(header_values=["A Scores", "B Scores"],
           cells_values=[[100,90,80,90],[95,85,75,95]]))
```

#### Styled Table

```@example
using PlotlyJS

plot(
  table(
      header=attr(values=["A Scores", "B Scores"],
                line_color="darkslategray",
                fill_color="lightskyblue",
                align="left"),
      cells=attr(
        values=[[100, 90, 80, 90], # 1st column
          [95, 85, 75, 95]], # 2nd column
        line_color="darkslategray",
        fill_color="lightcyan",
        align="left"
      )
  ),
  Layout(width=500, height=500)
)
```

#### Use a Dataframe

```@example
using PlotlyJS, RDatasets

df = RDatasets.dataset("car", "States")

plot(table(header=attr(values=["State", "Region", "Population", "Pay"],
                       fill_collor="paleturquoise", align="left"),
           cells=attr(values=[df.State, df.Region, df.Pop, df.Pay],
		              fill_color="lavender", align="left")))
```

#### Changing Row and Column Size

```@example

```

#### Alternating Row Colors

```@example
using PlotlyJS

headerColor = "grey"
rowEvenColor = "lightgrey"
rowOddColor = "white"

plot(table(
    header=attr(
        values=["<b>EXPENSES</b>","<b>Q1</b>","<b>Q2</b>","<b>Q3</b>","<b>Q4</b>"],
        line_color="darkslategray",
        fill_color=headerColor,
        align=["left","center"],
        font=attr(color="white", size=12)
    ),
    cells=attr(
        values=[
        ["Salaries", "Office", "Merchandise", "Legal", "<b>TOTAL</b>"],
        [1200000, 20000, 80000, 2000, 12120000],
        [1300000, 20000, 70000, 2000, 130902000],
        [1300000, 20000, 120000, 2000, 131222000],
        [1400000, 20000, 90000, 2000, 14102000]],
        line_color="darkslategray",
        # 2-D list of colors for alternating rows
        fill_color=[[rowOddColor, rowEvenColor, rowOddColor, rowEvenColor, rowOddColor] for _ in  1:5],
        align=["left", "center"],
        font=attr(color="darkslategray", size=11)
    )
))
```

#### Row Color Based on Variable

```@example
using PlotlyJS, DataFrames

color_vec = ["rgb(239, 243, 255)", "rgb(189, 215, 231)", "rgb(107, 174, 214)",
          "rgb(49, 130, 189)", "rgb(8, 81, 156)"]
data = Dict(:Year =>  [2010, 2011, 2012, 2013, 2014], :Color=> color_vec)

df = DataFrame(data)

plot(table(
    header=attr(
        values=["Color", "<b>YEAR</b>"],
        line_color="white", fill_color="white",
        align="center", font=attr(color="black", size=12)
    ),
    cells=attr(
        values=[df.Color, df.Year],
        line_color=[df.Color], fill_color=[df.Color],
        align="center", font=attr(color="black", size=11)
    )))
```

#### Cell Color Based on Variable

```@example
using PlotlyJS, Colors

color_vec = range(colorant"rgb(255, 200, 200)", colorant"rgb(200,0,0)", length=9)
a = [rand(1:9) for _ in 1:9]
b = [rand(1:9) for _ in 1:9]
c = [rand(1:9) for _ in 1:9]

plot(table(
    header=attr(
        values=["<b>Column A</b>", "<b>Column B</b>", "<b>Column C</b>"],
        line_color="white", fill_color="white",
        align="center",font=attr(color="black", size=12)),
    cells=attr(
        values=[a, b, c],
        line_color=[color_vec[a], color_vec[b], color_vec[c]],
        fill_color=[color_vec[a], color_vec[b], color_vec[c]],
        align="center", font=attr(color="white", size=11))))
```

#### Reference

More information on tables and table attributes are [here](https://plotly.com/julia/reference/table/).
