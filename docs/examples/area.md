```julia
function exarea1()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")
    plot([trace1, trace2])
end
exarea1()
```


<div id="09c873fd-9538-4d3d-876b-f0487dad62c6"></div>

<script>
   thediv = document.getElementById('09c873fd-9538-4d3d-876b-f0487dad62c6');
var data = [{"type":"scatter","y":[0,2,3,5],"x":[1,2,3,4],"fill":"tozeroy"},{"type":"scatter","y":[3,5,1,7],"x":[1,2,3,4],"fill":"tonexty"}]
var layout = {"margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function exarea2()
    traces = [scatter(;x=1:3, y=[2, 1, 4], fill="tozeroy"),
              scatter(;x=1:3, y=[1, 1, 2], fill="tonexty"),
              scatter(;x=1:3, y=[3, 0, 2], fill="tonexty")]
    _stacked_area!(traces)

    plot(traces, Layout(title="stacked and filled line chart"))
end
exarea2()
```


<div id="a649b0fc-3e5e-455c-83de-95587cbaa442"></div>

<script>
   thediv = document.getElementById('a649b0fc-3e5e-455c-83de-95587cbaa442');
var data = [{"type":"scatter","y":[2,1,4],"x":[1,2,3],"fill":"tozeroy"},{"type":"scatter","y":[3,2,6],"x":[1,2,3],"fill":"tonexty"},{"type":"scatter","y":[6,2,8],"x":[1,2,3],"fill":"tonexty"}]
var layout = {"title":"stacked and filled line chart","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function exarea3()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy", mode="none")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty", mode="none")
    plot([trace1, trace2],
         Layout(title="Overlaid Chart Without Boundary Lines"))
end
exarea3()
```


<div id="9636e651-055f-4662-b83c-b16f6a00724d"></div>

<script>
   thediv = document.getElementById('9636e651-055f-4662-b83c-b16f6a00724d');
var data = [{"type":"scatter","y":[0,2,3,5],"x":[1,2,3,4],"fill":"tozeroy","mode":"none"},{"type":"scatter","y":[3,5,1,7],"x":[1,2,3,4],"fill":"tonexty","mode":"none"}]
var layout = {"title":"Overlaid Chart Without Boundary Lines","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



