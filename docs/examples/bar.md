```julia
function bar1()
    data = bar(;x=["giraffes", "orangutans", "monkeys"],
               	y=[20, 14, 23])
    plot(data)
end
bar1()
```


<div id="74eff787-98b5-4a11-b17b-1512930d5d45" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('74eff787-98b5-4a11-b17b-1512930d5d45', [{"y":[20,14,23],"type":"bar","x":["giraffes","orangutans","monkeys"]}],
               {"margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



```julia
function bar2()
    trace1 = bar(;x=["giraffes", "orangutans", "monkeys"],
                  y=[20, 14, 23],
                  name="SF Zoo")
    trace2 = bar(;x=["giraffes", "orangutans", "monkeys"],
                  y=[12, 18, 29],
                  name="LA Zoo")
    data = [trace1, trace2]
    layout = Layout(;barmode="group")
    plot(data, layout)
end
bar2()
```


<div id="86972da9-5894-4974-9ca0-5d12ceed6052" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('86972da9-5894-4974-9ca0-5d12ceed6052', [{"y":[20,14,23],"name":"SF Zoo","type":"bar","x":["giraffes","orangutans","monkeys"]},{"y":[12,18,29],"name":"LA Zoo","type":"bar","x":["giraffes","orangutans","monkeys"]}],
               {"barmode":"group","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



```julia
function bar3()
    trace1 = bar(;x=["giraffes", "orangutans", "monkeys"],
                  y=[20, 14, 23],
                  name="SF Zoo")
    trace2 = bar(x=["giraffes", "orangutans", "monkeys"],
                 y=[12, 18, 29],
                 name="LA Zoo")
    data = [trace1, trace2]
    layout = Layout(;barmode="stack")
    plot(data, layout)
end
bar3()
```


<div id="d5cf46e6-a13d-4f10-a61c-e0f7a6a8c224" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('d5cf46e6-a13d-4f10-a61c-e0f7a6a8c224', [{"y":[20,14,23],"name":"SF Zoo","type":"bar","x":["giraffes","orangutans","monkeys"]},{"y":[12,18,29],"name":"LA Zoo","type":"bar","x":["giraffes","orangutans","monkeys"]}],
               {"barmode":"stack","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



```julia
function bar4()
    data = bar(;x=["Product A", "Product B", "Product C"],
                y=[20, 14, 23],
                text=["$(i)% market share" for i in rand(15:30, 3)],
                marker=attr(color="rgb(158, 202, 225)", opacity=0.6),
                line=attr(color="rgb(8, 48, 107)", width=1.5))

    layout = Layout(;title="January 2013 Sales Report")

    plot(data, layout)
end
bar4()
```


<div id="1a1338c0-8ada-4ca7-a8c9-bea75d2ad441" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('1a1338c0-8ada-4ca7-a8c9-bea75d2ad441', [{"y":[20,14,23],"text":["25% market share","30% market share","29% market share"],"type":"bar","line":{"width":1.5,"color":"rgb(8, 48, 107)"},"x":["Product A","Product B","Product C"],"marker":{"opacity":0.6,"color":"rgb(158, 202, 225)"}}],
               {"title":"January 2013 Sales Report","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



```julia
function bar5()
    x_value = ["Product A", "Product B", "Product C"]
    y_value = [20, 14, 23]

    data = bar(;x=x_value,
                y=y_value,
                text=["$(i)% market share" for i in rand(15:30, 3)],
		        marker=attr(color="rgb(158, 202, 225)", opacity=0.6,
                            line=attr(color="rgb(8, 48, 107)", width=1.5)))

    annotations = []

    for i in 1:length(x_value)
        result = attr(x=x_value[i],
                      y=y_value[i],
                      text=y_value[i],
                      xanchor="center",
                      yanchor="bottom",
                      showarrow=false)
        push!(annotations, result)
    end

    layout = Layout(;title="January 2013 Sales Report",
                    annotations=annotations)
    plot(data, layout)
end
bar5()
```


<div id="8df4d2aa-42c6-4276-a699-3252205013c3" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('8df4d2aa-42c6-4276-a699-3252205013c3', [{"y":[20,14,23],"text":["24% market share","24% market share","19% market share"],"type":"bar","x":["Product A","Product B","Product C"],"marker":{"opacity":0.6,"line":{"width":1.5,"color":"rgb(8, 48, 107)"},"color":"rgb(158, 202, 225)"}}],
               {"annotations":[{"y":20,"text":20,"xanchor":"center","x":"Product A","showarrow":false,"yanchor":"bottom"},{"y":14,"text":14,"xanchor":"center","x":"Product B","showarrow":false,"yanchor":"bottom"},{"y":23,"text":23,"xanchor":"center","x":"Product C","showarrow":false,"yanchor":"bottom"}],"title":"January 2013 Sales Report","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



```julia
function bar6()
    trace1 = bar(;x=["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
                     "Sep", "Oct", "Nov", "Dec"],
                  y=[20, 14, 25, 16, 18, 22, 19, 15, 12, 16, 14, 17],
                  name="Primary Product",
                  marker_color="rgb(49, 130, 189)",
                  opacity=0.7)
    trace2 = bar(;x=["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
                     "Sep", "Oct", "Nov", "Dec"],
                  y=[19, 14, 22, 14, 16, 19, 15, 14, 10, 12, 12, 16],
                  name="Secondary Product",
		  marker=attr(color="rgb(204, 204, 204)", opacity=0.5))
    data = [trace1, trace2]
    layout = Layout(;title="2013 Sales Report",
                     xaxis_tickangle=-45,
                     barmode="group")
    plot(data, layout)
end
bar6()
```


<div id="5f69c8db-c509-47ba-a6c7-f1ff9b414d58" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('5f69c8db-c509-47ba-a6c7-f1ff9b414d58', [{"y":[20,14,25,16,18,22,19,15,12,16,14,17],"opacity":0.7,"name":"Primary Product","type":"bar","x":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"marker":{"color":"rgb(49, 130, 189)"}},{"y":[19,14,22,14,16,19,15,14,10,12,12,16],"name":"Secondary Product","type":"bar","x":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"marker":{"opacity":0.5,"color":"rgb(204, 204, 204)"}}],
               {"barmode":"group","xaxis":{"tickangle":-45},"title":"2013 Sales Report","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



```julia
function bar7()
    data = bar(;x=["Feature $(s)" for s in 'A':'E'],
                y=[20, 14, 23, 25, 22],
    		    marker_color=["rgba(204, 204, 204, 1)",
                              "rgba(222, 45, 38, 0.8)",
                              "rgba(204, 204, 204, 1)",
                              "rgba(204, 204, 204, 1)",
                              "rgba(204, 204, 204, 1)"])
    layout = Layout(;title="Least Used Feature")
    plot(data, layout)
end
bar7()
```


<div id="a208176b-2322-4ce5-8c83-bf07dfe0866f" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('a208176b-2322-4ce5-8c83-bf07dfe0866f', [{"y":[20,14,23,25,22],"type":"bar","x":["Feature A","Feature B","Feature C","Feature D","Feature E"],"marker":{"color":["rgba(204, 204, 204, 1)","rgba(222, 45, 38, 0.8)","rgba(204, 204, 204, 1)","rgba(204, 204, 204, 1)","rgba(204, 204, 204, 1)"]}}],
               {"title":"Least Used Feature","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



```julia
function bar8()
    data = bar(;x=["Liam", "Sophie", "Jacob", "Mia", "William", "Olivia"],
                y=[8.0, 8.0, 12.0, 12.0, 13.0, 20.0],
                text=["4.17 below the mean", "4.17 below the mean",
                      "0.17 below the mean", "0.17 below the mean",
                      "0.83 above the mean", "7.83 above the mean"],
                marker_color="rgb(142, 124, 195)")
    layout = Layout(;title="Number of Graphs Made this Week",
                     font_family="Raleway, sans-serif",
                     showlegend=false,
                     xaxis_tickangle=-45,
                     yaxis=attr(zeroline=false, gridwidth=2),
                     bargap=0.05)
    plot(data, layout)
end
bar8()
```


<div id="48f87157-7b9c-4243-b92c-11094b42d862" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('48f87157-7b9c-4243-b92c-11094b42d862', [{"y":[8.0,8.0,12.0,12.0,13.0,20.0],"text":["4.17 below the mean","4.17 below the mean","0.17 below the mean","0.17 below the mean","0.83 above the mean","7.83 above the mean"],"type":"bar","x":["Liam","Sophie","Jacob","Mia","William","Olivia"],"marker":{"color":"rgb(142, 124, 195)"}}],
               {"yaxis":{"zeroline":false,"gridwidth":2},"showlegend":false,"bargap":0.05,"font":{"family":"Raleway, sans-serif"},"xaxis":{"tickangle":-45},"title":"Number of Graphs Made this Week","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



```julia
function bar9()
    trace1 = bar(;x=1995:2012,
                  y=[219, 146, 112, 127, 124, 180, 236, 207, 236, 263, 350,
                     430, 474, 526, 488, 537, 500, 439],
                  name="Rest of world",
                  marker_color="rgb(55, 83, 109)")
    trace2 = bar(;x=1995:2012,
                  y=[16, 13, 10, 11, 28, 37, 43, 55, 56, 88, 105, 156, 270,
                     299, 340, 403, 549, 499],
                  name="China",
                  marker_color="rgb(26, 118, 255)")

    data = [trace1, trace2]

    layout = Layout(;title="US Export of Plastic Scrap",
		             xaxis=attr(tickfont_size= 14,
                                tickfont_color="rgb(107, 107, 107)"),
		             yaxis=attr(title="USD (millions)",
                                titlefont=attr(size=16,
                                               color="rgb(107, 107, 107)"),
                                tickfont=attr(size=14,
                                              color="rgb(107, 107, 107)")),
                     legend=attr(x=0, y=1.0, bgcolor="rgba(255, 255, 255, 0)",
                                 bordercolor="rgba(255, 255, 255, 0)"),
                     barmode="group",
                     bargap=0.15,
                     bargroupgap=0.1)
    plot(data, layout)
end
bar9()
```


<div id="b45fb687-fa2b-4498-83f8-4f0b760b840b" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('b45fb687-fa2b-4498-83f8-4f0b760b840b', [{"y":[219,146,112,127,124,180,236,207,236,263,350,430,474,526,488,537,500,439],"name":"Rest of world","type":"bar","x":[1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012],"marker":{"color":"rgb(55, 83, 109)"}},{"y":[16,13,10,11,28,37,43,55,56,88,105,156,270,299,340,403,549,499],"name":"China","type":"bar","x":[1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012],"marker":{"color":"rgb(26, 118, 255)"}}],
               {"yaxis":{"titlefont":{"size":16,"color":"rgb(107, 107, 107)"},"title":"USD (millions)","tickfont":{"size":14,"color":"rgb(107, 107, 107)"}},"barmode":"group","bargap":0.15,"legend":{"bgcolor":"rgba(255, 255, 255, 0)","y":1.0,"x":0,"bordercolor":"rgba(255, 255, 255, 0)"},"xaxis":{"tickfont":{"size":14,"color":"rgb(107, 107, 107)"}},"title":"US Export of Plastic Scrap","bargroupgap":0.1,"margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



```julia
function bar10()
    x_data = ["Product Revenue", "Services Revenue", "Total Revenue",
              "Fixed Costs", "Variable Costs", "Total Costs", "Total"]
    y_data = [400, 660, 660, 590, 400, 400, 340]
    textList = ["\$430K", "\$260K", "\$690K", "\$-120K", "\$-200K", "\$-320K",
                "\$370K"]

    #Base
    trace1 = bar(;x=x_data,
                  y=[0, 430, 0, 570, 370, 370, 0],
                  marker_color="rgba(1, 1, 1, 0.0)")

    #Revenue
    trace2 = bar(;x=x_data,
                  y=[430, 260, 690, 0, 0, 0, 0],
                  marker_color="rgba(55, 128, 191, 0.7)",
		  line=attr(color="rgba(55, 128, 191, 1.0)", width=2))

    #Cost
    trace3 = bar(;x=x_data,
                  y=[0, 0, 0, 120, 200, 320, 0],
		  marker=attr(color="rgba(219, 64, 82, 0.7)",
		  line=attr(color="rgba(219, 64, 82, 1.0)", width=2)))

    #Profit
    trace4 = bar(;x=x_data,
                  y=[0, 0, 0, 0, 0, 0, 370],
		  marker=attr(color="rgba(50, 171, 96, 0.7)",
		  line=attr(color="rgba(50, 171, 96, 1.0)", width=2)))

    data = [trace1, trace2, trace3, trace4]

    annotations = []
    for i in 1:7
        result = attr(x=x_data[i],
                      y=y_data[i],
		              text=textList[i],
		              font=attr(;family="Arial", font_size=14,
                                 font_color="rgba(245, 246, 249, 1)"),
                                 showarrow=false)
        push!(annotations, result)
    end

    layout = Layout(;title="Annual Profit 2015",
                     barmode="stack",
                     paper_bgcolor="rgba(245, 246, 249, 1)",
                     plot_bgcolor="rgba(245, 246, 249, 1)",
                     width=600,
                     height=600,
                     showlegend=false,
                     xaxis_showtickabels=true,
                     annotations=annotations)

    plot(data, layout)
end
bar10()
```


<div id="a8833671-0323-47ed-94e5-8a98a5079202" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('a8833671-0323-47ed-94e5-8a98a5079202', [{"y":[0,430,0,570,370,370,0],"type":"bar","x":["Product Revenue","Services Revenue","Total Revenue","Fixed Costs","Variable Costs","Total Costs","Total"],"marker":{"color":"rgba(1, 1, 1, 0.0)"}},{"y":[430,260,690,0,0,0,0],"type":"bar","line":{"width":2,"color":"rgba(55, 128, 191, 1.0)"},"x":["Product Revenue","Services Revenue","Total Revenue","Fixed Costs","Variable Costs","Total Costs","Total"],"marker":{"color":"rgba(55, 128, 191, 0.7)"}},{"y":[0,0,0,120,200,320,0],"type":"bar","x":["Product Revenue","Services Revenue","Total Revenue","Fixed Costs","Variable Costs","Total Costs","Total"],"marker":{"line":{"width":2,"color":"rgba(219, 64, 82, 1.0)"},"color":"rgba(219, 64, 82, 0.7)"}},{"y":[0,0,0,0,0,0,370],"type":"bar","x":["Product Revenue","Services Revenue","Total Revenue","Fixed Costs","Variable Costs","Total Costs","Total"],"marker":{"line":{"width":2,"color":"rgba(50, 171, 96, 1.0)"},"color":"rgba(50, 171, 96, 0.7)"}}],
               {"annotations":[{"y":400,"text":"$430K","font":{"font":{"size":14,"color":"rgba(245, 246, 249, 1)"},"family":"Arial"},"x":"Product Revenue","showarrow":false},{"y":660,"text":"$260K","font":{"font":{"size":14,"color":"rgba(245, 246, 249, 1)"},"family":"Arial"},"x":"Services Revenue","showarrow":false},{"y":660,"text":"$690K","font":{"font":{"size":14,"color":"rgba(245, 246, 249, 1)"},"family":"Arial"},"x":"Total Revenue","showarrow":false},{"y":590,"text":"$-120K","font":{"font":{"size":14,"color":"rgba(245, 246, 249, 1)"},"family":"Arial"},"x":"Fixed Costs","showarrow":false},{"y":400,"text":"$-200K","font":{"font":{"size":14,"color":"rgba(245, 246, 249, 1)"},"family":"Arial"},"x":"Variable Costs","showarrow":false},{"y":400,"text":"$-320K","font":{"font":{"size":14,"color":"rgba(245, 246, 249, 1)"},"family":"Arial"},"x":"Total Costs","showarrow":false},{"y":340,"text":"$370K","font":{"font":{"size":14,"color":"rgba(245, 246, 249, 1)"},"family":"Arial"},"x":"Total","showarrow":false}],"barmode":"stack","plot_bgcolor":"rgba(245, 246, 249, 1)","width":600,"showlegend":false,"xaxis":{"showtickabels":true},"paper_bgcolor":"rgba(245, 246, 249, 1)","title":"Annual Profit 2015","margin":{"r":30,"l":40,"b":80,"t":100},"height":600}, {showLink: false});

 </script>



```julia
function bar11()
    trace1 = bar(;x=[1, 2, 3, 4],
                  y=[1, 4, 9, 16],
                  name="Trace1")
    trace2 = bar(;x=[1, 2, 3, 4],
                  y=[6, -8, -4.5, 8],
                  name="Trace2")
    trace3 = bar(;x=[1, 2, 3, 4],
                  y=[-15, -3, 4.5, -8],
                  name="Trace3")
    trace4 = bar(;x=[1, 2, 3, 4],
                  y=[-1, 3, -3, -4],
                  name="Trace4")
    data = [trace1, trace2, trace3, trace4]
    layout = Layout(;xaxis_title="X axis",
                     yaxis_title="Y axis",
                     barmode="relative",
                     title="Relative Barmode")
    plot(data, layout)
end
bar11()
```


<div id="4b91c868-1fc4-4794-903c-647f1f4d3659" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('4b91c868-1fc4-4794-903c-647f1f4d3659', [{"y":[1,4,9,16],"name":"Trace1","type":"bar","x":[1,2,3,4]},{"y":[6.0,-8.0,-4.5,8.0],"name":"Trace2","type":"bar","x":[1,2,3,4]},{"y":[-15.0,-3.0,4.5,-8.0],"name":"Trace3","type":"bar","x":[1,2,3,4]},{"y":[-1,3,-3,-4],"name":"Trace4","type":"bar","x":[1,2,3,4]}],
               {"yaxis":{"title":"Y axis"},"barmode":"relative","xaxis":{"title":"X axis"},"title":"Relative Barmode","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



