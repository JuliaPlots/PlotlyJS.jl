```julia
function excontour1()
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
excontour1()
```


<div id="1bb229e3-1948-42b3-941f-89a8e847c79d"></div>

<script>
   thediv = document.getElementById('1bb229e3-1948-42b3-941f-89a8e847c79d');
var data = [{"type":"contour","y":[0,1,4,5,7],"z":[[10.0,5.625,2.5,0.625,0.0],[10.625,6.25,3.125,1.25,0.625],[12.5,8.125,5.0,3.125,2.5],[15.625,11.25,8.125,6.25,5.625],[20.0,15.625,12.5,10.625,10.0]],"x":[-9,-6,-5,-3,-1]}]
var layout = {"title":"Setting the X and Y Coordinates in a Contour Plot","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



