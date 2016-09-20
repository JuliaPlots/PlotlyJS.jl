```julia
function linescatter1()
    trace1 = scatter(;x=1:4, y=[10, 15, 13, 17], mode="markers")
    trace2 = scatter(;x=2:5, y=[16, 5, 11, 9], mode="lines")
    trace3 = scatter(;x=1:4, y=[12, 9, 15, 12], mode="lines+markers")
    plot([trace1, trace2, trace3])
end
linescatter1()
```


<div id="3b70fb55-47e1-4592-94c1-9e3925d27054" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('3b70fb55-47e1-4592-94c1-9e3925d27054', [{"y":[10,15,13,17],"type":"scatter","x":[1,2,3,4],"mode":"markers"},{"y":[16,5,11,9],"type":"scatter","x":[2,3,4,5],"mode":"lines"},{"y":[12,9,15,12],"type":"scatter","x":[1,2,3,4],"mode":"lines+markers"}],
               {"margin":{"r":0,"l":0,"b":0,"t":0}}, {showLink: false});

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


<div id="bec59725-20b5-42b3-8cf1-88d81ed0e780" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('bec59725-20b5-42b3-8cf1-88d81ed0e780', [{"y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"name":"Team A","type":"scatter","x":[1,2,3,4,5],"mode":"markers","marker":{"size":12}},{"y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"name":"Team B","type":"scatter","x":[1.0,2.0,3.0,4.0,5.0],"mode":"markers","marker":{"size":12}}],
               {"yaxis":{"range":[0,8]},"xaxis":{"range":[0.75,5.25]},"title":"Data Labels Hover","margin":{"r":0,"l":0,"b":0,"t":0}}, {showLink: false});

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


<div id="af492ce9-b0a1-4deb-aee2-851dfda379af" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('af492ce9-b0a1-4deb-aee2-851dfda379af', [{"y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"textfont":{"family":"Raleway, sans-serif"},"name":"Team A","type":"scatter","x":[1,2,3,4,5],"textposition":"top center","mode":"markers+text","marker":{"size":12}},{"y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"textfont":{"family":"Times New Roman"},"name":"Team B","type":"scatter","x":[1.0,2.0,3.0,4.0,5.0],"textposition":"bottom center","mode":"markers+text","marker":{"size":12}}],
               {"yaxis":{"range":[0,8]},"legend":{"y":0.5,"size":20,"yref":"paper","color":"grey","family":"Arial, sans-serif"},"xaxis":{"range":[0.75,5.25]},"title":"Data Labels on the Plot","margin":{"r":0,"l":0,"b":0,"t":0}}, {showLink: false});

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


<div id="e78cb1ab-b78a-41e2-98b3-08e332c1427c" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('e78cb1ab-b78a-41e2-98b3-08e332c1427c', [{"y":[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],"type":"scatter","mode":"markers","marker":{"size":40,"color":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39]}}],
               {"title":"Scatter Plot with a Color Dimension","margin":{"r":0,"l":0,"b":0,"t":0}}, {showLink: false});

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


