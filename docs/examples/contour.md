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


<div id="12e5503b-ac26-4001-bb18-35b1923223c2" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('12e5503b-ac26-4001-bb18-35b1923223c2', [{"y":[0,1,4,5,7],"type":"contour","z":[[10.0,5.625,2.5,0.625,0.0],[10.625,6.25,3.125,1.25,0.625],[12.5,8.125,5.0,3.125,2.5],[15.625,11.25,8.125,6.25,5.625],[20.0,15.625,12.5,10.625,10.0]],"x":[-9,-6,-5,-3,-1]}],
               {"title":"Setting the X and Y Coordinates in a Contour Plot","margin":{"r":0,"l":0,"b":0,"t":0}}, {showLink: false});

 </script>



