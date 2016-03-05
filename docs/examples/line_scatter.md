```julia
function exlinescatter1()
    trace1 = scatter(;x=1:4, y=[10, 15, 13, 17], mode="markers")
    trace2 = scatter(;x=2:5, y=[16, 5, 11, 9], mode="lines")
    trace3 = scatter(;x=1:4, y=[12, 9, 15, 12], mode="lines+markers")
    plot([trace1, trace2, trace3])
end
exlinescatter1()
```


<div id="af9d6a53-38fc-4ba3-931b-cd8ccbae513a"></div>

<script>
   thediv = document.getElementById('af9d6a53-38fc-4ba3-931b-cd8ccbae513a');
var data = [{"type":"scatter","y":[10,15,13,17],"x":[1,2,3,4],"mode":"markers"},{"type":"scatter","y":[16,5,11,9],"x":[2,3,4,5],"mode":"lines"},{"type":"scatter","y":[12,9,15,12],"x":[1,2,3,4],"mode":"lines+markers"}]
var layout = {"margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function exlinescatter2()
    trace1 = scatter(;x=1:5, y=[1, 6, 3, 6, 1],
                      mode="markers", name="Team A",
                      text=["A-1", "A-2", "A-3", "A-4", "A-5"],
                      marker_size=12)

    trace2 = scatter(;x=1:5+0.5, y=[4, 1, 7, 1, 4],
                      mode="markers", name= "Team B",
                      text=["B-a", "B-b", "B-c", "B-d", "B-e"])
    # setting marker.size this way is _equivalent_ to what we did for trace1
    trace2["marker"] = Dict(:size => 12)

    data = [trace1, trace2]
    layout = Layout(;title="Data Labels Hover", xaxis_range=[0.75, 5.25],
                     yaxis_range=[0, 8])
    plot(data, layout)
end
exlinescatter2()
```


<div id="fd54d500-45fc-43fb-b5d7-f4e22b45f674"></div>

<script>
   thediv = document.getElementById('fd54d500-45fc-43fb-b5d7-f4e22b45f674');
var data = [{"type":"scatter","y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"name":"Team A","x":[1,2,3,4,5],"mode":"markers","marker":{"size":12}},{"type":"scatter","y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"name":"Team B","x":[1.0,2.0,3.0,4.0,5.0],"mode":"markers","marker":{"size":12}}]
var layout = {"yaxis":{"range":[0,8]},"xaxis":{"range":[0.75,5.25]},"title":"Data Labels Hover","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function exlinescatter3()
    trace1 = scatter(;x=1:5, y=[1, 6, 3, 6, 1],
                      mode="markers+text", name="Team A",
                      textposition="top center",
                      text=["A-1", "A-2", "A-3", "A-4", "A-5"],
                      marker_size=12, textfont_family="Raleway, sans-serif")

    trace2 = scatter(;x=1:5+0.5, y=[4, 1, 7, 1, 4],
                      mode="markers+text", name= "Team B",
                      textposition="bottom center",
                      text= ["B-a", "B-b", "B-c", "B-d", "B-e"],
                      marker_size=12, textfont_family="Times New Roman")

    data = [trace1, trace2]

    layout = Layout(;title="Data Labels on the Plot", xaxis_range=[0.75, 5.25],
                     yaxis_range=[0, 8], legend_y=0.5, legend_yref="paper",
                     legend_font=Dict(:family => "Arial, sans-serif", :size => 20,
                                      :color => "grey"))
    plot(data, layout)
end
exlinescatter3()
```


<div id="a92db82f-7ddc-4007-8170-5da2c2461d0f"></div>

<script>
   thediv = document.getElementById('a92db82f-7ddc-4007-8170-5da2c2461d0f');
var data = [{"type":"scatter","y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"textfont":{"family":"Raleway, sans-serif"},"name":"Team A","x":[1,2,3,4,5],"textposition":"top center","mode":"markers+text","marker":{"size":12}},{"type":"scatter","y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"textfont":{"family":"Times New Roman"},"name":"Team B","x":[1.0,2.0,3.0,4.0,5.0],"textposition":"bottom center","mode":"markers+text","marker":{"size":12}}]
var layout = {"yaxis":{"range":[0,8]},"legend":{"y":0.5,"font":{"size":20,"color":"grey","family":"Arial, sans-serif"},"yref":"paper"},"xaxis":{"range":[0.75,5.25]},"title":"Data Labels on the Plot","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function exlinescatter4()
    trace1 = scatter(;y=fill(5, 40), mode="markers", marker_size=40,
                      marker_color=0:39)
    layout = Layout(title="Scatter Plot with a Color Dimension")
    plot(trace1, layout)
end
exlinescatter4()
```


<div id="dd8d699b-09ce-4514-974f-8b7f835ce7d9"></div>

<script>
   thediv = document.getElementById('dd8d699b-09ce-4514-974f-8b7f835ce7d9');
var data = [{"type":"scatter","y":[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],"mode":"markers","marker":{"size":40,"color":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39]}}]
var layout = {"title":"Scatter Plot with a Color Dimension","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function exlinescatter5()

    country = ["Switzerland (2011)", "Chile (2013)", "Japan (2014)",
               "United States (2012)", "Slovenia (2014)", "Canada (2011)",
               "Poland (2010)", "Estonia (2015)", "Luxembourg (2013)",
               "Portugal (2011)"]

    votingPop = [40, 45.7, 52, 53.6, 54.1, 54.2, 54.5, 54.7, 55.1, 56.6]
    regVoters = [49.1, 42, 52.7, 84.3, 51.7, 61.1, 55.3, 64.2, 91.1, 58.9]

    trace1 = scatter(;x=votingPop, y=country, mode="markers",
                      name="Percent of estimated voting age population",
                      marker_color="rgba(156, 165, 196, 0.95)",
                      marker_line_color="rgba(156, 165, 196, 1.0)",
                      marker_line_width=1,
                      marker_size=16, marker_symbol="circle")

    trace2 = scatter(;x=regVoters, y=country, mode="markers",
                      name="Percent of estimated registered voters")
    # also could have set the marker props above by using a dict
    trace2["marker"] = Dict(:color => "rgba(204, 204, 204, 0.95)",
                           :line => Dict(:color=> "rgba(217, 217, 217, 1.0)",
                                         :width=> 1),
                           :symbol => "circle",
                           :size => 16)

    data = [trace1, trace2]

    layout = Layout(title="Votes cast for ten lowest voting age population in OECD countries",
                    width=600, height=600, hovermode="closest",
                    margin=Dict(:l => 140, :r => 40, :b => 50, :t => 80))
    layout.fields[:paper_bgcolor] = "rgb(254, 247, 234)"
    layout.fields[:plot_bgcolor] = "rgb(254, 247, 234)"
    layout["xaxis"] = Dict(:showgrid => false,
                           :showline => true,
                           :linecolor => "rgb(102, 102, 102)",
                           :titlefont => Dict(:font=> Dict(:color =>"rgb(204, 204, 204)")),
                           :tickfont => Dict(:font=> Dict(:color =>"rgb(102, 102, 102)")),
                           :autotick => false,
                           :dtick => 10,
                           :ticks => "outside",
                           :tickcolor => "rgb(102, 102, 102)")
    layout["legend"] = Dict(:font => Dict(:size => 10),
                            :yanchor => "middle",
                            :xanchor => "right")
    plot(data, layout)
end
exlinescatter5()
```


<div id="95359767-cfe1-4a9b-a927-7735a6c732c2"></div>

<script>
   thediv = document.getElementById('95359767-cfe1-4a9b-a927-7735a6c732c2');
var data = [{"type":"scatter","y":["Switzerland (2011)","Chile (2013)","Japan (2014)","United States (2012)","Slovenia (2014)","Canada (2011)","Poland (2010)","Estonia (2015)","Luxembourg (2013)","Portugal (2011)"],"name":"Percent of estimated voting age population","x":[40.0,45.7,52.0,53.6,54.1,54.2,54.5,54.7,55.1,56.6],"mode":"markers","marker":{"symbol":"circle","line":{"width":1,"color":"rgba(156, 165, 196, 1.0)"},"size":16,"color":"rgba(156, 165, 196, 0.95)"}},{"type":"scatter","y":["Switzerland (2011)","Chile (2013)","Japan (2014)","United States (2012)","Slovenia (2014)","Canada (2011)","Poland (2010)","Estonia (2015)","Luxembourg (2013)","Portugal (2011)"],"name":"Percent of estimated registered voters","x":[49.1,42.0,52.7,84.3,51.7,61.1,55.3,64.2,91.1,58.9],"mode":"markers","marker":{"symbol":"circle","line":{"width":1,"color":"rgba(217, 217, 217, 1.0)"},"size":16,"color":"rgba(204, 204, 204, 0.95)"}}]
var layout = {"width":600,"hovermode":"closest","plot_bgcolor":"rgb(254, 247, 234)","legend":{"font":{"size":10},"xanchor":"right","yanchor":"middle"},"xaxis":{"linecolor":"rgb(102, 102, 102)","showline":true,"titlefont":{"font":{"color":"rgb(204, 204, 204)"}},"tickcolor":"rgb(102, 102, 102)","showgrid":false,"tickfont":{"font":{"color":"rgb(102, 102, 102)"}},"dtick":10,"ticks":"outside","autotick":false},"paper_bgcolor":"rgb(254, 247, 234)","title":"Votes cast for ten lowest voting age population in OECD countries","margin":{"r":40,"l":140,"b":50,"t":80},"height":600}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function exlinescatter6()
    trace1 = scatter(;x=[52698, 43117], y=[53, 31],
                      mode="markers",
                      name="North America",
                      text=["United States", "Canada"])
    trace1["marker"] = Dict(:color => "rgb(164, 194, 244)",
                            :size => 12,
                            :line => Dict(:color => "white", :width => 0.5))

    trace2 = scatter(;x=[39317, 37236, 35650, 30066, 29570, 27159, 23557, 21046, 18007],
                      y=[33, 20, 13, 19, 27, 19, 49, 44, 38],
                      mode="markers", name="Europe",
                      marker_size=12, marker_color="rgb(255, 217, 102)",
                      text=["Germany", "Britain", "France", "Spain", "Italy", "Czech Rep.",
                            "Greece", "Poland"])

    trace3 = scatter(;x=[42952, 37037, 33106, 17478, 9813, 5253, 4692, 3899],
                      y=[23, 42, 54, 89, 14, 99, 93, 70],
                      mode="markers",
                      name="Asia/Pacific",
                      marker_size=12, marker_color="rgb(234, 153, 153)",
                      text=["Australia", "Japan", "South Korea", "Malaysia", "China", "Indonesia", "Philippines", "India"])

    trace4 = scatter(;x=[19097, 18601, 15595, 13546, 12026, 7434, 5419],
                      y=[43, 47, 56, 80, 86, 93, 80],
                      mode="markers", name="Latin America",
                      marker_size=12, marker_color="rgb(142, 124, 195)",
                      text=["Chile", "Argentina", "Mexico", "Venezuela", "Venezuela", "El Salvador", "Bolivia"])

    data = [trace1, trace2, trace3, trace4]

    layout = Layout(;title="Quarter 1 Growth",
                     xaxis_title="GDP per Capita", xaxis_showgrid=false, xaxis_zeroline=false,
                     yaxis_title="Percent", yaxis_zeroline=false)
    layout["xaxis"] = Dict(:title => "GDP per Capita", :showgrid => false, :zeroline => false)
    layout["yaxis"] = Dict(:title => "Percent", :showline => false)

    plot(data, layout)
end
exlinescatter6()
```


<div id="06355c04-5575-4cab-83e5-9cea24a4c73c"></div>

<script>
   thediv = document.getElementById('06355c04-5575-4cab-83e5-9cea24a4c73c');
var data = [{"type":"scatter","y":[53,31],"text":["United States","Canada"],"name":"North America","x":[52698,43117],"mode":"markers","marker":{"line":{"width":0.5,"color":"white"},"size":12,"color":"rgb(164, 194, 244)"}},{"type":"scatter","y":[33,20,13,19,27,19,49,44,38],"text":["Germany","Britain","France","Spain","Italy","Czech Rep.","Greece","Poland"],"name":"Europe","x":[39317,37236,35650,30066,29570,27159,23557,21046,18007],"mode":"markers","marker":{"size":12,"color":"rgb(255, 217, 102)"}},{"type":"scatter","y":[23,42,54,89,14,99,93,70],"text":["Australia","Japan","South Korea","Malaysia","China","Indonesia","Philippines","India"],"name":"Asia/Pacific","x":[42952,37037,33106,17478,9813,5253,4692,3899],"mode":"markers","marker":{"size":12,"color":"rgb(234, 153, 153)"}},{"type":"scatter","y":[43,47,56,80,86,93,80],"text":["Chile","Argentina","Mexico","Venezuela","Venezuela","El Salvador","Bolivia"],"name":"Latin America","x":[19097,18601,15595,13546,12026,7434,5419],"mode":"markers","marker":{"size":12,"color":"rgb(142, 124, 195)"}}]
var layout = {"yaxis":{"showline":false,"title":"Percent"},"xaxis":{"title":"GDP per Capita","showgrid":false,"zeroline":false},"title":"Quarter 1 Growth","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