<div id="c59b1468-17ce-4248-a3d6-a7a60d10bc80" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('c59b1468-17ce-4248-a3d6-a7a60d10bc80', [{"y":["Switzerland (2011)","Chile (2013)","Japan (2014)","United States (2012)","Slovenia (2014)","Canada (2011)","Poland (2010)","Estonia (2015)","Luxembourg (2013)","Portugal (2011)"],"name":"Percent of estimated voting age population","type":"scatter","x":[40.0,45.7,52.0,53.6,54.1,54.2,54.5,54.7,55.1,56.6],"mode":"markers","marker":{"symbol":"circle","line":{"width":1,"color":"rgba(156, 165, 196, 1.0)"},"size":16,"color":"rgba(156, 165, 196, 0.95)"}},{"y":["Switzerland (2011)","Chile (2013)","Japan (2014)","United States (2012)","Slovenia (2014)","Canada (2011)","Poland (2010)","Estonia (2015)","Luxembourg (2013)","Portugal (2011)"],"name":"Percent of estimated registered voters","type":"scatter","x":[49.1,42.0,52.7,84.3,51.7,61.1,55.3,64.2,91.1,58.9],"mode":"markers","marker":{"symbol":"circle","line":{"width":1,"color":"rgba(217, 217, 217, 1.0)"},"size":16,"color":"rgba(204, 204, 204, 0.95)"}}],
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


<div id="e20f8530-7b2a-4aec-a23f-6b32fd9854dd" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('e20f8530-7b2a-4aec-a23f-6b32fd9854dd', [{"y":[53,31],"text":["United States","Canada"],"name":"North America","type":"scatter","x":[52698,43117],"mode":"markers","marker":{"line":{"width":0.5,"color":"white"},"size":12,"color":"rgb(164, 194, 244)"}},{"y":[33,20,13,19,27,19,49,44,38],"text":["Germany","Britain","France","Spain","Italy","Czech Rep.","Greece","Poland","Portugal"],"name":"Europe","type":"scatter","x":[39317,37236,35650,30066,29570,27159,23557,21046,18007],"mode":"markers","marker":{"size":12,"color":"rgb(255, 217, 102)"}},{"y":[23,42,54,89,14,99,93,70],"text":["Australia","Japan","South Korea","Malaysia","China","Indonesia","Philippines","India"],"name":"Asia/Pacific","type":"scatter","x":[42952,37037,33106,17478,9813,5253,4692,3899],"mode":"markers","marker":{"size":12,"color":"rgb(234, 153, 153)"}},{"y":[43,47,56,80,86,93,80],"text":["Chile","Argentina","Mexico","Venezuela","Venezuela","El Salvador","Bolivia"],"name":"Latin America","type":"scatter","x":[19097,18601,15595,13546,12026,7434,5419],"mode":"markers","marker":{"size":12,"color":"rgb(142, 124, 195)"}}],
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


<div id="dc09995f-7c96-47f9-8978-ae663e358457" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('dc09995f-7c96-47f9-8978-ae663e358457', [{"y":[2.710523708715754,2.6897765630594064,2.6681798427897228,2.6457127429801117,2.622352892704861,2.598076211353316,2.572856746252052,2.5466664885849566,2.519475164005555,2.491249993600049,2.4619554199448697,2.431552791857877,2.4000000000000004,2.367251053652825,2.3332555866542055,2.2979582774493443,2.2612981642753573,2.223207831315932,2.183612434775485,2.142428528562855,2.099562636671296,2.054909501954889,2.008349916661711,1.9597480054583445,1.908947781541722,1.8557687223952257,1.7999999999999996,1.7413928274780042,1.6796501093370366,1.61441213158606,1.5452362609131385,1.4715672611476631,1.392692297937593,1.3076696830622019,1.2152097324649567,1.1134612334371359,0.9995917534020524,0.8688486399734274,0.711996331107265,0.5052782623950675,0.0,null,2.710523708715754,2.6897765630594064,2.6681798427897228,2.6457127429801117,2.622352892704861,2.598076211353316,2.572856746252052,2.5466664885849566,2.519475164005555,2.491249993600049,2.4619554199448697,2.431552791857877,2.4000000000000004,2.367251053652825,2.3332555866542055,2.2979582774493443,2.2612981642753573,2.223207831315932,2.183612434775485,2.142428528562855,2.099562636671296,2.054909501954889,2.008349916661711,1.9597480054583445,1.908947781541722,1.8557687223952257,1.7999999999999996,1.7413928274780042,1.6796501093370366,1.61441213158606,1.5452362609131385,1.4715672611476631,1.392692297937593,1.3076696830622019,1.2152097324649567,1.1134612334371359,0.9995917534020524,0.8688486399734274,0.711996331107265,0.5052782623950675,0.0],"showlegend":false,"name":"wings 1","type":"scatter","x":[-3.0,-3.1,-3.2,-3.3,-3.4,-3.5,-3.6,-3.7,-3.8,-3.9,-4.0,-4.1,-4.2,-4.3,-4.4,-4.5,-4.6,-4.7,-4.8,-4.9,-5.0,-5.1,-5.2,-5.3,-5.4,-5.5,-5.6,-5.7,-5.8,-5.9,-6.0,-6.1,-6.2,-6.3,-6.4,-6.5,-6.6,-6.7,-6.8,-6.9,-7.0,0.0,3.0,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0,5.1,5.2,5.3,5.4,5.5,5.6,5.7,5.8,5.9,6.0,6.1,6.2,6.3,6.4,6.5,6.6,6.7,6.8,6.9,7.0],"marker":{"color":"black"}},{"y":[-2.4619554199448697,-2.431552791857877,-2.4000000000000004,-2.367251053652825,-2.3332555866542055,-2.2979582774493443,-2.2612981642753573,-2.223207831315932,-2.183612434775485,-2.142428528562855,-2.099562636671296,-2.054909501954889,-2.008349916661711,-1.9597480054583445,-1.908947781541722,-1.8557687223952253,-1.7999999999999996,-1.7413928274780042,-1.6796501093370366,-1.6144121315860598,-1.5452362609131385,-1.4715672611476618,-1.392692297937593,-1.3076696830622019,-1.2152097324649567,-1.1134612334371359,-0.9995917534020515,-0.8688486399734274,-0.7119963311072622,-0.5052782623950675,-0.0,null,-2.4619554199448697,-2.431552791857877,-2.4000000000000004,-2.367251053652825,-2.3332555866542055,-2.2979582774493443,-2.2612981642753573,-2.223207831315932,-2.183612434775485,-2.142428528562855,-2.099562636671296,-2.054909501954889,-2.008349916661711,-1.9597480054583445,-1.908947781541722,-1.8557687223952253,-1.7999999999999996,-1.7413928274780042,-1.6796501093370366,-1.6144121315860598,-1.5452362609131385,-1.4715672611476618,-1.392692297937593,-1.3076696830622019,-1.2152097324649567,-1.1134612334371359,-0.9995917534020515,-0.8688486399734274,-0.7119963311072622,-0.5052782623950675,-0.0],"showlegend":false,"name":"wings 2","type":"scatter","x":[-4.0,-4.1,-4.2,-4.3,-4.4,-4.5,-4.6,-4.7,-4.8,-4.9,-5.0,-5.1,-5.2,-5.3,-5.4,-5.5,-5.6,-5.7,-5.8,-5.9,-6.0,-6.1,-6.2,-6.3,-6.4,-6.5,-6.6,-6.7,-6.8,-6.9,-7.0,0.0,4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0,5.1,5.2,5.3,5.4,5.5,5.6,5.7,5.8,5.9,6.0,6.1,6.2,6.3,6.4,6.5,6.6,6.7,6.8,6.9,7.0],"marker":{"color":"black"}},{"y":[1.7000000000000002,1.652501564456182,1.6100251257867602,1.5726280066714808,1.5404082057734576,1.5135083268962917,1.4921215971661086,1.4765006004804806,1.4669697220176638,1.463942890050825,1.467949192431123,1.4796706911509934,1.5,1.5301315846429335,1.57171431429143,1.6271243444677048,1.7000000000000002,1.796434624714726,1.9282202112918654,2.12550020016016,2.7,null,1.7000000000000002,1.652501564456182,1.6100251257867602,1.5726280066714808,1.5404082057734576,1.5135083268962917,1.4921215971661086,1.4765006004804806,1.4669697220176638,1.463942890050825,1.467949192431123,1.4796706911509934,1.5,1.5301315846429335,1.57171431429143,1.6271243444677048,1.7000000000000002,1.796434624714726,1.9282202112918654,2.12550020016016,2.7],"showlegend":false,"name":"Shoulders","type":"scatter","x":[-1.0,-1.1,-1.2,-1.3,-1.4,-1.5,-1.6,-1.7,-1.8,-1.9,-2.0,-2.1,-2.2,-2.3,-2.4,-2.5,-2.6,-2.7,-2.8,-2.9,-3.0,0.0,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3.0],"marker":{"color":"black"}},{"y":[-3.0,-2.5150191965550235,-2.3036363636363637,-2.144038975327533,-2.0145454545454546,-1.906701868942834,-1.8162121337361046,-1.740606253128509,-1.678385921068547,-1.6286489265297437,-1.5909090909090908,-1.56501256289338,-1.5511131937958198,-1.549697162219418,-1.5616666791906502,-1.588520050761016,-1.6327272727272728,-1.6985844298729877,-1.7945454545454547,-1.942291923827751,-2.3636363636363638,-1.9150191965550236,-1.7400000000000002,-1.616766248054806,-1.5236363636363635,-1.4521564143973795,-1.3980303155542866,-1.358788071310327,-1.3329313756140015,-1.3195580174388346,-1.3181818181818183,-1.3286489265297439,-1.3511131937958198,-1.3860607985830544,-1.4343939519179227,-1.497610959851925,-1.5781818181818181,-1.6804026116911697,-1.812727272727273,-1.996837378373205,-2.4545454545454546,null,-3.0,-2.5150191965550235,-2.3036363636363637,-2.144038975327533,-2.0145454545454546,-1.906701868942834,-1.8162121337361046,-1.740606253128509,-1.678385921068547,-1.6286489265297437,-1.5909090909090908,-1.56501256289338,-1.5511131937958198,-1.549697162219418,-1.5616666791906502,-1.588520050761016,-1.6327272727272728,-1.6985844298729877,-1.7945454545454547,-1.942291923827751,-2.3636363636363638,-1.9150191965550236,-1.7400000000000002,-1.616766248054806,-1.5236363636363635,-1.4521564143973795,-1.3980303155542866,-1.358788071310327,-1.3329313756140015,-1.3195580174388346,-1.3181818181818183,-1.3286489265297439,-1.3511131937958198,-1.3860607985830544,-1.4343939519179227,-1.497610959851925,-1.5781818181818181,-1.6804026116911697,-1.812727272727273,-1.996837378373205,-2.4545454545454546],"showlegend":false,"name":"Bottom","type":"scatter","x":[-0.0,-0.1,-0.2,-0.3,-0.4,-0.5,-0.6,-0.7,-0.8,-0.9,-1.0,-1.1,-1.2,-1.3,-1.4,-1.5,-1.6,-1.7,-1.8,-1.9,-2.0,-2.1,-2.2,-2.3,-2.4,-2.5,-2.6,-2.7,-2.8,-2.9,-3.0,-3.1,-3.2,-3.3,-3.4,-3.5,-3.6,-3.7,-3.8,-3.9,-4.0,0.0,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3.0,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,4.0],"marker":{"color":"black"}},{"y":[1.7,1.7,2.6,0.9,null,1.7,1.7,2.6,0.9],"showlegend":false,"name":"head","type":"scatter","x":[-0.0,-0.5,-0.8,-1.0,0.0,0.0,0.5,0.8,1.0],"marker":{"color":"black"}}],
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


<div id="74833093-9481-43d7-ade7-5d1799f79e6c" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('74833093-9481-43d7-ade7-5d1799f79e6c', [{"y":["UCLA","SoCal","Emory","Michigan","Berkeley","Brown","NYU","Notre Dame","Cornell","Tufts","Yale","Dartmouth","Chicago","Columbia","Duke","Georgetown","Princeton","U.Penn","Stanford","MIT","Harvard"],"name":"Men","type":"scatter","x":[78,81,82,84,88,92,94,100,107,112,114,114,118,119,124,131,137,141,151,152,165],"mode":"markers","marker":{"size":12,"color":"blue"}},{"y":["UCLA","SoCal","Emory","Michigan","Berkeley","Brown","NYU","Notre Dame","Cornell","Tufts","Yale","Dartmouth","Chicago","Columbia","Duke","Georgetown","Princeton","U.Penn","Stanford","MIT","Harvard"],"name":"Women","type":"scatter","x":[64,72,68,62,71,72,67,73,80,76,79,84,78,86,93,94,90,92,96,94,112],"mode":"markers","marker":{"size":12,"color":"pink"}},{"y":["UCLA","UCLA"],"showlegend":false,"name":"UCLA","type":"scatter","line":{"color":"gray"},"x":[64,78],"mode":"lines"},{"y":["SoCal","SoCal"],"showlegend":false,"name":"SoCal","type":"scatter","line":{"color":"gray"},"x":[72,81],"mode":"lines"},{"y":["Emory","Emory"],"showlegend":false,"name":"Emory","type":"scatter","line":{"color":"gray"},"x":[68,82],"mode":"lines"},{"y":["Michigan","Michigan"],"showlegend":false,"name":"Michigan","type":"scatter","line":{"color":"gray"},"x":[62,84],"mode":"lines"},{"y":["Berkeley","Berkeley"],"showlegend":false,"name":"Berkeley","type":"scatter","line":{"color":"gray"},"x":[71,88],"mode":"lines"},{"y":["Brown","Brown"],"showlegend":false,"name":"Brown","type":"scatter","line":{"color":"gray"},"x":[72,92],"mode":"lines"},{"y":["NYU","NYU"],"showlegend":false,"name":"NYU","type":"scatter","line":{"color":"gray"},"x":[67,94],"mode":"lines"},{"y":["Notre Dame","Notre Dame"],"showlegend":false,"name":"Notre Dame","type":"scatter","line":{"color":"gray"},"x":[73,100],"mode":"lines"},{"y":["Cornell","Cornell"],"showlegend":false,"name":"Cornell","type":"scatter","line":{"color":"gray"},"x":[80,107],"mode":"lines"},{"y":["Tufts","Tufts"],"showlegend":false,"name":"Tufts","type":"scatter","line":{"color":"gray"},"x":[76,112],"mode":"lines"},{"y":["Yale","Yale"],"showlegend":false,"name":"Yale","type":"scatter","line":{"color":"gray"},"x":[79,114],"mode":"lines"},{"y":["Dartmouth","Dartmouth"],"showlegend":false,"name":"Dartmouth","type":"scatter","line":{"color":"gray"},"x":[84,114],"mode":"lines"},{"y":["Chicago","Chicago"],"showlegend":false,"name":"Chicago","type":"scatter","line":{"color":"gray"},"x":[78,118],"mode":"lines"},{"y":["Columbia","Columbia"],"showlegend":false,"name":"Columbia","type":"scatter","line":{"color":"gray"},"x":[86,119],"mode":"lines"},{"y":["Duke","Duke"],"showlegend":false,"name":"Duke","type":"scatter","line":{"color":"gray"},"x":[93,124],"mode":"lines"},{"y":["Georgetown","Georgetown"],"showlegend":false,"name":"Georgetown","type":"scatter","line":{"color":"gray"},"x":[94,131],"mode":"lines"},{"y":["Princeton","Princeton"],"showlegend":false,"name":"Princeton","type":"scatter","line":{"color":"gray"},"x":[90,137],"mode":"lines"},{"y":["U.Penn","U.Penn"],"showlegend":false,"name":"U.Penn","type":"scatter","line":{"color":"gray"},"x":[92,141],"mode":"lines"},{"y":["Stanford","Stanford"],"showlegend":false,"name":"Stanford","type":"scatter","line":{"color":"gray"},"x":[96,151],"mode":"lines"},{"y":["MIT","MIT"],"showlegend":false,"name":"MIT","type":"scatter","line":{"color":"gray"},"x":[94,152],"mode":"lines"},{"y":["Harvard","Harvard"],"showlegend":false,"name":"Harvard","type":"scatter","line":{"color":"gray"},"x":[112,165],"mode":"lines"}],
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


<div id="ac6718e4-f86b-41ed-b3ce-5255a096efa7" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('ac6718e4-f86b-41ed-b3ce-5255a096efa7', [{"y":[2,3,4,5,6,7,8,9,10,11,9,8,7,6,5,4,3,2,1,0],"showlegend":false,"name":"Fair","type":"scatter","fillcolor":"rgba(0, 100, 80, 0.2)","line":{"color":"transparent"},"x":[1,2,3,4,5,6,7,8,9,10,10,9,8,7,6,5,4,3,2,1],"fill":"tozerox"},{"y":[5.5,3.0,5.5,8.0,6.0,3.0,8.0,5.0,6.0,5.5,4.75,5.0,4.0,7.0,2.0,4.0,7.0,4.4,2.0,4.5],"showlegend":false,"name":"Premium","type":"scatter","fillcolor":"rgba(0, 176, 246, 0.2)","line":{"color":"transparent"},"x":[1,2,3,4,5,6,7,8,9,10,10,9,8,7,6,5,4,3,2,1],"fill":"tozerox"},{"y":[11.0,9.0,7.0,5.0,3.0,1.0,3.0,5.0,3.0,1.0,-1.0,1.0,3.0,1.0,-0.5,1.0,3.0,5.0,7.0,9.0],"showlegend":false,"name":"Fair","type":"scatter","fillcolor":"rgba(231, 107, 243, 0.2)","line":{"color":"transparent"},"x":[1,2,3,4,5,6,7,8,9,10,10,9,8,7,6,5,4,3,2,1],"fill":"tozerox"},{"y":[1,2,3,4,5,6,7,8,9,10],"name":"Fair","type":"scatter","line":{"color":"rgb(00, 100, 80)"},"x":[1,2,3,4,5,6,7,8,9,10],"mode":"lines"},{"y":[5.0,2.5,5.0,7.5,5.0,2.5,7.5,4.5,5.5,5.0],"name":"Premium","type":"scatter","line":{"color":"rgb(0, 176, 246)"},"x":[1,2,3,4,5,6,7,8,9,10],"mode":"lines"},{"y":[10,8,6,4,2,0,2,4,2,0],"name":"Ideal","type":"scatter","line":{"color":"rgb(231, 107, 243)"},"x":[1,2,3,4,5,6,7,8,9,10],"mode":"lines"}],
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


<div id="5348ebf3-72ee-4009-8284-4283e3ee465f" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('5348ebf3-72ee-4009-8284-4283e3ee465f', [{"y":[7.601023927283492,10.062364291532244,9.404065854749115,14.143487475893473,8.446946264032281,14.34953115608661,19.471016317085056,4.947448377546562,0.5599526739718108,16.353779150977836,15.04754549926842,11.294020713992307,16.686203123001487,12.01719897554415,4.169174630170613,17.2503472496461,4.213269602281824,7.68437208783197,12.451069463037431,19.482036314514566,8.112484122427318,5.108599541603316,7.336239083431182,3.030765199222585,6.169403287482993,18.328163636410867,7.10541887372917,8.768758374295661,10.452342276673882,15.219138915737016,11.984728621504509,5.178683653099361,13.955298604282529,10.671410220787237,12.441319195733925,9.058994176042411,12.192433736890557,1.572266064733503,19.541642420507426,3.3193480320988478,17.553890211584374,2.007326147897297,11.765491548725473,15.765237861680275,17.5993063649131,2.7281475248407094,5.617742183805792,10.38305836401156,6.864603589299723,3.036508209819062],"name":"Lower Bound","type":"scatter","line":{"width":0},"x":["2001-02-16","2001-06-15","2001-06-27","2001-07-08","2001-08-01","2001-08-12","2001-09-04","2001-11-15","2001-11-30","2002-01-23","2002-02-21","2002-02-23","2002-02-24","2002-03-23","2002-04-11","2002-05-20","2002-05-25","2002-05-30","2002-06-21","2002-09-18","2003-02-25","2003-03-08","2003-03-31","2003-06-28","2003-10-03","2003-10-16","2003-11-05","2003-11-15","2003-11-16","2004-02-23","2004-03-12","2004-06-29","2004-07-27","2004-08-16","2004-08-27","2004-10-29","2004-11-19","2004-12-25","2005-01-06","2005-02-10","2005-04-04","2005-04-07","2005-05-07","2005-05-24","2005-06-11","2005-07-28","2005-08-01","2005-09-17","2005-10-09","2005-12-25"],"marker":{"color":"444"},"mode":"lines"},{"y":[3.2430728897662946,10.471129685494418,10.185279361804206,2.1441926460718843,3.36453374369239,16.54731558722504,11.757121099821594,19.524753376813898,2.0648703529729864,20.071487785382324,15.915218068324688,18.404387688772946,15.929826261913384,11.774061372538931,19.682707481833372,13.501021165399077,8.78371346286637,7.272831444710122,16.500986031561983,15.95107786248283,1.46478151964283,16.637694313176176,11.878140124921964,15.874897904607415,15.976779916490749,4.936266599303416,16.598756271502936,2.5963178481066675,7.79913136941384,4.405568743032478,0.5804224150948516,12.121310096971188,3.810109899980455,18.80865817973013,2.1809547793701523,12.307359128099357,19.49981500812084,0.5916677524307672,2.5097413357709497,8.272711127968638,8.349607501005373,17.628731076302532,9.649184688830752,6.3263256171991795,1.0944426696833107,19.323672287821687,19.73046749761687,4.259236326478918,12.524330449755302,1.831824450554591],"name":"Measurement","type":"scatter","fillcolor":"rgba(68, 68, 68, 0.3)","line":{"color":"rgb(31, 119, 180)"},"x":["2001-02-16","2001-06-15","2001-06-27","2001-07-08","2001-08-01","2001-08-12","2001-09-04","2001-11-15","2001-11-30","2002-01-23","2002-02-21","2002-02-23","2002-02-24","2002-03-23","2002-04-11","2002-05-20","2002-05-25","2002-05-30","2002-06-21","2002-09-18","2003-02-25","2003-03-08","2003-03-31","2003-06-28","2003-10-03","2003-10-16","2003-11-05","2003-11-15","2003-11-16","2004-02-23","2004-03-12","2004-06-29","2004-07-27","2004-08-16","2004-08-27","2004-10-29","2004-11-19","2004-12-25","2005-01-06","2005-02-10","2005-04-04","2005-04-07","2005-05-07","2005-05-24","2005-06-11","2005-07-28","2005-08-01","2005-09-17","2005-10-09","2005-12-25"],"fill":"tonexty","mode":"lines"},{"y":[2.3452330741070133,16.99237803461947,1.583224032022064,18.410015766034807,13.773946746826578,9.404530578395473,1.6802951733550788,3.291628174698524,3.2798790404372737,4.792549677153872,11.77240341590251,21.126865002541965,16.086059398173848,11.252524596060576,0.4938011282644341,18.73620715692459,9.711771105308399,15.519135891907013,10.239203167519584,15.33407690690746,0.109101336856674,19.89650684418338,3.107299800871229,14.78634205014164,17.69625713187345,4.432226382148888,9.844986087454192,4.766767382156569,21.02396934917248,0.15170419504596966,20.77356899232905,21.515919808219536,19.189886555729327,9.435996414545185,20.69925910930089,5.138201514243978,19.803599317031313,18.793334285806104,2.0188868949979524,17.16723653254239,21.834307777800362,19.37475577452744,11.747345335626331,14.708809261010972,8.730857430365266,3.7276382740427763,0.7959284669032529,0.46122682607910415,19.199859196567868,19.238556673504988],"name":"Upper Bound","type":"scatter","fillcolor":"rgba(68, 68, 68, 0.3)","line":{"width":0},"x":["2001-02-16","2001-06-15","2001-06-27","2001-07-08","2001-08-01","2001-08-12","2001-09-04","2001-11-15","2001-11-30","2002-01-23","2002-02-21","2002-02-23","2002-02-24","2002-03-23","2002-04-11","2002-05-20","2002-05-25","2002-05-30","2002-06-21","2002-09-18","2003-02-25","2003-03-08","2003-03-31","2003-06-28","2003-10-03","2003-10-16","2003-11-05","2003-11-15","2003-11-16","2004-02-23","2004-03-12","2004-06-29","2004-07-27","2004-08-16","2004-08-27","2004-10-29","2004-11-19","2004-12-25","2005-01-06","2005-02-10","2005-04-04","2005-04-07","2005-05-07","2005-05-24","2005-06-11","2005-07-28","2005-08-01","2005-09-17","2005-10-09","2005-12-25"],"fill":"tonexty","marker":{"color":"444"},"mode":"lines"}],
               {"yaxis":{"title":"Wind speed (m/s)"},"title":"Continuous, variable value error bars<br> Notice the hover text!","margin":{"r":40,"l":100,"b":50,"t":80}}, {showLink: false});

 </script>



