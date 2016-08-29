```julia
function contour1()
    x = [-9, -6, -5 , -3, -1]
    y = [0, 1, 4, 5, 7]
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    trace = contour(x=x, y=y, z=z)

    layout = Layout(title="Setting the X and Y Coordinates in a Contour Plot")
    plot(trace, layout)
end
contour1()
```


<div id="f7fc6fed-cd0a-46a7-a496-db4c22a752dd" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('f7fc6fed-cd0a-46a7-a496-db4c22a752dd', [{"y":[0,1,4,5,7],"type":"contour","z":[[10.0,5.625,2.5,0.625,0.0],[10.625,6.25,3.125,1.25,0.625],[12.5,8.125,5.0,3.125,2.5],[15.625,11.25,8.125,6.25,5.625],[20.0,15.625,12.5,10.625,10.0]],"x":[-9,-6,-5,-3,-1]}],  {"title":"Setting the X and Y Coordinates in a Contour Plot","margin":{"r":50,"l":50,"b":50,"t":60}}, {showLink: false});

 </script>



