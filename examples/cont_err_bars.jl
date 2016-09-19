using PlotlyJS
using Blink

function errorbars1()
    trace1 = scatter(;x= append!([1:10],[10:-1:1]), 
                     y = append!([2:11],[9:-1:0]),
                     fill = "tozerox",
                     fillcolor = "rgba(0,100,80,0.2)",
                     line_color = "transparent",
                     name = "Fair",
                     showlegend = false)
    trace2 = scatter(;x= append!([1:10],[10:-1:1]),
                     y = [5.5,3.,5.5,8.,6.,3.,8.,5.,6.,5.5,4.75,5.,4.,7.,2., 4.,7.,4.4,2.,4.5],
                     fill = "tozerox",
                     fillcolor = "rgba(0,176,246,0.2)",
                     line_color = "transparent",
                     name = "Premium",
                     showlegend = false)
    trace3 = scatter(;x= append!([1:10],[10:-1:1]),
                     y = [11.,9.,7.,5.,3.,1.,3.,5.,3.,1.,-1.,1.,3.,1.,-0.5,1.,3.,5.,7.,9.],
                     fill = "tozerox",
                     fillcolor = "rgba(231,107,243,0.2)",
                     line_color = "transparent",
                     name = "Fair",
                     showlegend = false)
    trace4 = scatter(;x = [1:10], y = [1:10],
                     line_color = "rgb(00,100,80)",
                     mode = "lines",
                     name = "Fair")
    trace5 = scatter(;x = [1:10], y = [5.,2.5,5.,7.5,5.,2.5,7.5,4.5,5.5,5.],
                     line_color = "rgb(0,176,246)",
                     mode = "lines",
                     name = "Premium")
    trace6 = scatter(;x = [1:10], y = append!([10:-2:0],[2,4,2,0]),
                     line_color = "rgb(231,107,243)",
                     mode = "lines",
                     name = "Ideal")
    data = [trace1, trace2, trace3, trace4, trace5, trace6]
    layout = Layout(;paper_bgcolor = "rgb(255,255,255)",
                    plot_bgcolor = "rgb(229,229,229)",
                    
                    xaxis_gridcolor = "rgb(255,255,255)",
                    xaxis_range = [1,10],
                    xaxis_showgrid = true,
                    xaxis_showline = false,
                    xaxis_showticklabels = true,
                    xaxis_tickcolor = "rgb(127,127,127)",
                    xaxis_ticks = "outside",
                    xaxis_zeroline = false, 

                    yaxis_gridcolor = "rgb(255,255,255)",
                    yaxis_showgrid = true,
                    yaxis_showline = false,
                    yaxis_showticklabels = true,
                    yaxis_tickcolor = "rgb(127,127,127)",
                    yaxis_ticks = "outside",
                    yaxis_zeroline = false)

    plot(data,layout)
end

function errorbars2()
    function _random_date(_start,_end,_mul)

        function _getTime(date)
            return date-DateTime(Date(1970,01,01)) 
            #returns -18000000 less than getTime() in JS
        end

        return Date(convert(Base.Dates.Millisecond,Int(_getTime(_start)) + _mul * (Int(_getTime(_end) - _getTime(_start)))))
        #calling Date on this value (which is in Milliseconds) just returns 0001-01-01 for all inputs. Not sure if this is a bug in my code, or if Julia just doesn't have a method on Date() to convert from milliseconds to a DateTime
    end

    function _date_list(y1,m1,d1,y2,m2,d2,count)
        a = []
        i = 1
        while i < count+1
            append!(a,[_random_date(DateTime(y1,m1,d1),DateTime(y2,m2,d2),i)])
            i += 1
        end
        return a
    end

    function _random_number(num,mul)
        value = []
        j = 0
        rand = 0
        while j <= num+1
            rand = rand() * mul
            append!(value,[rand])
            j += 1
        end
        return value
    end

    trace1 = scatter(;x = _date_list(2001,02,01,2001,03,01,50),
                     y = _random_number(50,20),
                     line_width = 0,
                     marker_color = "444",
                     mode = "lines",
                     name = "Lower Bound")

    trace2 = scatter(;x = _date_list(2001,02,01,2001,03,01,50),
                     y = _random_number(50,21),
                     fill = "tonexty",
                     fillcolor = "rgba(68,68,68,0.3)",
                     line_color = "rgb(31,119,180)",
                     mode = "lines",
                     name = "Measurement")

    trace3 = scatter(;x = _date_list(2001,02,01,2001,03,01,50),
                     y = random_number(50,22),
                     fill: "tonexty",
                     fillcolor = "rgba(68,68,68,0.3)",
                     line_width = 0,
                     marker_color = "444",
                     mode = "lines",
                     name = "Upper Bound")

    data = [trace1, trace2, trace3]
    layout = Layout(;title="Continuous, variable value error bars<br> Notiec the hover text!", yaxis_title="Wind speed (m/s)")

    plot(data,layout)
end
