```julia
function area1()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")
    plot([trace1, trace2])
end
area1()
```


<div id="c5f2e1f3-9a25-4ad5-a7ae-df70ebaa9ba2" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('c5f2e1f3-9a25-4ad5-a7ae-df70ebaa9ba2', [{"y":[0,2,3,5],"type":"scatter","fill":"tozeroy","x":[1,2,3,4]},{"y":[3,5,1,7],"type":"scatter","fill":"tonexty","x":[1,2,3,4]}],
               {"margin":{"l":50,"b":60,"r":50,"t":60}}, {showLink: false});

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


<div id="47787e9f-00fb-452d-a76b-acd9d0ebc9d2" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('47787e9f-00fb-452d-a76b-acd9d0ebc9d2', [{"y":[2,1,4],"type":"scatter","fill":"tozeroy","x":[1,2,3]},{"y":[3,2,6],"type":"scatter","fill":"tonexty","x":[1,2,3]},{"y":[6,2,8],"type":"scatter","fill":"tonexty","x":[1,2,3]}],
               {"margin":{"l":50,"b":60,"r":50,"t":60},"title":"stacked and filled line chart"}, {showLink: false});

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


<div id="ed675bd7-e7ca-4dc2-bae6-fd4f8b581a0f" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('ed675bd7-e7ca-4dc2-bae6-fd4f8b581a0f', [{"mode":"none","y":[0,2,3,5],"type":"scatter","fill":"tozeroy","x":[1,2,3,4]},{"mode":"none","y":[3,5,1,7],"type":"scatter","fill":"tonexty","x":[1,2,3,4]}],
               {"margin":{"l":50,"b":60,"r":50,"t":60},"title":"Overlaid Chart Without Boundary Lines"}, {showLink: false});

 </script>



