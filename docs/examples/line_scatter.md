```julia
function linescatter1()
    trace1 = scatter(;x=1:4, y=[10, 15, 13, 17], mode="markers")
    trace2 = scatter(;x=2:5, y=[16, 5, 11, 9], mode="lines")
    trace3 = scatter(;x=1:4, y=[12, 9, 15, 12], mode="lines+markers")
    plot([trace1, trace2, trace3])
end
linescatter1()
```


<div id="815b6c28-1169-4248-b35f-d00bfc44f9aa" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('815b6c28-1169-4248-b35f-d00bfc44f9aa', [{"y":[10,15,13,17],"type":"scatter","x":[1,2,3,4],"mode":"markers"},{"y":[16,5,11,9],"type":"scatter","x":[2,3,4,5],"mode":"lines"},{"y":[12,9,15,12],"type":"scatter","x":[1,2,3,4],"mode":"lines+markers"}],
               {"margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

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


<div id="31036a32-7de1-4054-9605-66b359634914" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('31036a32-7de1-4054-9605-66b359634914', [{"y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"name":"Team A","type":"scatter","x":[1,2,3,4,5],"mode":"markers","marker":{"size":12}},{"y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"name":"Team B","type":"scatter","x":[1.0,2.0,3.0,4.0,5.0],"mode":"markers","marker":{"size":12}}],
               {"yaxis":{"range":[0,8]},"xaxis":{"range":[0.75,5.25]},"title":"Data Labels Hover","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

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
                     legend=attr(family="Arial, sans-serif", size=20,
                                 color="grey"))
    plot(data, layout)
end
linescatter3()
```


<div id="09ef5f2c-cdcb-4711-9a30-d3f0aaca6e99" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('09ef5f2c-cdcb-4711-9a30-d3f0aaca6e99', [{"y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"textfont":{"family":"Raleway, sans-serif"},"name":"Team A","type":"scatter","x":[1,2,3,4,5],"textposition":"top center","mode":"markers+text","marker":{"size":12}},{"y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"textfont":{"family":"Times New Roman"},"name":"Team B","type":"scatter","x":[1.0,2.0,3.0,4.0,5.0],"textposition":"bottom center","mode":"markers+text","marker":{"size":12}}],
               {"yaxis":{"range":[0,8]},"legend":{"y":0.5,"size":20,"yref":"paper","color":"grey","family":"Arial, sans-serif"},"xaxis":{"range":[0.75,5.25]},"title":"Data Labels on the Plot","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

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


<div id="b999ee09-6f83-425c-af43-121030dde32f" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('b999ee09-6f83-425c-af43-121030dde32f', [{"y":[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],"type":"scatter","mode":"markers","marker":{"size":40,"color":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39]}}],
               {"title":"Scatter Plot with a Color Dimension","margin":{"r":30,"l":40,"b":80,"t":100}}, {showLink: false});

 </script>



```julia
function linescatter5()

    country = ["Switzerland (2011)", "Chile (2013)", "Japan (2014)",
               "United States (2012)", "Slovenia (2014)", "Canada (2011)",
               "Poland (2010)", "Estonia (2015)", "Luxembourg (2013)",
               "Portugal (2011)"]

    votingPop = [40, 45.7, 52, 53.6, 54.1, 54.2, 54.5, 54.7, 55.1, 56.6]
    regVoters = [49.1, 42, 52.7, 84.3, 51.7, 61.1, 55.3, 64.2, 91.1, 58.9]

    # notice use of `attr` function to make nested attributes
    trace1 = scatter(;x=votingPop, y=country, mode="markers",
                      name="Percent of estimated voting age population",
                      marker=attr(color="rgba(156, 165, 196, 0.95)",
                                  line_color="rgba(156, 165, 196, 1.0)",
                                  line_width=1, size=16, symbol="circle"))

    trace2 = scatter(;x=regVoters, y=country, mode="markers",
                      name="Percent of estimated registered voters")
    # also could have set the marker props above by using a dict
    trace2["marker"] = Dict(:color => "rgba(204, 204, 204, 0.95)",
                           :line => Dict(:color=> "rgba(217, 217, 217, 1.0)",
                                         :width=> 1),
                           :symbol => "circle",
                           :size => 16)

    data = [trace1, trace2]
    layout = Layout(Dict{Symbol,Any}(:paper_bgcolor => "rgb(254, 247, 234)",
                                     :plot_bgcolor => "rgb(254, 247, 234)");
                    title="Votes cast for ten lowest voting age population in OECD countries",
                    width=600, height=600, hovermode="closest",
                    margin=Dict(:l => 140, :r => 40, :b => 50, :t => 80),
                    xaxis=attr(showgrid=false, showline=true,
                               linecolor="rgb(102, 102, 102)",
                               titlefont_font_color="rgb(204, 204, 204)",
                               tickfont_font_color="rgb(102, 102, 102)",
                               autotick=false, dtick=10, ticks="outside",
                               tickcolor="rgb(102, 102, 102)"),
                    legend=attr(font_size=10, yanchor="middle",
                                xanchor="right"),
                    )
    plot(data, layout)
end
linescatter5()
```


<div id="f32b32eb-a711-429c-ae7e-fd3e209f30e5" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('f32b32eb-a711-429c-ae7e-fd3e209f30e5', [{"y":["Switzerland (2011)","Chile (2013)","Japan (2014)","United States (2012)","Slovenia (2014)","Canada (2011)","Poland (2010)","Estonia (2015)","Luxembourg (2013)","Portugal (2011)"],"name":"Percent of estimated voting age population","type":"scatter","x":[40.0,45.7,52.0,53.6,54.1,54.2,54.5,54.7,55.1,56.6],"mode":"markers","marker":{"symbol":"circle","line":{"width":1,"color":"rgba(156, 165, 196, 1.0)"},"size":16,"color":"rgba(156, 165, 196, 0.95)"}},{"y":["Switzerland (2011)","Chile (2013)","Japan (2014)","United States (2012)","Slovenia (2014)","Canada (2011)","Poland (2010)","Estonia (2015)","Luxembourg (2013)","Portugal (2011)"],"name":"Percent of estimated registered voters","type":"scatter","x":[49.1,42.0,52.7,84.3,51.7,61.1,55.3,64.2,91.1,58.9],"mode":"markers","marker":{"symbol":"circle","line":{"width":1,"color":"rgba(217, 217, 217, 1.0)"},"size":16,"color":"rgba(204, 204, 204, 0.95)"}}],
               {"plot_bgcolor":"rgb(254, 247, 234)","width":600,"hovermode":"closest","legend":{"font":{"size":10},"xanchor":"right","yanchor":"middle"},"xaxis":{"linecolor":"rgb(102, 102, 102)","showline":true,"titlefont":{"font":{"color":"rgb(204, 204, 204)"}},"tickcolor":"rgb(102, 102, 102)","showgrid":false,"tickfont":{"font":{"color":"rgb(102, 102, 102)"}},"dtick":10,"ticks":"outside","autotick":false},"paper_bgcolor":"rgb(254, 247, 234)","title":"Votes cast for ten lowest voting age population in OECD countries","margin":{"r":40,"l":140,"b":50,"t":80},"height":600}, {showLink: false});

 </script>



```julia
function linescatter6()
    trace1 = scatter(;x=[52698, 43117], y=[53, 31],
                      mode="markers",
                      name="North America",
                      text=["United States", "Canada"],
                      marker=attr(color="rgb(164, 194, 244)", size=12,
                                  line=attr(color="white", width=0.5))
                      )

    trace2 = scatter(;x=[39317, 37236, 35650, 30066, 29570, 27159, 23557, 21046, 18007],
                      y=[33, 20, 13, 19, 27, 19, 49, 44, 38],
                      mode="markers", name="Europe",
                      marker_size=12, marker_color="rgb(255, 217, 102)",
                      text=["Germany", "Britain", "France", "Spain", "Italy",
                            "Czech Rep.", "Greece", "Poland", "Portugal"])

    trace3 = scatter(;x=[42952, 37037, 33106, 17478, 9813, 5253, 4692, 3899],
                      y=[23, 42, 54, 89, 14, 99, 93, 70],
                      mode="markers",
                      name="Asia/Pacific",
                      marker_size=12, marker_color="rgb(234, 153, 153)",
                      text=["Australia", "Japan", "South Korea", "Malaysia",
                            "China", "Indonesia", "Philippines", "India"])

    trace4 = scatter(;x=[19097, 18601, 15595, 13546, 12026, 7434, 5419],
                      y=[43, 47, 56, 80, 86, 93, 80],
                      mode="markers", name="Latin America",
                      marker_size=12, marker_color="rgb(142, 124, 195)",
                      text=["Chile", "Argentina", "Mexico", "Venezuela",
                            "Venezuela", "El Salvador", "Bolivia"])

    data = [trace1, trace2, trace3, trace4]

    layout = Layout(;title="Quarter 1 Growth",
                     xaxis=attr(title="GDP per Capital", showgrid=false, zeroline=false),
                     yaxis=attr(title="Percent", zeroline=false))

    plot(data, layout)
end
linescatter6()
```


<div id="8ec60f1e-6fd0-4741-ace5-dcb2c0b8f62e" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('8ec60f1e-6fd0-4741-ace5-dcb2c0b8f62e', [{"y":[53,31],"text":["United States","Canada"],"name":"North America","type":"scatter","x":[52698,43117],"mode":"markers","marker":{"line":{"width":0.5,"color":"white"},"size":12,"color":"rgb(164, 194, 244)"}},{"y":[33,20,13,19,27,19,49,44,38],"text":["Germany","Britain","France","Spain","Italy","Czech Rep.","Greece","Poland","Portugal"],"name":"Europe","type":"scatter","x":[39317,37236,35650,30066,29570,27159,23557,21046,18007],"mode":"markers","marker":{"size":12,"color":"rgb(255, 217, 102)"}},{"y":[23,42,54,89,14,99,93,70],"text":["Australia","Japan","South Korea","Malaysia","China","Indonesia","Philippines","India"],"name":"Asia/Pacific","type":"scatter","x":[42952,37037,33106,17478,9813,5253,4692,3899],"mode":"markers","marker":{"size":12,"color":"rgb(234, 153, 153)"}},{"y":[43,47,56,80,86,93,80],"text":["Chile","Argentina","Mexico","Venezuela","Venezuela","El Salvador","Bolivia"],"name":"Latin America","type":"scatter","x":[19097,18601,15595,13546,12026,7434,5419],"mode":"markers","marker":{"size":12,"color":"rgb(142, 124, 195)"}}],
               {"yaxis":{"title":"Percent","zeroline":false},"xaxis":{"title":"GDP per Capital","showgrid":false,"zeroline":false},"title":"Quarter 1 Growth","margin":{"r":40,"l":140,"b":50,"t":80}}, {showLink: false});

 </script>



```julia
function batman()
    # reference: https://github.com/alanedelman/18.337_2015/blob/master/Lecture01_0909/The%20Bat%20Curve.ipynb
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


<div id="cda992d1-d0cc-46f7-be6f-7239702ded8a" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('cda992d1-d0cc-46f7-be6f-7239702ded8a', [{"y":[2.710523708715754,2.6897765630594064,2.6681798427897228,2.6457127429801117,2.622352892704861,2.598076211353316,2.572856746252052,2.5466664885849566,2.519475164005555,2.491249993600049,2.4619554199448697,2.431552791857877,2.4000000000000004,2.367251053652825,2.3332555866542055,2.2979582774493443,2.2612981642753573,2.223207831315932,2.183612434775485,2.142428528562855,2.099562636671296,2.054909501954889,2.008349916661711,1.9597480054583445,1.908947781541722,1.8557687223952257,1.7999999999999996,1.7413928274780042,1.6796501093370366,1.61441213158606,1.5452362609131385,1.4715672611476631,1.392692297937593,1.3076696830622019,1.2152097324649567,1.1134612334371359,0.9995917534020524,0.8688486399734274,0.711996331107265,0.5052782623950675,0.0,null,2.710523708715754,2.6897765630594064,2.6681798427897228,2.6457127429801117,2.622352892704861,2.598076211353316,2.572856746252052,2.5466664885849566,2.519475164005555,2.491249993600049,2.4619554199448697,2.431552791857877,2.4000000000000004,2.367251053652825,2.3332555866542055,2.2979582774493443,2.2612981642753573,2.223207831315932,2.183612434775485,2.142428528562855,2.099562636671296,2.054909501954889,2.008349916661711,1.9597480054583445,1.908947781541722,1.8557687223952257,1.7999999999999996,1.7413928274780042,1.6796501093370366,1.61441213158606,1.5452362609131385,1.4715672611476631,1.392692297937593,1.3076696830622019,1.2152097324649567,1.1134612334371359,0.9995917534020524,0.8688486399734274,0.711996331107265,0.5052782623950675,0.0],"showlegend":false,"name":"wings 1","type":"scatter","x":[-3.0,-3.1,-3.2,-3.3,-3.4,-3.5,-3.6,-3.7,-3.8,-3.9,-4.0,-4.1,-4.2,-4.3,-4.4,-4.5,-4.6,-4.7,-4.8,-4.9,-5.0,-5.1,-5.2,-5.3,-5.4,-5.5,-5.6,-5.7,-5.8,-5.9,-6.0,-6.1,-6.2,-6.3,-6.4,-6.5,-6.6,-6.7,-6.8,-6.9,-7.0,0.0,3.0,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0,5.1,5.2,5.3,5.4,5.5,5.6,5.7,5.8,5.9,6.0,6.1,6.2,6.3,6.4,6.5,6.6,6.7,6.8,6.9,7.0],"marker":{"color":"black"}},{"y":[-2.4619554199448697,-2.431552791857877,-2.4000000000000004,-2.367251053652825,-2.3332555866542055,-2.2979582774493443,-2.2612981642753573,-2.223207831315932,-2.183612434775485,-2.142428528562855,-2.099562636671296,-2.054909501954889,-2.008349916661711,-1.9597480054583445,-1.908947781541722,-1.8557687223952253,-1.7999999999999996,-1.7413928274780042,-1.6796501093370366,-1.6144121315860598,-1.5452362609131385,-1.4715672611476618,-1.392692297937593,-1.3076696830622019,-1.2152097324649567,-1.1134612334371359,-0.9995917534020515,-0.8688486399734274,-0.7119963311072622,-0.5052782623950675,-0.0,null,-2.4619554199448697,-2.431552791857877,-2.4000000000000004,-2.367251053652825,-2.3332555866542055,-2.2979582774493443,-2.2612981642753573,-2.223207831315932,-2.183612434775485,-2.142428528562855,-2.099562636671296,-2.054909501954889,-2.008349916661711,-1.9597480054583445,-1.908947781541722,-1.8557687223952253,-1.7999999999999996,-1.7413928274780042,-1.6796501093370366,-1.6144121315860598,-1.5452362609131385,-1.4715672611476618,-1.392692297937593,-1.3076696830622019,-1.2152097324649567,-1.1134612334371359,-0.9995917534020515,-0.8688486399734274,-0.7119963311072622,-0.5052782623950675,-0.0],"showlegend":false,"name":"wings 2","type":"scatter","x":[-4.0,-4.1,-4.2,-4.3,-4.4,-4.5,-4.6,-4.7,-4.8,-4.9,-5.0,-5.1,-5.2,-5.3,-5.4,-5.5,-5.6,-5.7,-5.8,-5.9,-6.0,-6.1,-6.2,-6.3,-6.4,-6.5,-6.6,-6.7,-6.8,-6.9,-7.0,0.0,4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0,5.1,5.2,5.3,5.4,5.5,5.6,5.7,5.8,5.9,6.0,6.1,6.2,6.3,6.4,6.5,6.6,6.7,6.8,6.9,7.0],"marker":{"color":"black"}},{"y":[1.7000000000000002,1.652501564456182,1.6100251257867602,1.5726280066714808,1.5404082057734576,1.5135083268962917,1.4921215971661086,1.4765006004804806,1.4669697220176638,1.463942890050825,1.467949192431123,1.4796706911509934,1.5,1.5301315846429335,1.57171431429143,1.6271243444677048,1.7000000000000002,1.796434624714726,1.9282202112918654,2.12550020016016,2.7,null,1.7000000000000002,1.652501564456182,1.6100251257867602,1.5726280066714808,1.5404082057734576,1.5135083268962917,1.4921215971661086,1.4765006004804806,1.4669697220176638,1.463942890050825,1.467949192431123,1.4796706911509934,1.5,1.5301315846429335,1.57171431429143,1.6271243444677048,1.7000000000000002,1.796434624714726,1.9282202112918654,2.12550020016016,2.7],"showlegend":false,"name":"Shoulders","type":"scatter","x":[-1.0,-1.1,-1.2,-1.3,-1.4,-1.5,-1.6,-1.7,-1.8,-1.9,-2.0,-2.1,-2.2,-2.3,-2.4,-2.5,-2.6,-2.7,-2.8,-2.9,-3.0,0.0,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3.0],"marker":{"color":"black"}},{"y":[-3.0,-2.5150191965550235,-2.3036363636363637,-2.144038975327533,-2.0145454545454546,-1.906701868942834,-1.8162121337361046,-1.740606253128509,-1.678385921068547,-1.6286489265297437,-1.5909090909090908,-1.56501256289338,-1.5511131937958198,-1.549697162219418,-1.5616666791906502,-1.588520050761016,-1.6327272727272728,-1.6985844298729877,-1.7945454545454547,-1.942291923827751,-2.3636363636363638,-1.9150191965550236,-1.7400000000000002,-1.616766248054806,-1.5236363636363635,-1.4521564143973795,-1.3980303155542866,-1.358788071310327,-1.3329313756140015,-1.3195580174388346,-1.3181818181818183,-1.3286489265297439,-1.3511131937958198,-1.3860607985830544,-1.4343939519179227,-1.497610959851925,-1.5781818181818181,-1.6804026116911697,-1.812727272727273,-1.996837378373205,-2.4545454545454546,null,-3.0,-2.5150191965550235,-2.3036363636363637,-2.144038975327533,-2.0145454545454546,-1.906701868942834,-1.8162121337361046,-1.740606253128509,-1.678385921068547,-1.6286489265297437,-1.5909090909090908,-1.56501256289338,-1.5511131937958198,-1.549697162219418,-1.5616666791906502,-1.588520050761016,-1.6327272727272728,-1.6985844298729877,-1.7945454545454547,-1.942291923827751,-2.3636363636363638,-1.9150191965550236,-1.7400000000000002,-1.616766248054806,-1.5236363636363635,-1.4521564143973795,-1.3980303155542866,-1.358788071310327,-1.3329313756140015,-1.3195580174388346,-1.3181818181818183,-1.3286489265297439,-1.3511131937958198,-1.3860607985830544,-1.4343939519179227,-1.497610959851925,-1.5781818181818181,-1.6804026116911697,-1.812727272727273,-1.996837378373205,-2.4545454545454546],"showlegend":false,"name":"Bottom","type":"scatter","x":[-0.0,-0.1,-0.2,-0.3,-0.4,-0.5,-0.6,-0.7,-0.8,-0.9,-1.0,-1.1,-1.2,-1.3,-1.4,-1.5,-1.6,-1.7,-1.8,-1.9,-2.0,-2.1,-2.2,-2.3,-2.4,-2.5,-2.6,-2.7,-2.8,-2.9,-3.0,-3.1,-3.2,-3.3,-3.4,-3.5,-3.6,-3.7,-3.8,-3.9,-4.0,0.0,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3.0,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,4.0],"marker":{"color":"black"}},{"y":[1.7,1.7,2.6,0.9,null,1.7,1.7,2.6,0.9],"showlegend":false,"name":"head","type":"scatter","x":[-0.0,-0.5,-0.8,-1.0,0.0,0.0,0.5,0.8,1.0],"marker":{"color":"black"}}],
               {"title":"Batman","margin":{"r":40,"l":140,"b":50,"t":80}}, {showLink: false});

 </script>



```julia
function dumbell()
    # reference: https://plot.ly/r/dumbbell-plots/
    @eval using DataFrames

    # read Data into dataframe
    nm = tempname()
    url = "https://raw.githubusercontent.com/plotly/datasets/master/school_earnings.csv"
    download(url, nm)
    df = readtable(nm)
    rm(nm)

    # sort dataframe by male earnings
    df = sort(df, cols=[:Men], rev=false)

    men = scatter(;y=df[:School], x=df[:Men], mode="markers", name="Men",
                   marker=attr(color="blue", size=12))
    women = scatter(;y=df[:School], x=df[:Women], mode="markers", name="Women",
                     marker=attr(color="pink", size=12))

    lines = map(eachrow(df)) do r
        scatter(y=fill(r[:School], 2), x=[r[:Women], r[:Men]], mode="lines",
                name=r[:School], showlegend=false, line_color="gray")
    end

    data = Base.typed_vcat(GenericTrace, men, women, lines)
    layout = Layout(width=650, height=650, margin_l=100, yaxis_title="School",
                    xaxis_title="Annual Salary (thousands)",
                    title="Gender earnings disparity")

    plot(data, layout)
end
dumbell()
```


<div id="9e518137-a3c2-4682-8e6b-16f91b18ad72" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('9e518137-a3c2-4682-8e6b-16f91b18ad72', [{"y":["UCLA","SoCal","Emory","Michigan","Berkeley","Brown","NYU","Notre Dame","Cornell","Tufts","Yale","Dartmouth","Chicago","Columbia","Duke","Georgetown","Princeton","U.Penn","Stanford","MIT","Harvard"],"name":"Men","type":"scatter","x":[78,81,82,84,88,92,94,100,107,112,114,114,118,119,124,131,137,141,151,152,165],"mode":"markers","marker":{"size":12,"color":"blue"}},{"y":["UCLA","SoCal","Emory","Michigan","Berkeley","Brown","NYU","Notre Dame","Cornell","Tufts","Yale","Dartmouth","Chicago","Columbia","Duke","Georgetown","Princeton","U.Penn","Stanford","MIT","Harvard"],"name":"Women","type":"scatter","x":[64,72,68,62,71,72,67,73,80,76,79,84,78,86,93,94,90,92,96,94,112],"mode":"markers","marker":{"size":12,"color":"pink"}},{"y":["UCLA","UCLA"],"showlegend":false,"name":"UCLA","type":"scatter","line":{"color":"gray"},"x":[64,78],"mode":"lines"},{"y":["SoCal","SoCal"],"showlegend":false,"name":"SoCal","type":"scatter","line":{"color":"gray"},"x":[72,81],"mode":"lines"},{"y":["Emory","Emory"],"showlegend":false,"name":"Emory","type":"scatter","line":{"color":"gray"},"x":[68,82],"mode":"lines"},{"y":["Michigan","Michigan"],"showlegend":false,"name":"Michigan","type":"scatter","line":{"color":"gray"},"x":[62,84],"mode":"lines"},{"y":["Berkeley","Berkeley"],"showlegend":false,"name":"Berkeley","type":"scatter","line":{"color":"gray"},"x":[71,88],"mode":"lines"},{"y":["Brown","Brown"],"showlegend":false,"name":"Brown","type":"scatter","line":{"color":"gray"},"x":[72,92],"mode":"lines"},{"y":["NYU","NYU"],"showlegend":false,"name":"NYU","type":"scatter","line":{"color":"gray"},"x":[67,94],"mode":"lines"},{"y":["Notre Dame","Notre Dame"],"showlegend":false,"name":"Notre Dame","type":"scatter","line":{"color":"gray"},"x":[73,100],"mode":"lines"},{"y":["Cornell","Cornell"],"showlegend":false,"name":"Cornell","type":"scatter","line":{"color":"gray"},"x":[80,107],"mode":"lines"},{"y":["Tufts","Tufts"],"showlegend":false,"name":"Tufts","type":"scatter","line":{"color":"gray"},"x":[76,112],"mode":"lines"},{"y":["Yale","Yale"],"showlegend":false,"name":"Yale","type":"scatter","line":{"color":"gray"},"x":[79,114],"mode":"lines"},{"y":["Dartmouth","Dartmouth"],"showlegend":false,"name":"Dartmouth","type":"scatter","line":{"color":"gray"},"x":[84,114],"mode":"lines"},{"y":["Chicago","Chicago"],"showlegend":false,"name":"Chicago","type":"scatter","line":{"color":"gray"},"x":[78,118],"mode":"lines"},{"y":["Columbia","Columbia"],"showlegend":false,"name":"Columbia","type":"scatter","line":{"color":"gray"},"x":[86,119],"mode":"lines"},{"y":["Duke","Duke"],"showlegend":false,"name":"Duke","type":"scatter","line":{"color":"gray"},"x":[93,124],"mode":"lines"},{"y":["Georgetown","Georgetown"],"showlegend":false,"name":"Georgetown","type":"scatter","line":{"color":"gray"},"x":[94,131],"mode":"lines"},{"y":["Princeton","Princeton"],"showlegend":false,"name":"Princeton","type":"scatter","line":{"color":"gray"},"x":[90,137],"mode":"lines"},{"y":["U.Penn","U.Penn"],"showlegend":false,"name":"U.Penn","type":"scatter","line":{"color":"gray"},"x":[92,141],"mode":"lines"},{"y":["Stanford","Stanford"],"showlegend":false,"name":"Stanford","type":"scatter","line":{"color":"gray"},"x":[96,151],"mode":"lines"},{"y":["MIT","MIT"],"showlegend":false,"name":"MIT","type":"scatter","line":{"color":"gray"},"x":[94,152],"mode":"lines"},{"y":["Harvard","Harvard"],"showlegend":false,"name":"Harvard","type":"scatter","line":{"color":"gray"},"x":[112,165],"mode":"lines"}],
               {"yaxis":{"title":"School"},"width":650,"xaxis":{"title":"Annual Salary (thousands)"},"title":"Gender earnings disparity","margin":{"r":40,"l":100,"b":50,"t":80},"height":650}, {showLink: false});

 </script>



```julia
function errorbars1()
    trace1 = scatter(;x=vcat(1:10, 10:-1:1),
                     y=vcat(2:11, 9:-1:0),
                     fill="tozerox",
                     fillcolor="rgba(0, 100, 80, 0.2)",
                     line_color="transparent",
                     name="Fair",
                     showlegend=false)

    trace2 = scatter(;x=vcat(1:10, 10:-1:1),
                     y=[5.5, 3.0, 5.5, 8.0, 6.0, 3.0, 8.0, 5.0, 6.0, 5.5, 4.75,
                        5.0, 4.0, 7.0, 2.0, 4.0, 7.0, 4.4, 2.0, 4.5],
                     fill="tozerox",
                     fillcolor="rgba(0, 176, 246, 0.2)",
                     line_color="transparent",
                     name="Premium",
                     showlegend=false)

    trace3 = scatter(;x=vcat(1:10, 10:-1:1),
                     y=[11.0, 9.0, 7.0, 5.0, 3.0, 1.0, 3.0, 5.0, 3.0, 1.0,
                        -1.0, 1.0, 3.0, 1.0, -0.5, 1.0, 3.0, 5.0, 7.0, 9.],
                     fill="tozerox",
                     fillcolor="rgba(231, 107, 243, 0.2)",
                     line_color="transparent",
                     name="Fair",
                     showlegend=false)

    trace4 = scatter(;x=1:10, y=1:10,
                     line_color="rgb(00, 100, 80)",
                     mode="lines",
                     name="Fair")

    trace5 = scatter(;x=1:10,
                     y=[5.0, 2.5, 5.0, 7.5, 5.0, 2.5, 7.5, 4.5, 5.5, 5.],
                     line_color="rgb(0, 176, 246)",
                     mode="lines",
                     name="Premium")

    trace6 = scatter(;x=1:10, y=vcat(10:-2:0, [2, 4,2, 0]),
                     line_color="rgb(231, 107, 243)",
                     mode="lines",
                     name="Ideal")
    data = [trace1, trace2, trace3, trace4, trace5, trace6]
    layout = Layout(;paper_bgcolor="rgb(255, 255, 255)",
                    plot_bgcolor="rgb(229, 229, 229)",

                    xaxis=attr(gridcolor="rgb(255, 255, 255)",
                               range=[1, 10],
                               showgrid=true,
                               showline=false,
                               showticklabels=true,
                               tickcolor="rgb(127, 127, 127)",
                               ticks="outside",
                               zeroline=false),

                    yaxis=attr(gridcolor="rgb(255, 255, 255)",
                               showgrid=true,
                               showline=false,
                               showticklabels=true,
                               tickcolor="rgb(127, 127, 127)",
                               ticks="outside",
                               zeroline=false))

    plot(data, layout)
end
errorbars1()
```


<div id="4dae8fe1-3196-4f92-92d0-79493546bc38" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('4dae8fe1-3196-4f92-92d0-79493546bc38', [{"y":[2,3,4,5,6,7,8,9,10,11,9,8,7,6,5,4,3,2,1,0],"showlegend":false,"name":"Fair","type":"scatter","fillcolor":"rgba(0, 100, 80, 0.2)","line":{"color":"transparent"},"x":[1,2,3,4,5,6,7,8,9,10,10,9,8,7,6,5,4,3,2,1],"fill":"tozerox"},{"y":[5.5,3.0,5.5,8.0,6.0,3.0,8.0,5.0,6.0,5.5,4.75,5.0,4.0,7.0,2.0,4.0,7.0,4.4,2.0,4.5],"showlegend":false,"name":"Premium","type":"scatter","fillcolor":"rgba(0, 176, 246, 0.2)","line":{"color":"transparent"},"x":[1,2,3,4,5,6,7,8,9,10,10,9,8,7,6,5,4,3,2,1],"fill":"tozerox"},{"y":[11.0,9.0,7.0,5.0,3.0,1.0,3.0,5.0,3.0,1.0,-1.0,1.0,3.0,1.0,-0.5,1.0,3.0,5.0,7.0,9.0],"showlegend":false,"name":"Fair","type":"scatter","fillcolor":"rgba(231, 107, 243, 0.2)","line":{"color":"transparent"},"x":[1,2,3,4,5,6,7,8,9,10,10,9,8,7,6,5,4,3,2,1],"fill":"tozerox"},{"y":[1,2,3,4,5,6,7,8,9,10],"name":"Fair","type":"scatter","line":{"color":"rgb(00, 100, 80)"},"x":[1,2,3,4,5,6,7,8,9,10],"mode":"lines"},{"y":[5.0,2.5,5.0,7.5,5.0,2.5,7.5,4.5,5.5,5.0],"name":"Premium","type":"scatter","line":{"color":"rgb(0, 176, 246)"},"x":[1,2,3,4,5,6,7,8,9,10],"mode":"lines"},{"y":[10,8,6,4,2,0,2,4,2,0],"name":"Ideal","type":"scatter","line":{"color":"rgb(231, 107, 243)"},"x":[1,2,3,4,5,6,7,8,9,10],"mode":"lines"}],
               {"yaxis":{"showline":false,"tickcolor":"rgb(127, 127, 127)","showgrid":true,"showticklabels":true,"ticks":"outside","zeroline":false,"gridcolor":"rgb(255, 255, 255)"},"plot_bgcolor":"rgb(229, 229, 229)","xaxis":{"range":[1,10],"showline":false,"tickcolor":"rgb(127, 127, 127)","showgrid":true,"showticklabels":true,"ticks":"outside","zeroline":false,"gridcolor":"rgb(255, 255, 255)"},"paper_bgcolor":"rgb(255, 255, 255)","margin":{"r":40,"l":100,"b":50,"t":80}}, {showLink: false});

 </script>



```julia
function errorbars2()
    function random_dates(d1::DateTime, d2::DateTime, n::Int)
        map(Date, sort!(rand(d1:Dates.Hour(12):d2, n)))
    end

    function _random_number(num, mul)
        value = []
        j = 0
        rand = 0
        while j <= num+1
            rand = rand() * mul
            append!(value, [rand])
            j += 1
        end
        return value
    end

    dates = random_dates(DateTime(2001, 1, 1), DateTime(2005, 12, 31), 50)

    trace1 = scatter(;x=dates,
                     y=20.0 .* rand(50),
                     line_width=0,
                     marker_color="444",
                     mode="lines",
                     name="Lower Bound")

    trace2 = scatter(;x=dates,
                     y=21.0 .* rand(50),
                     fill="tonexty",
                     fillcolor="rgba(68, 68, 68, 0.3)",
                     line_color="rgb(31, 119, 180)",
                     mode="lines",
                     name="Measurement")

    trace3 = scatter(;x=dates,
                     y=22.0 .* rand(50),
                     fill="tonexty",
                     fillcolor="rgba(68, 68, 68, 0.3)",
                     line_width=0,
                     marker_color="444",
                     mode="lines",
                     name="Upper Bound")

    data = [trace1, trace2, trace3]
    t = "Continuous, variable value error bars<br> Notice the hover text!"
    layout = Layout(;title=t, yaxis_title="Wind speed (m/s)")
    plot(data, layout)
end
errorbars2()
```


<div id="3f11312d-4b5a-469b-b391-6bde3b0704a9" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('3f11312d-4b5a-469b-b391-6bde3b0704a9', [{"y":[10.612755054862845,5.962571646133985,19.302032265322815,8.717790405736817,19.21465515656713,9.479107529029376,7.432951858828045,14.996993816527468,11.86429498296592,10.889047210256324,15.580845026984914,14.916070532621024,11.619616609325579,11.770314760120248,9.873674911184494,2.3776933616093743,7.7970369487184055,15.623936700048171,7.055704745677187,2.7204266753964523,18.677698835991126,18.070283871890624,0.685680661930812,0.0828704186813578,18.942699634870934,19.30929432940536,6.579323190486814,5.326940912588123,16.239513620214694,13.779931568888912,2.801018887705564,18.056409844678708,16.94533386574514,6.392813931608763,15.975688360049173,14.980451491034685,7.694640230952201,9.691357447832122,13.735598376615975,18.194509275379556,10.674903014857385,4.353451587890627,13.248553981069659,3.041422285353752,9.36497742275623,18.237941021363117,1.995939351220568,2.9437800895608435,17.992282113930678,0.04720192197008366],"name":"Lower Bound","type":"scatter","line":{"width":0},"x":["2001-02-22","2001-05-17","2001-05-24","2001-06-04","2001-07-05","2001-09-02","2001-11-15","2002-01-02","2002-01-03","2002-02-27","2002-03-26","2002-06-18","2002-07-07","2002-07-25","2002-09-28","2002-10-09","2002-12-16","2003-01-30","2003-02-02","2003-02-07","2003-02-12","2003-04-09","2003-05-24","2003-07-09","2003-07-29","2003-08-28","2003-10-26","2003-11-21","2003-11-22","2003-12-24","2004-02-09","2004-03-19","2004-06-05","2004-09-01","2004-11-12","2004-11-16","2004-11-29","2004-12-18","2004-12-19","2005-01-23","2005-02-20","2005-04-15","2005-04-19","2005-04-23","2005-05-06","2005-07-06","2005-10-11","2005-10-15","2005-12-05","2005-12-10"],"marker":{"color":"444"},"mode":"lines"},{"y":[10.56513649925413,18.972311478536483,15.831524560294737,10.481186401277252,12.9348736235472,15.766595404335769,14.778433381804,8.674180571421504,0.07048687336706294,5.280889011442796,14.725032764852854,16.719282330076908,16.23351830027453,10.722217851925736,7.045190159373533,15.704777956048304,17.16197250357562,6.145044463808035,4.070766147875497,18.530531882725764,9.166722540990618,15.71979249537192,7.4048548132558585,1.742153299301487,11.67430298058881,2.441245225392233,11.100608053041851,0.4717044670001598,0.22269752448797742,9.473110322197773,10.852840756715787,11.241234959798682,15.189526380997656,6.132925581850548,9.720091783259482,16.71050721942702,2.4201780652226104,14.641282735272227,3.3589760259903336,17.115903012033066,1.4268987140403033,4.323655072878234,4.006178331818173,9.116215439670329,17.139699226928002,2.857809017065823,7.76250306505365,10.31924193269319,12.409554997595823,3.108055834808731],"name":"Measurement","type":"scatter","fillcolor":"rgba(68, 68, 68, 0.3)","line":{"color":"rgb(31, 119, 180)"},"x":["2001-02-22","2001-05-17","2001-05-24","2001-06-04","2001-07-05","2001-09-02","2001-11-15","2002-01-02","2002-01-03","2002-02-27","2002-03-26","2002-06-18","2002-07-07","2002-07-25","2002-09-28","2002-10-09","2002-12-16","2003-01-30","2003-02-02","2003-02-07","2003-02-12","2003-04-09","2003-05-24","2003-07-09","2003-07-29","2003-08-28","2003-10-26","2003-11-21","2003-11-22","2003-12-24","2004-02-09","2004-03-19","2004-06-05","2004-09-01","2004-11-12","2004-11-16","2004-11-29","2004-12-18","2004-12-19","2005-01-23","2005-02-20","2005-04-15","2005-04-19","2005-04-23","2005-05-06","2005-07-06","2005-10-11","2005-10-15","2005-12-05","2005-12-10"],"fill":"tonexty","mode":"lines"},{"y":[15.729853609810071,2.1109347169148736,1.7873159615157017,10.450725103495849,19.915635898756054,21.94100873601322,12.44005356692664,11.032095306121718,12.265117442739808,9.32737792303158,12.23893177657127,8.641646395939153,8.119789080536943,17.899850951482684,17.16865463831074,1.1553617522513697,15.855249814826031,9.108807659903551,14.60990679472232,1.59209750574614,15.730672770691223,0.20428575677918115,18.892538760249757,0.8510854780738728,19.768383476219622,10.933830692057972,13.171657407520964,12.926130177590057,19.34172591416871,13.602665783663015,10.454572338512435,0.7681079962018122,21.398017766227824,13.84294976079174,9.649032018671628,3.491843243983967,10.167462644566381,9.674604067544946,10.303655263809244,2.8008150465979442,12.705242686713962,18.26021100479463,19.490338155955634,7.155848558752076,21.263974551272128,3.9604681942741,7.612423411671006,1.3756234131764518,4.3386317449836875,19.503077705293105],"name":"Upper Bound","type":"scatter","fillcolor":"rgba(68, 68, 68, 0.3)","line":{"width":0},"x":["2001-02-22","2001-05-17","2001-05-24","2001-06-04","2001-07-05","2001-09-02","2001-11-15","2002-01-02","2002-01-03","2002-02-27","2002-03-26","2002-06-18","2002-07-07","2002-07-25","2002-09-28","2002-10-09","2002-12-16","2003-01-30","2003-02-02","2003-02-07","2003-02-12","2003-04-09","2003-05-24","2003-07-09","2003-07-29","2003-08-28","2003-10-26","2003-11-21","2003-11-22","2003-12-24","2004-02-09","2004-03-19","2004-06-05","2004-09-01","2004-11-12","2004-11-16","2004-11-29","2004-12-18","2004-12-19","2005-01-23","2005-02-20","2005-04-15","2005-04-19","2005-04-23","2005-05-06","2005-07-06","2005-10-11","2005-10-15","2005-12-05","2005-12-10"],"fill":"tonexty","marker":{"color":"444"},"mode":"lines"}],
               {"yaxis":{"title":"Wind speed (m/s)"},"title":"Continuous, variable value error bars<br> Notice the hover text!","margin":{"r":40,"l":100,"b":50,"t":80}}, {showLink: false});

 </script>



