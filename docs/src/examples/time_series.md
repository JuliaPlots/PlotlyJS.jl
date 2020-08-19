# Time Series

```@example time_series
using PlotlyJS
```

```@example time_series
function datetimestrings()
    x = ["2013-10-04 22:23:00", "2013-11-04 22:23:00", "2013-12-04 22:23:00"]
    plot(scatter(x=x, y=[1 ,3, 6]))
end
datetimestrings()
```

