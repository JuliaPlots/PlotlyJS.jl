```julia
function ternary_markers()
    function make_ax(title, tickangle)
        attr(title=title, titlefont_size=20, tickangle=tickangle,
            tickfont_size=15, tickcolor="rgba(0, 0, 0, 0)", ticklen=5,
            showline=true, showgrid=true)
    end

    raw_data = [
        Dict(:journalist=>75, :developer=>:25, :designer=>0, :label=>"point 1"),
        Dict(:journalist=>70, :developer=>:10, :designer=>20, :label=>"point 2"),
        Dict(:journalist=>75, :developer=>:20, :designer=>5, :label=>"point 3"),
        Dict(:journalist=>5, :developer=>:60, :designer=>35, :label=>"point 4"),
        Dict(:journalist=>10, :developer=>:80, :designer=>10, :label=>"point 5"),
        Dict(:journalist=>10, :developer=>:90, :designer=>0, :label=>"point 6"),
        Dict(:journalist=>20, :developer=>:70, :designer=>10, :label=>"point 7"),
        Dict(:journalist=>10, :developer=>:20, :designer=>70, :label=>"point 8"),
        Dict(:journalist=>15, :developer=>:5, :designer=>80, :label=>"point 9"),
        Dict(:journalist=>10, :developer=>:10, :designer=>80, :label=>"point 10"),
        Dict(:journalist=>20, :developer=>:10, :designer=>70, :label=>"point 11")
    ]

    t = scatterternary(
        mode="markers",
        a=[_[:journalist] for _ in raw_data],
        b=[_[:developer] for _ in raw_data],
        c=[_[:designer] for _ in raw_data],
        text=[_[:label] for _ in raw_data],
        marker=attr(symbol=100, color="#DB7365", size=14, line_width=2)
    )
    layout = Layout(
        ternary=attr(
            sum=100,
            aaxis=make_ax("Journalist", 0),
            baxis=make_ax("Developer", 45),
            caxis=make_ax("Designer", -45),
            bgcolor="#fff1e0",
        ), annotations=attr(
            showarrow=false,
            text="Replica of Tom Pearson's block",
            x=1.0, y=1.3, font_size=15
        ),
        paper_bgcolor="#fff1e0"
    )
    plot(t, layout)
end
ternary_markers()
```


<div id="a21cf0f2-461f-405b-ad1c-19f256f1b3f0" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('a21cf0f2-461f-405b-ad1c-19f256f1b3f0', [{"c":[0,20,5,35,10,0,10,70,80,80,70],"text":["point 1","point 2","point 3","point 4","point 5","point 6","point 7","point 8","point 9","point 10","point 11"],"type":"scatterternary","a":[75,70,75,5,10,10,20,10,15,10,20],"b":[25,10,20,60,80,90,70,20,5,10,10],"mode":"markers","marker":{"symbol":100,"line":{"width":2},"size":14,"color":"#DB7365"}}],
               {"annotations":{"text":"Replica of Tom Pearson's block","y":1.3,"font":{"size":15},"showarrow":false,"x":1.0},"paper_bgcolor":"#fff1e0","margin":{"r":0,"l":0,"b":0,"t":10},"ternary":{"bgcolor":"#fff1e0","baxis":{"showline":true,"titlefont":{"size":20},"tickcolor":"rgba(0, 0, 0, 0)","title":"Developer","tickangle":45,"tickfont":{"size":15},"ticklen":5,"showgrid":true},"aaxis":{"showline":true,"titlefont":{"size":20},"tickcolor":"rgba(0, 0, 0, 0)","title":"Journalist","tickangle":0,"tickfont":{"size":15},"ticklen":5,"showgrid":true},"caxis":{"showline":true,"titlefont":{"size":20},"tickcolor":"rgba(0, 0, 0, 0)","title":"Designer","tickangle":-45,"tickfont":{"size":15},"ticklen":5,"showgrid":true},"sum":100}}, {showLink: false});

 </script>



