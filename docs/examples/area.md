```julia
function area1()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")
    plot([trace1, trace2])
end
area1()
```


<div id="2597c84a-6e37-43a3-9615-1601a19cbe2f" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('2597c84a-6e37-43a3-9615-1601a19cbe2f', [{"y":[0,2,3,5],"type":"scatter","x":[1,2,3,4],"fill":"tozeroy"},{"y":[3,5,1,7],"type":"scatter","x":[1,2,3,4],"fill":"tonexty"}],
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


<div id="b74231f9-33c9-4d86-a702-cd953038b504" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('b74231f9-33c9-4d86-a702-cd953038b504', [{"y":[2,1,4],"type":"scatter","x":[1,2,3],"fill":"tozeroy"},{"y":[3,2,6],"type":"scatter","x":[1,2,3],"fill":"tonexty"},{"y":[6,2,8],"type":"scatter","x":[1,2,3],"fill":"tonexty"}],
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


<div id="8d58e511-a32f-4fc7-9dee-3a075290d15a" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('8d58e511-a32f-4fc7-9dee-3a075290d15a', [{"y":[0,2,3,5],"type":"scatter","x":[1,2,3,4],"fill":"tozeroy","mode":"none"},{"y":[3,5,1,7],"type":"scatter","x":[1,2,3,4],"fill":"tonexty","mode":"none"}],
               {"title":"Overlaid Chart Without Boundary Lines","margin":{"r":0,"l":0,"b":0,"t":0}}, {showLink: false});

 </script>



