```julia
function area1()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")
    plot([trace1, trace2])
end
area1()
```


<div id="3996bd1b-f7e3-4778-9f61-7911444bd641" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('3996bd1b-f7e3-4778-9f61-7911444bd641', [{"y":[0,2,3,5],"type":"scatter","x":[1,2,3,4],"fill":"tozeroy"},{"y":[3,5,1,7],"type":"scatter","x":[1,2,3,4],"fill":"tonexty"}],
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


<div id="4b61fe68-3017-4655-ba43-a08d02b453d8" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('4b61fe68-3017-4655-ba43-a08d02b453d8', [{"y":[2,1,4],"type":"scatter","x":[1,2,3],"fill":"tozeroy"},{"y":[3,2,6],"type":"scatter","x":[1,2,3],"fill":"tonexty"},{"y":[6,2,8],"type":"scatter","x":[1,2,3],"fill":"tonexty"}],
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


<div id="eab3c25d-3bb1-4334-a22f-2cc61d16c323" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('eab3c25d-3bb1-4334-a22f-2cc61d16c323', [{"y":[0,2,3,5],"type":"scatter","x":[1,2,3,4],"fill":"tozeroy","mode":"none"},{"y":[3,5,1,7],"type":"scatter","x":[1,2,3,4],"fill":"tonexty","mode":"none"}],
               {"title":"Overlaid Chart Without Boundary Lines","margin":{"r":0,"l":0,"b":0,"t":0}}, {showLink: false});

 </script>



