# module ContourExamples

function example3()
    x0 = randn(500)
    x1 = x0+1

    trace1 = GenericTrace("histogram", x=x0, opacity=0.75)
    trace2 = GenericTrace("histogram", x=x1, opacity=0.75)
    data = [trace1, trace2]
    layout = Layout(barmode="overlay")
    p = Plot(data, layout); show(p); p
end

# end  # module
