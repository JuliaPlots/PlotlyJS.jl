```julia
function heatmap1()
    plot(heatmap(z=[1 20 30; 20 1 60; 30 60 1]))
end
heatmap1()
```


<div id="6c209b5c-3937-4957-a69a-7045c1f40caa" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('6c209b5c-3937-4957-a69a-7045c1f40caa', [{"type":"heatmap","z":[[1,20,30],[20,1,60],[30,60,1]]}],
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


<div id="6d72a03b-d897-4853-a206-13a14bee92ed" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('6d72a03b-d897-4853-a206-13a14bee92ed', [{"y":["Morning","Afternoon","Evening"],"type":"heatmap","z":[[17,9,17,11,23],[7,21,15,22,5],[26,20,10,24,13]],"x":["Monday","Tuesday","Wednesday","Thursday","Friday"]}],
               {"margin":{"l":50,"b":60,"r":50,"t":60}}, {showLink: false});

 </script>



