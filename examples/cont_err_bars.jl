using PlotlyJS

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
