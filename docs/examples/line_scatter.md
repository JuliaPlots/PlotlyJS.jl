```julia
function linescatter1()
    trace1 = scatter(;x=1:4, y=[10, 15, 13, 17], mode="markers")
    trace2 = scatter(;x=2:5, y=[16, 5, 11, 9], mode="lines")
    trace3 = scatter(;x=1:4, y=[12, 9, 15, 12], mode="lines+markers")
    plot([trace1, trace2, trace3])
end
linescatter1()
```


<div id="336b9a2d-908a-4d1c-89b2-660e24bf0e2a"></div>

<script>
   thediv = document.getElementById('336b9a2d-908a-4d1c-89b2-660e24bf0e2a');
var data = [{"type":"scatter","y":[10,15,13,17],"x":[1,2,3,4],"mode":"markers"},{"type":"scatter","y":[16,5,11,9],"x":[2,3,4,5],"mode":"lines"},{"type":"scatter","y":[12,9,15,12],"x":[1,2,3,4],"mode":"lines+markers"}]
var layout = {"margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function linescatter2()
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
linescatter2()
```


<div id="486867b7-3f67-4164-b072-76e0d3dfcd8a"></div>

<script>
   thediv = document.getElementById('486867b7-3f67-4164-b072-76e0d3dfcd8a');
var data = [{"type":"scatter","y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"name":"Team A","x":[1,2,3,4,5],"mode":"markers","marker":{"size":12}},{"type":"scatter","y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"name":"Team B","x":[1.0,2.0,3.0,4.0,5.0],"mode":"markers","marker":{"size":12}}]
var layout = {"yaxis":{"range":[0,8]},"xaxis":{"range":[0.75,5.25]},"title":"Data Labels Hover","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function linescatter3()
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
linescatter3()
```


<div id="1a78aaf7-46a8-480e-b3bc-8100f9b7bc8f"></div>

<script>
   thediv = document.getElementById('1a78aaf7-46a8-480e-b3bc-8100f9b7bc8f');
var data = [{"type":"scatter","y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"textfont":{"family":"Raleway, sans-serif"},"name":"Team A","x":[1,2,3,4,5],"textposition":"top center","mode":"markers+text","marker":{"size":12}},{"type":"scatter","y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"textfont":{"family":"Times New Roman"},"name":"Team B","x":[1.0,2.0,3.0,4.0,5.0],"textposition":"bottom center","mode":"markers+text","marker":{"size":12}}]
var layout = {"yaxis":{"range":[0,8]},"legend":{"y":0.5,"font":{"size":20,"color":"grey","family":"Arial, sans-serif"},"yref":"paper"},"xaxis":{"range":[0.75,5.25]},"title":"Data Labels on the Plot","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function linescatter4()
    trace1 = scatter(;y=fill(5, 40), mode="markers", marker_size=40,
                      marker_color=0:39)
    layout = Layout(title="Scatter Plot with a Color Dimension")
    plot(trace1, layout)
end
linescatter4()
```


<div id="41207667-e9cc-4edd-b997-9a67b3619f11"></div>

<script>
   thediv = document.getElementById('41207667-e9cc-4edd-b997-9a67b3619f11');
var data = [{"type":"scatter","y":[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],"mode":"markers","marker":{"size":40,"color":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39]}}]
var layout = {"title":"Scatter Plot with a Color Dimension","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function linescatter5()

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
linescatter5()
```


<div id="9cb69bbc-6368-43d4-826a-39779e13708e"></div>

<script>
   thediv = document.getElementById('9cb69bbc-6368-43d4-826a-39779e13708e');
var data = [{"type":"scatter","y":["Switzerland (2011)","Chile (2013)","Japan (2014)","United States (2012)","Slovenia (2014)","Canada (2011)","Poland (2010)","Estonia (2015)","Luxembourg (2013)","Portugal (2011)"],"name":"Percent of estimated voting age population","x":[40.0,45.7,52.0,53.6,54.1,54.2,54.5,54.7,55.1,56.6],"mode":"markers","marker":{"symbol":"circle","line":{"width":1,"color":"rgba(156, 165, 196, 1.0)"},"size":16,"color":"rgba(156, 165, 196, 0.95)"}},{"type":"scatter","y":["Switzerland (2011)","Chile (2013)","Japan (2014)","United States (2012)","Slovenia (2014)","Canada (2011)","Poland (2010)","Estonia (2015)","Luxembourg (2013)","Portugal (2011)"],"name":"Percent of estimated registered voters","x":[49.1,42.0,52.7,84.3,51.7,61.1,55.3,64.2,91.1,58.9],"mode":"markers","marker":{"symbol":"circle","line":{"width":1,"color":"rgba(217, 217, 217, 1.0)"},"size":16,"color":"rgba(204, 204, 204, 0.95)"}}]
var layout = {"width":600,"hovermode":"closest","plot_bgcolor":"rgb(254, 247, 234)","legend":{"font":{"size":10},"xanchor":"right","yanchor":"middle"},"xaxis":{"linecolor":"rgb(102, 102, 102)","showline":true,"titlefont":{"font":{"color":"rgb(204, 204, 204)"}},"tickcolor":"rgb(102, 102, 102)","showgrid":false,"tickfont":{"font":{"color":"rgb(102, 102, 102)"}},"dtick":10,"ticks":"outside","autotick":false},"paper_bgcolor":"rgb(254, 247, 234)","title":"Votes cast for ten lowest voting age population in OECD countries","margin":{"r":40,"l":140,"b":50,"t":80},"height":600}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function linescatter6()
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
linescatter6()
```


<div id="640c401a-5728-4f7a-8216-80ff37d2d18b"></div>

<script>
   thediv = document.getElementById('640c401a-5728-4f7a-8216-80ff37d2d18b');
var data = [{"type":"scatter","y":[53,31],"text":["United States","Canada"],"name":"North America","x":[52698,43117],"mode":"markers","marker":{"line":{"width":0.5,"color":"white"},"size":12,"color":"rgb(164, 194, 244)"}},{"type":"scatter","y":[33,20,13,19,27,19,49,44,38],"text":["Germany","Britain","France","Spain","Italy","Czech Rep.","Greece","Poland"],"name":"Europe","x":[39317,37236,35650,30066,29570,27159,23557,21046,18007],"mode":"markers","marker":{"size":12,"color":"rgb(255, 217, 102)"}},{"type":"scatter","y":[23,42,54,89,14,99,93,70],"text":["Australia","Japan","South Korea","Malaysia","China","Indonesia","Philippines","India"],"name":"Asia/Pacific","x":[42952,37037,33106,17478,9813,5253,4692,3899],"mode":"markers","marker":{"size":12,"color":"rgb(234, 153, 153)"}},{"type":"scatter","y":[43,47,56,80,86,93,80],"text":["Chile","Argentina","Mexico","Venezuela","Venezuela","El Salvador","Bolivia"],"name":"Latin America","x":[19097,18601,15595,13546,12026,7434,5419],"mode":"markers","marker":{"size":12,"color":"rgb(142, 124, 195)"}}]
var layout = {"yaxis":{"showline":false,"title":"Percent"},"xaxis":{"title":"GDP per Capita","showgrid":false,"zeroline":false},"title":"Quarter 1 Growth","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function batman()
    σ(x) = √(1-x.^2)
    el(x) = 3*σ(x/7)
    s(x) = 4.2 - 0.5*x - 2.0*σ(0.5*x-0.5)
    b(x) = σ(abs(2-x)-1) - x.^2/11 + 0.5x - 3
    c(x) = [1.7, 1.7, 2.6, 0.9]

    p(i, f; kwargs...) = scatter(;x=[-i; 0.0; i], y=[f(i); NaN; f(i)],
                                  marker_color="black", showlegend=false,
                                  kwargs...)
    traces = vcat(p(3:0.1:7, el; name="wings 1"),
                  p(4:0.1:7, t->-el(t); name="wings 2"),
                  p(1:0.1:3, s; name="Shoulders"),
                  p(0:0.1:4, b; name="Bottom"),
                  p([0, 0.5, 0.8, 1], c; name="head"))

    plot(traces, Layout(title="Batman"))
end
batman()
```


<div id="65173ff4-c59a-41d8-b117-08d832f56fde"></div>

<script>
   thediv = document.getElementById('65173ff4-c59a-41d8-b117-08d832f56fde');
var data = [{"type":"scatter","y":[2.710523708715754,2.6897765630594064,2.6681798427897228,2.6457127429801117,2.622352892704861,2.598076211353316,2.572856746252052,2.5466664885849566,2.519475164005555,2.491249993600049,2.4619554199448697,2.431552791857877,2.4000000000000004,2.367251053652825,2.3332555866542055,2.2979582774493443,2.2612981642753573,2.223207831315932,2.183612434775485,2.142428528562855,2.099562636671296,2.054909501954889,2.008349916661711,1.9597480054583445,1.908947781541722,1.8557687223952257,1.7999999999999996,1.7413928274780042,1.6796501093370366,1.61441213158606,1.5452362609131385,1.4715672611476631,1.392692297937593,1.3076696830622019,1.2152097324649567,1.1134612334371359,0.9995917534020524,0.8688486399734274,0.711996331107265,0.5052782623950675,0.0,null,2.710523708715754,2.6897765630594064,2.6681798427897228,2.6457127429801117,2.622352892704861,2.598076211353316,2.572856746252052,2.5466664885849566,2.519475164005555,2.491249993600049,2.4619554199448697,2.431552791857877,2.4000000000000004,2.367251053652825,2.3332555866542055,2.2979582774493443,2.2612981642753573,2.223207831315932,2.183612434775485,2.142428528562855,2.099562636671296,2.054909501954889,2.008349916661711,1.9597480054583445,1.908947781541722,1.8557687223952257,1.7999999999999996,1.7413928274780042,1.6796501093370366,1.61441213158606,1.5452362609131385,1.4715672611476631,1.392692297937593,1.3076696830622019,1.2152097324649567,1.1134612334371359,0.9995917534020524,0.8688486399734274,0.711996331107265,0.5052782623950675,0.0],"showlegend":false,"name":"wings 1","x":[-3.0,-3.1,-3.2,-3.3,-3.4,-3.5,-3.6,-3.7,-3.8,-3.9,-4.0,-4.1,-4.2,-4.3,-4.4,-4.5,-4.6,-4.7,-4.8,-4.9,-5.0,-5.1,-5.2,-5.3,-5.4,-5.5,-5.6,-5.7,-5.8,-5.9,-6.0,-6.1,-6.2,-6.3,-6.4,-6.5,-6.6,-6.7,-6.8,-6.9,-7.0,0.0,3.0,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0,5.1,5.2,5.3,5.4,5.5,5.6,5.7,5.8,5.9,6.0,6.1,6.2,6.3,6.4,6.5,6.6,6.7,6.8,6.9,7.0],"marker":{"color":"black"}},{"type":"scatter","y":[-2.4619554199448697,-2.431552791857877,-2.4000000000000004,-2.367251053652825,-2.3332555866542055,-2.2979582774493443,-2.2612981642753573,-2.223207831315932,-2.183612434775485,-2.142428528562855,-2.099562636671296,-2.054909501954889,-2.008349916661711,-1.9597480054583445,-1.908947781541722,-1.8557687223952253,-1.7999999999999996,-1.7413928274780042,-1.6796501093370366,-1.6144121315860598,-1.5452362609131385,-1.4715672611476618,-1.392692297937593,-1.3076696830622019,-1.2152097324649567,-1.1134612334371359,-0.9995917534020515,-0.8688486399734274,-0.7119963311072622,-0.5052782623950675,-0.0,null,-2.4619554199448697,-2.431552791857877,-2.4000000000000004,-2.367251053652825,-2.3332555866542055,-2.2979582774493443,-2.2612981642753573,-2.223207831315932,-2.183612434775485,-2.142428528562855,-2.099562636671296,-2.054909501954889,-2.008349916661711,-1.9597480054583445,-1.908947781541722,-1.8557687223952253,-1.7999999999999996,-1.7413928274780042,-1.6796501093370366,-1.6144121315860598,-1.5452362609131385,-1.4715672611476618,-1.392692297937593,-1.3076696830622019,-1.2152097324649567,-1.1134612334371359,-0.9995917534020515,-0.8688486399734274,-0.7119963311072622,-0.5052782623950675,-0.0],"showlegend":false,"name":"wings 2","x":[-4.0,-4.1,-4.2,-4.3,-4.4,-4.5,-4.6,-4.7,-4.8,-4.9,-5.0,-5.1,-5.2,-5.3,-5.4,-5.5,-5.6,-5.7,-5.8,-5.9,-6.0,-6.1,-6.2,-6.3,-6.4,-6.5,-6.6,-6.7,-6.8,-6.9,-7.0,0.0,4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0,5.1,5.2,5.3,5.4,5.5,5.6,5.7,5.8,5.9,6.0,6.1,6.2,6.3,6.4,6.5,6.6,6.7,6.8,6.9,7.0],"marker":{"color":"black"}},{"type":"scatter","y":[1.7000000000000002,1.652501564456182,1.6100251257867602,1.5726280066714808,1.5404082057734576,1.5135083268962917,1.4921215971661086,1.4765006004804806,1.4669697220176638,1.463942890050825,1.467949192431123,1.4796706911509934,1.5,1.5301315846429335,1.57171431429143,1.6271243444677048,1.7000000000000002,1.796434624714726,1.9282202112918654,2.12550020016016,2.7,null,1.7000000000000002,1.652501564456182,1.6100251257867602,1.5726280066714808,1.5404082057734576,1.5135083268962917,1.4921215971661086,1.4765006004804806,1.4669697220176638,1.463942890050825,1.467949192431123,1.4796706911509934,1.5,1.5301315846429335,1.57171431429143,1.6271243444677048,1.7000000000000002,1.796434624714726,1.9282202112918654,2.12550020016016,2.7],"showlegend":false,"name":"Shoulders","x":[-1.0,-1.1,-1.2,-1.3,-1.4,-1.5,-1.6,-1.7,-1.8,-1.9,-2.0,-2.1,-2.2,-2.3,-2.4,-2.5,-2.6,-2.7,-2.8,-2.9,-3.0,0.0,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3.0],"marker":{"color":"black"}},{"type":"scatter","y":[-3.0,-2.5150191965550235,-2.3036363636363637,-2.144038975327533,-2.0145454545454546,-1.906701868942834,-1.8162121337361046,-1.740606253128509,-1.678385921068547,-1.6286489265297437,-1.5909090909090908,-1.56501256289338,-1.5511131937958198,-1.549697162219418,-1.5616666791906502,-1.588520050761016,-1.6327272727272728,-1.6985844298729877,-1.7945454545454547,-1.942291923827751,-2.3636363636363638,-1.9150191965550236,-1.7400000000000002,-1.616766248054806,-1.5236363636363635,-1.4521564143973795,-1.3980303155542866,-1.358788071310327,-1.3329313756140015,-1.3195580174388346,-1.3181818181818183,-1.3286489265297439,-1.3511131937958198,-1.3860607985830544,-1.4343939519179227,-1.497610959851925,-1.5781818181818181,-1.6804026116911697,-1.812727272727273,-1.996837378373205,-2.4545454545454546,null,-3.0,-2.5150191965550235,-2.3036363636363637,-2.144038975327533,-2.0145454545454546,-1.906701868942834,-1.8162121337361046,-1.740606253128509,-1.678385921068547,-1.6286489265297437,-1.5909090909090908,-1.56501256289338,-1.5511131937958198,-1.549697162219418,-1.5616666791906502,-1.588520050761016,-1.6327272727272728,-1.6985844298729877,-1.7945454545454547,-1.942291923827751,-2.3636363636363638,-1.9150191965550236,-1.7400000000000002,-1.616766248054806,-1.5236363636363635,-1.4521564143973795,-1.3980303155542866,-1.358788071310327,-1.3329313756140015,-1.3195580174388346,-1.3181818181818183,-1.3286489265297439,-1.3511131937958198,-1.3860607985830544,-1.4343939519179227,-1.497610959851925,-1.5781818181818181,-1.6804026116911697,-1.812727272727273,-1.996837378373205,-2.4545454545454546],"showlegend":false,"name":"Bottom","x":[-0.0,-0.1,-0.2,-0.3,-0.4,-0.5,-0.6,-0.7,-0.8,-0.9,-1.0,-1.1,-1.2,-1.3,-1.4,-1.5,-1.6,-1.7,-1.8,-1.9,-2.0,-2.1,-2.2,-2.3,-2.4,-2.5,-2.6,-2.7,-2.8,-2.9,-3.0,-3.1,-3.2,-3.3,-3.4,-3.5,-3.6,-3.7,-3.8,-3.9,-4.0,0.0,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3.0,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,4.0],"marker":{"color":"black"}},{"type":"scatter","y":[1.7,1.7,2.6,0.9,null,1.7,1.7,2.6,0.9],"showlegend":false,"name":"head","x":[-0.0,-0.5,-0.8,-1.0,0.0,0.0,0.5,0.8,1.0],"marker":{"color":"black"}}]
var layout = {"title":"Batman","margin":{"r":50,"l":50,"b":50,"t":60}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



