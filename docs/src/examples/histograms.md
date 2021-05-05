# Histograms

```@example histograms
using PlotlyJS
```

```@example histograms
function two_hists()
    x0 = randn(500)
    x1 = x0 .+ 1

    trace1 = histogram(x=x0, opacity=0.75)
    trace2 = histogram(x=x1, opacity=0.75)
    data = [trace1, trace2]
    layout = Layout(barmode="overlay")
    Plot(data, layout)
end
two_hists()
```

