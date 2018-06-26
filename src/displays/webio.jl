WebIO.render(p::SyncPlot) = WebIO.render(p.plot)

function WebIO.render(p::Plot)
    scp = WebIO.Scope(imports = ["plotly" => _js_path])
    scp.dom = WebIO.Node(:div, id = string(p.divid), className = "plotly-graph-div")
    WebIO.onimport(scp, WebIO.js"""function (Plotly) {
        window.PLOTLYENV=window.PLOTLYENV || {};
        window.PLOTLYENV.BASE_URL="https://plot.ly";
        $(WebIO.JSString(PlotlyJS.script_content(p)))
    }
    """)
    WebIO.render(scp)
end
