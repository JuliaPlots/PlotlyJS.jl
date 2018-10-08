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


<div id="b1af2989-ac0a-4b78-ab33-93460ed24292" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('b1af2989-ac0a-4b78-ab33-93460ed24292', [{"a":[75,70,75,5,10,10,20,10,15,10,20],"mode":"markers","b":[25,10,20,60,80,90,70,20,5,10,10],"type":"scatterternary","c":[0,20,5,35,10,0,10,70,80,80,70],"text":["point 1","point 2","point 3","point 4","point 5","point 6","point 7","point 8","point 9","point 10","point 11"],"marker":{"symbol":100,"color":"#DB7365","line":{"width":2},"size":14}}],
               {"paper_bgcolor":"#fff1e0","ternary":{"baxis":{"tickangle":45,"showline":true,"showgrid":true,"titlefont":{"size":20},"tickfont":{"size":15},"ticklen":5,"title":"Developer","tickcolor":"rgba(0, 0, 0, 0)"},"bgcolor":"#fff1e0","caxis":{"tickangle":-45,"showline":true,"showgrid":true,"titlefont":{"size":20},"tickfont":{"size":15},"ticklen":5,"title":"Designer","tickcolor":"rgba(0, 0, 0, 0)"},"sum":100,"aaxis":{"tickangle":0,"showline":true,"showgrid":true,"titlefont":{"size":20},"tickfont":{"size":15},"ticklen":5,"title":"Journalist","tickcolor":"rgba(0, 0, 0, 0)"}},"annotations":{"y":1.3,"font":{"size":15},"showarrow":false,"text":"Replica of Tom Pearson's block","x":1.0},"margin":{"l":50,"b":60,"r":50,"t":60}}, {showLink: false});

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


<div id="dcf3a278-e70a-44bd-941b-7a7a9930e6e9" class="plotly-graph-div"></div>

<script>
    window.PLOTLYENV=window.PLOTLYENV || {};
    window.PLOTLYENV.BASE_URL="https://plot.ly";
    Plotly.newPlot('dcf3a278-e70a-44bd-941b-7a7a9930e6e9', [{"a":[55,100,60,40,40],"mode":"lines","b":[45,0,0,20,45],"line":{"color":"#444"},"fillcolor":"#8dd3c7","type":"scatterternary","name":"clay","fill":"toself","c":[0,0,40,40,15],"hoveron":"fills+points"},{"a":[20,35,35,28,20],"mode":"lines","b":[80,65,45,45,53],"line":{"color":"#444"},"fillcolor":"#ffffb3","type":"scatterternary","name":"sandy clay loam","fill":"toself","c":[0,0,20,27,32],"hoveron":"fills+points"},{"a":[60,40,40],"mode":"lines","b":[0,0,20],"line":{"color":"#444"},"fillcolor":"#bebada","type":"scatterternary","name":"silty clay","fill":"toself","c":[40,60,40],"hoveron":"fills+points"},{"a":[0,15,20,20,5,5,0],"mode":"lines","b":[70,85,80,53,53,45,50],"line":{"color":"#444"},"fillcolor":"#fb8072","type":"scatterternary","name":"sandy loam","fill":"toself","c":[30,0,0,32,42,50,50],"hoveron":"fills+points"},{"a":[35,35,55],"mode":"lines","b":[65,45,45],"line":{"color":"#444"},"fillcolor":"#80b1d3","type":"scatterternary","name":"sandy clay","fill":"toself","c":[0,20,0],"hoveron":"fills+points"},{"a":[28,28,5,5,20],"mode":"lines","b":[45,22,45,53,53],"line":{"color":"#444"},"fillcolor":"#fdb462","type":"scatterternary","name":"loam","fill":"toself","c":[27,50,50,42,32],"hoveron":"fills+points"},{"a":[0,10,0],"mode":"lines","b":[100,90,90],"line":{"color":"#444"},"fillcolor":"#b3de69","type":"scatterternary","name":"sand","fill":"toself","c":[0,0,10],"hoveron":"fills+points"},{"a":[0,0,12,12],"mode":"lines","b":[0,20,8,0],"line":{"color":"#444"},"fillcolor":"#fccde5","type":"scatterternary","name":"silt","fill":"toself","c":[100,80,80,88],"hoveron":"fills+points"},{"a":[40,40,28,28],"mode":"lines","b":[45,20,20,45],"line":{"color":"#444"},"fillcolor":"#d9d9d9","type":"scatterternary","name":"clay loam","fill":"toself","c":[15,40,52,27],"hoveron":"fills+points"},{"a":[0,28,28,12,12,0],"mode":"lines","b":[50,22,0,0,8,20],"line":{"color":"#444"},"fillcolor":"#bc80bd","type":"scatterternary","name":"silty loam","fill":"toself","c":[50,50,72,88,80,80],"hoveron":"fills+points"},{"a":[0,10,15,0],"mode":"lines","b":[90,90,85,70],"line":{"color":"#444"},"fillcolor":"#ccebc5","type":"scatterternary","name":"loamy sand","fill":"toself","c":[10,0,0,30],"hoveron":"fills+points"},{"a":[28,28,40,40],"mode":"lines","b":[0,20,20,0],"line":{"color":"#444"},"fillcolor":"#ffed6f","type":"scatterternary","name":"silty clay loam","fill":"toself","c":[72,52,40,60],"hoveron":"fills+points"}],
               {"showlegend":false,"ternary":{"baxis":{"showgrid":true,"ticklen":8,"ticks":"outside","title":"Sand","linewidth":2,"ticksuffix":"%","min":0.01},"caxis":{"showgrid":true,"ticklen":8,"ticks":"outside","title":"Slit","linewidth":2,"ticksuffix":"%","min":0.01},"sum":100,"aaxis":{"showgrid":true,"ticklen":8,"ticks":"outside","title":"Clay","linewidth":2,"ticksuffix":"%","min":0.01}},"annotations":[{"y":1.1,"showarrow":false,"text":"Soil types fill plot","x":0.15}],"margin":{"l":50,"b":60,"r":50,"t":60},"width":700}, {showLink: false});

 </script>



