```julia
function exarea1()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")
    plot([trace1, trace2])
end
exarea1()
```


<div id="f61bcc39-ef9e-4ac0-895a-194e5430ef51"></div>

<script>
   thediv = document.getElementById('f61bcc39-ef9e-4ac0-895a-194e5430ef51');
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


<div id="48c674b6-44a4-4961-8435-14366f4b8b84"></div>

<script>
   thediv = document.getElementById('48c674b6-44a4-4961-8435-14366f4b8b84');
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


<div id="d3fbabc1-e88e-4f54-a5eb-7b84b8c5d534"></div>

<script>
   thediv = document.getElementById('d3fbabc1-e88e-4f54-a5eb-7b84b8c5d534');
var data = [{"type":"scatter","y":[0,2,3,5],"x":[1,2,3,4],"fill":"tozeroy","mode":"none"},{"type":"scatter","y":[3,5,1,7],"x":[1,2,3,4],"fill":"tonexty","mode":"none"}]
var layout = {"title":"Overlaid Chart Without Boundary Lines","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



