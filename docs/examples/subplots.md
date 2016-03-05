```julia
function exsubplots1()
    p1 = exlinescatter1()
    p2 = exlinescatter2()
    p = [p1 p2]
    p
end
exsubplots1()
```


<div id="23abfc7c-66d5-4546-8704-a9ca29888081"></div>

<script>
   thediv = document.getElementById('23abfc7c-66d5-4546-8704-a9ca29888081');
var data = [{"type":"scatter","yaxis":"y1","y":[10,15,13,17],"xaxis":"x1","x":[1,2,3,4],"mode":"markers"},{"type":"scatter","yaxis":"y1","y":[16,5,11,9],"xaxis":"x1","x":[2,3,4,5],"mode":"lines"},{"type":"scatter","yaxis":"y1","y":[12,9,15,12],"xaxis":"x1","x":[1,2,3,4],"mode":"lines+markers"},{"type":"scatter","yaxis":"y2","y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"name":"Team A","xaxis":"x2","x":[1,2,3,4,5],"mode":"markers","marker":{"size":12}},{"type":"scatter","yaxis":"y2","y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"name":"Team B","xaxis":"x2","x":[1.0,2.0,3.0,4.0,5.0],"mode":"markers","marker":{"size":12}}]
var layout = {"annotations":[{"text":"Data Labels Hover","y":1.0,"font":{"size":16},"xanchor":"center","xref":"paper","showarrow":false,"x":0.775,"yanchor":"bottom","yref":"paper"}],"yaxis2":{"range":[0,8],"domain":[0.0,1.0],"anchor":"x2"},"yaxis1":{"domain":[0.0,1.0],"anchor":"x1"},"xaxis1":{"domain":[0.0,0.45],"anchor":"y1"},"margin":{"r":50,"l":50,"b":50,"t":60},"xaxis2":{"range":[0.75,5.25],"domain":[0.55,1.0],"anchor":"y2"}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function exsubplots2()
    p1 = exlinescatter1()
    p2 = exlinescatter2()
    p = [p1, p2]
    p
end
exsubplots2()
```


<div id="b463d6b0-efe9-4990-83c8-d8014eb4e533"></div>

<script>
   thediv = document.getElementById('b463d6b0-efe9-4990-83c8-d8014eb4e533');
var data = [{"type":"scatter","yaxis":"y1","y":[10,15,13,17],"xaxis":"x1","x":[1,2,3,4],"mode":"markers"},{"type":"scatter","yaxis":"y1","y":[16,5,11,9],"xaxis":"x1","x":[2,3,4,5],"mode":"lines"},{"type":"scatter","yaxis":"y1","y":[12,9,15,12],"xaxis":"x1","x":[1,2,3,4],"mode":"lines+markers"},{"type":"scatter","yaxis":"y2","y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"name":"Team A","xaxis":"x2","x":[1,2,3,4,5],"mode":"markers","marker":{"size":12}},{"type":"scatter","yaxis":"y2","y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"name":"Team B","xaxis":"x2","x":[1.0,2.0,3.0,4.0,5.0],"mode":"markers","marker":{"size":12}}]
var layout = {"annotations":[{"text":"Data Labels Hover","y":0.36250000000000004,"font":{"size":16},"xanchor":"center","xref":"paper","showarrow":false,"x":0.5,"yanchor":"bottom","yref":"paper"}],"yaxis2":{"range":[0,8],"domain":[5.551115123125783e-17,0.36250000000000004],"anchor":"x2"},"yaxis1":{"domain":[0.6375,1.0],"anchor":"x1"},"xaxis1":{"domain":[0.0,1.0],"anchor":"y1"},"margin":{"r":50,"l":50,"b":50,"t":60},"xaxis2":{"range":[0.75,5.25],"domain":[0.0,1.0],"anchor":"y2"}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



```julia
function exsubplots3()
    p1 = exlinescatter6()
    p2 = exlinescatter2()
    p3 = exlinescatter3()
    p4 = exlinescatter4()
    p = [p1 p2; p3 p4]
    p.plot.layout["showlegend"] = false
    p.plot.layout["width"] = 1000
    p.plot.layout["height"] = 600
    p
end
exsubplots3()
```


<div id="1a081f1c-36d5-4d35-bdc4-85c6f5d468d5"></div>

<script>
   thediv = document.getElementById('1a081f1c-36d5-4d35-bdc4-85c6f5d468d5');
var data = [{"type":"scatter","yaxis":"y1","y":[53,31],"text":["United States","Canada"],"name":"North America","xaxis":"x1","x":[52698,43117],"mode":"markers","marker":{"line":{"width":0.5,"color":"white"},"size":12,"color":"rgb(164, 194, 244)"}},{"type":"scatter","yaxis":"y1","y":[33,20,13,19,27,19,49,44,38],"text":["Germany","Britain","France","Spain","Italy","Czech Rep.","Greece","Poland"],"name":"Europe","xaxis":"x1","x":[39317,37236,35650,30066,29570,27159,23557,21046,18007],"mode":"markers","marker":{"size":12,"color":"rgb(255, 217, 102)"}},{"type":"scatter","yaxis":"y1","y":[23,42,54,89,14,99,93,70],"text":["Australia","Japan","South Korea","Malaysia","China","Indonesia","Philippines","India"],"name":"Asia/Pacific","xaxis":"x1","x":[42952,37037,33106,17478,9813,5253,4692,3899],"mode":"markers","marker":{"size":12,"color":"rgb(234, 153, 153)"}},{"type":"scatter","yaxis":"y1","y":[43,47,56,80,86,93,80],"text":["Chile","Argentina","Mexico","Venezuela","Venezuela","El Salvador","Bolivia"],"name":"Latin America","xaxis":"x1","x":[19097,18601,15595,13546,12026,7434,5419],"mode":"markers","marker":{"size":12,"color":"rgb(142, 124, 195)"}},{"type":"scatter","yaxis":"y2","y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"name":"Team A","xaxis":"x2","x":[1,2,3,4,5],"mode":"markers","marker":{"size":12}},{"type":"scatter","yaxis":"y2","y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"name":"Team B","xaxis":"x2","x":[1.0,2.0,3.0,4.0,5.0],"mode":"markers","marker":{"size":12}},{"type":"scatter","yaxis":"y3","y":[1,6,3,6,1],"text":["A-1","A-2","A-3","A-4","A-5"],"textfont":{"family":"Raleway, sans-serif"},"name":"Team A","xaxis":"x3","x":[1,2,3,4,5],"textposition":"top center","mode":"markers+text","marker":{"size":12}},{"type":"scatter","yaxis":"y3","y":[4,1,7,1,4],"text":["B-a","B-b","B-c","B-d","B-e"],"textfont":{"family":"Times New Roman"},"name":"Team B","xaxis":"x3","x":[1.0,2.0,3.0,4.0,5.0],"textposition":"bottom center","mode":"markers+text","marker":{"size":12}},{"type":"scatter","yaxis":"y4","y":[5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],"xaxis":"x4","mode":"markers","marker":{"size":40,"color":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39]}}]
var layout = {"annotations":[{"text":"Quarter 1 Growth","y":1.0,"font":{"size":16},"xanchor":"center","xref":"paper","showarrow":false,"x":0.225,"yanchor":"bottom","yref":"paper"},{"text":"Data Labels on the Plot","y":0.36250000000000004,"font":{"size":16},"xanchor":"center","xref":"paper","showarrow":false,"x":0.225,"yanchor":"bottom","yref":"paper"},{"text":"Data Labels Hover","y":1.0,"font":{"size":16},"xanchor":"center","xref":"paper","showarrow":false,"x":0.775,"yanchor":"bottom","yref":"paper"},{"text":"Scatter Plot with a Color Dimension","y":0.36250000000000004,"font":{"size":16},"xanchor":"center","xref":"paper","showarrow":false,"x":0.775,"yanchor":"bottom","yref":"paper"}],"width":1000,"showlegend":false,"yaxis2":{"range":[0,8],"domain":[0.6375,1.0],"anchor":"x2"},"xaxis2":{"range":[0.75,5.25],"domain":[0.55,1.0],"anchor":"y2"},"yaxis3":{"range":[0,8],"domain":[5.551115123125783e-17,0.36250000000000004],"anchor":"x3"},"xaxis3":{"range":[0.75,5.25],"domain":[0.0,0.45],"anchor":"y3"},"margin":{"r":50,"l":50,"b":50,"t":60},"height":600,"xaxis1":{"domain":[0.0,0.45],"title":"GDP per Capita","showgrid":false,"zeroline":false,"anchor":"y1"},"yaxis1":{"showline":false,"domain":[0.6375,1.0],"title":"Percent","anchor":"x1"},"yaxis4":{"domain":[5.551115123125783e-17,0.36250000000000004],"anchor":"x4"},"xaxis4":{"domain":[0.55,1.0],"anchor":"y4"}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>



