```julia
function area1()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")
    plot([trace1, trace2])
end
area1()
```


<div id="be9a4199-0504-4520-84d3-ce939d583a5d" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('be9a4199-0504-4520-84d3-ce939d583a5d', [{"y":[0,2,3,5],"type":"scatter","x":[1,2,3,4],"fill":"tozeroy"},{"y":[3,5,1,7],"type":"scatter","x":[1,2,3,4],"fill":"tonexty"}],
               {"margin":{"r":0,"l":0,"b":0,"t":0}}, {showLink: false});

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


<div id="a77d9cdc-8cd8-42d2-b9b7-4d2a1de3b49a" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('a77d9cdc-8cd8-42d2-b9b7-4d2a1de3b49a', [{"y":[2,1,4],"type":"scatter","x":[1,2,3],"fill":"tozeroy"},{"y":[3,2,6],"type":"scatter","x":[1,2,3],"fill":"tonexty"},{"y":[6,2,8],"type":"scatter","x":[1,2,3],"fill":"tonexty"}],
               {"title":"stacked and filled line chart","margin":{"r":0,"l":0,"b":0,"t":0}}, {showLink: false});

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


<div id="2b3512b3-baa7-44bc-88a7-3555ce42edc9" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('2b3512b3-baa7-44bc-88a7-3555ce42edc9', [{"y":[0,2,3,5],"type":"scatter","x":[1,2,3,4],"fill":"tozeroy","mode":"none"},{"y":[3,5,1,7],"type":"scatter","x":[1,2,3,4],"fill":"tonexty","mode":"none"}],
               {"title":"Overlaid Chart Without Boundary Lines","margin":{"r":0,"l":0,"b":0,"t":0}}, {showLink: false});

 </script>



