using PlotlyJS

function datestrings()
    trace = scatter(;x = ["2013-10-04 22:23:00", "2013-11-04 22:23:00", "2013-12-04 22:23:00"], y=[1,3,6])

    plot(trace)
end


