using PlotlyJS

function area1(showme=true)
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")
    p = Plot([trace1, trace2])
    showme && show(p)
    p
end

function stacked_area!(traces)
    for (i, tr) in enumerate(traces[2:end])
        for j in 1:min(length(traces[i]["y"]), length(tr["y"]))
            tr["y"][j] += traces[i]["y"][j]
        end
    end
    traces
end

function area2(showme=true)
    traces = [scatter(;x=1:3, y=[2, 1, 4], fill="tozeroy"),
              scatter(;x=1:3, y=[1, 1, 2], fill="tonexty"),
              scatter(;x=1:3, y=[3, 0, 2], fill="tonexty")]
    stacked_area!(traces)

    p = Plot(traces, Layout(title="stacked and filled line chart"))
    showme && show(p)
    p
end


function area3(showme=true)
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy", mode="none")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty", mode="none")
    p = Plot([trace1, trace2],
             Layout(title="Overlaid Chart Without Boundary Lines"))
    showme && show(p)
    p
end
