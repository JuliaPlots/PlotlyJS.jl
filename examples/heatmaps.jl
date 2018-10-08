using PlotlyJS
Random.seed!(42)

function heatmap1()
    plot(heatmap(z=[1 20 30; 20 1 60; 30 60 1]))
end

function heatmap2()
    trace = heatmap(
        x=["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
        y=["Morning", "Afternoon", "Evening"],
        z=rand(1:30, 5, 3)
    )
    plot(trace)
end
