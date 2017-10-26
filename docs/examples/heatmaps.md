```julia
function heatmap1()
    plot(heatmap(z=[1 20 30; 20 1 60; 30 60 1]))
end
heatmap1()
```


<div id="499a9ed6-5fe4-402c-8d18-7cf8ef313fd1" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('499a9ed6-5fe4-402c-8d18-7cf8ef313fd1', [{"type":"heatmap","z":[[1,20,30],[20,1,60],[30,60,1]]}],
               {"margin":{"l":50,"b":60,"r":50,"t":60}}, {showLink: false});

 </script>



```julia
function heatmap2()
    trace = heatmap(
        x=["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
        y=["Morning", "Afternoon", "Evening"],
        z=rand(1:30, 5, 3)
    )
    plot(trace)
end
heatmap2()
```


<div id="3957269a-7045-41f4-b352-70b9fd046eea" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('3957269a-7045-41f4-b352-70b9fd046eea', [{"y":["Morning","Afternoon","Evening"],"type":"heatmap","z":[[3,10,17,18,6],[15,23,10,26,3],[14,8,1,17,26]],"x":["Monday","Tuesday","Wednesday","Thursday","Friday"]}],
               {"margin":{"l":50,"b":60,"r":50,"t":60}}, {showLink: false});

 </script>



