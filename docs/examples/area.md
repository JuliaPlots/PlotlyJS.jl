```julia
function area1()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")
    plot([trace1, trace2])
end
area1()
```


<div id="aa324c8e-e995-432f-9ab1-68e99f2d6ad9" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('aa324c8e-e995-432f-9ab1-68e99f2d6ad9', [{"y":[0,2,3,5],"type":"scatter","x":[1,2,3,4],"fill":"tozeroy"},{"y":[3,5,1,7],"type":"scatter","x":[1,2,3,4],"fill":"tonexty"}],  {"margin":{"r":50,"l":50,"b":50,"t":60}}, {showLink: false});

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


<div id="2494672d-18bd-4dae-9b38-2d61e569c2ec" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('2494672d-18bd-4dae-9b38-2d61e569c2ec', [{"y":[2,1,4],"type":"scatter","x":[1,2,3],"fill":"tozeroy"},{"y":[3,2,6],"type":"scatter","x":[1,2,3],"fill":"tonexty"},{"y":[6,2,8],"type":"scatter","x":[1,2,3],"fill":"tonexty"}],  {"title":"stacked and filled line chart","margin":{"r":50,"l":50,"b":50,"t":60}}, {showLink: false});

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


<div id="75458bfd-3a7f-455f-a5da-3fa7e5e9ae99" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('75458bfd-3a7f-455f-a5da-3fa7e5e9ae99', [{"y":[0,2,3,5],"type":"scatter","x":[1,2,3,4],"fill":"tozeroy","mode":"none"},{"y":[3,5,1,7],"type":"scatter","x":[1,2,3,4],"fill":"tonexty","mode":"none"}],  {"title":"Overlaid Chart Without Boundary Lines","margin":{"r":50,"l":50,"b":50,"t":60}}, {showLink: false});

 </script>



