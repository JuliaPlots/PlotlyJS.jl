```julia
function area1()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")
    plot([trace1, trace2])
end
area1()
```


<div id="a26b1321-ec84-473f-aa8f-a745bbbc0981" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
   Plotly.newPlot('a26b1321-ec84-473f-aa8f-a745bbbc0981', [{"type":"scatter","y":[0,2,3,5],"x":[1,2,3,4],"fill":"tozeroy"},{"type":"scatter","y":[3,5,1,7],"x":[1,2,3,4],"fill":"tonexty"}],  {"margin":{"r":50,"l":50,"b":50,"t":60}}, {showLink: false});

 </script>



```julia
function area2()
    function _stacked_area!(traces)
        for (i, tr) in enumerate(traces[2:end])
            for j in 1:min(length(traces[i]["y"]), length(tr["y"]))
                tr["y"][j] += traces[i]["y"][j]
            end
        end
        traces
    end

    traces = [scatter(;x=1:3, y=[2, 1, 4], fill="tozeroy"),
              scatter(;x=1:3, y=[1, 1, 2], fill="tonexty"),
              scatter(;x=1:3, y=[3, 0, 2], fill="tonexty")]
    _stacked_area!(traces)

    plot(traces, Layout(title="stacked and filled line chart"))
end
area2()
```


<div id="f0c5f320-fe7e-45ee-ae42-4bc1e0d24576" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
   Plotly.newPlot('f0c5f320-fe7e-45ee-ae42-4bc1e0d24576', [{"type":"scatter","y":[2,1,4],"x":[1,2,3],"fill":"tozeroy"},{"type":"scatter","y":[3,2,6],"x":[1,2,3],"fill":"tonexty"},{"type":"scatter","y":[6,2,8],"x":[1,2,3],"fill":"tonexty"}],  {"title":"stacked and filled line chart","margin":{"r":50,"l":50,"b":50,"t":60}}, {showLink: false});

 </script>



```julia
function area3()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy", mode="none")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty", mode="none")
    plot([trace1, trace2],
         Layout(title="Overlaid Chart Without Boundary Lines"))
end
area3()
```


<div id="3cd1d226-4efa-4f9d-baef-774777149dd3" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
   Plotly.newPlot('3cd1d226-4efa-4f9d-baef-774777149dd3', [{"type":"scatter","y":[0,2,3,5],"x":[1,2,3,4],"fill":"tozeroy","mode":"none"},{"type":"scatter","y":[3,5,1,7],"x":[1,2,3,4],"fill":"tonexty","mode":"none"}],  {"title":"Overlaid Chart Without Boundary Lines","margin":{"r":50,"l":50,"b":50,"t":60}}, {showLink: false});

 </script>