```julia
function filled_ternary()
    function make_ax(title)
        attr(
            title=title,
            ticksuffix="%",
            min=0.01,
            linewidth=2,
            ticks="outside",
            ticklen=8,
            showgrid=true
        )
    end

    fn = tempname()
    download("https://gist.githubusercontent.com/davenquinn/988167471993bc2ece29/raw/f38d9cb3dd86e315e237fde5d65e185c39c931c2/data.json", fn)
    raw_data = JSON.parsefile(fn)
    rm(fn)

    colors = [
        "#8dd3c7",
        "#ffffb3",
        "#bebada",
        "#fb8072",
        "#80b1d3",
        "#fdb462",
        "#b3de69",
        "#fccde5",
        "#d9d9d9",
        "#bc80bd",
        "#ccebc5",
        "#ffed6f"
    ]

    traces = Array(GenericTrace, length(raw_data))
    for (i, (k, v)) in enumerate(raw_data)
        traces[i] = scatterternary(mode="lines", name=k,
            a=[_["clay"] for _ in v],
            b=[_["sand"] for _ in v],
            c=[_["silt"] for _ in v],
            line_color="#444",
            fill="toself",
            fillcolor=colors[i],
            hoveron="fills+points"
        )
    end
    layout = Layout(
        ternary=attr(
            sum=100,
            aaxis=make_ax("Clay"),
            baxis=make_ax("Sand"),
            caxis=make_ax("Slit")),
        showlegend=false,
        width=700,
        annotations=[attr(
            showarrow=false, x=0.15, y=1.1, text="Soil types fill plot"
        )]
    )
    plot(traces, layout)
end
filled_ternary()
```


<div id="ded8c12b-1393-4806-a13e-675b3f02bc58" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('ded8c12b-1393-4806-a13e-675b3f02bc58', [{"c":[0,0,40,40,15],"name":"clay","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#8dd3c7","a":[55,100,60,40,40],"b":[45,0,0,20,45],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[0,0,20,27,32],"name":"sandy clay loam","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#ffffb3","a":[20,35,35,28,20],"b":[80,65,45,45,53],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[40,60,40],"name":"silty clay","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#bebada","a":[60,40,40],"b":[0,0,20],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[30,0,0,32,42,50,50],"name":"sandy loam","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#fb8072","a":[0,15,20,20,5,5,0],"b":[70,85,80,53,53,45,50],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[0,20,0],"name":"sandy clay","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#80b1d3","a":[35,35,55],"b":[65,45,45],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[27,50,50,42,32],"name":"loam","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#fdb462","a":[28,28,5,5,20],"b":[45,22,45,53,53],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[0,0,10],"name":"sand","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#b3de69","a":[0,10,0],"b":[100,90,90],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[100,80,80,88],"name":"silt","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#fccde5","a":[0,0,12,12],"b":[0,20,8,0],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[15,40,52,27],"name":"clay loam","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#d9d9d9","a":[40,40,28,28],"b":[45,20,20,45],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[50,50,72,88,80,80],"name":"silty loam","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#bc80bd","a":[0,28,28,12,12,0],"b":[50,22,0,0,8,20],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[10,0,0,30],"name":"loamy sand","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#ccebc5","a":[0,10,15,0],"b":[90,90,85,70],"hoveron":"fills+points","fill":"toself","mode":"lines"},{"c":[72,52,40,60],"name":"silty clay loam","type":"scatterternary","line":{"color":"#444"},"fillcolor":"#ffed6f","a":[28,28,40,40],"b":[0,20,20,0],"hoveron":"fills+points","fill":"toself","mode":"lines"}],
               {"annotations":[{"y":1.1,"text":"Soil types fill plot","showarrow":false,"x":0.15}],"width":700,"showlegend":false,"margin":{"r":0,"l":0,"b":0,"t":10},"ternary":{"baxis":{"ticksuffix":"%","title":"Sand","min":0.01,"ticks":"outside","ticklen":8,"linewidth":2,"showgrid":true},"aaxis":{"ticksuffix":"%","title":"Clay","min":0.01,"ticks":"outside","ticklen":8,"linewidth":2,"showgrid":true},"caxis":{"ticksuffix":"%","title":"Slit","min":0.01,"ticks":"outside","ticklen":8,"linewidth":2,"showgrid":true},"sum":100}}, {showLink: false});

 </script>



