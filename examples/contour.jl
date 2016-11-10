using PlotlyJS

function contour1()
    x = y = [-2*pi + 4*pi*i/100 for i in 1:100]
    z = [sin(x[i]) * cos(y[j]) * sin(x[i]*x[i]+y[j]*y[j])/log(x[i]*x[i]+y[j]*y[j]+1)
         for i in 1:100 for j in 1:100]
    z_ = [z[i:i+99] for i in 1:100:10000]

    data = contour(;z=z_, x=x, y=y)

    plot(data)
end

function contour2()
    z =  [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    data = contour(;z=z)

    layout = Layout(;title="Basic Contour Plot")
    plot(data, layout)
end

function contour3()
    x = [-9, -6, -5 , -3, -1]
    y = [0, 1, 4, 5, 7]
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    trace = contour(x=x, y=y, z=z)

    layout = Layout(title="Setting the X and Y Coordinates in a Contour Plot")
    plot(trace, layout)
end

function contour4()
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    data = contour(;z=z, colorscale="Jet")

    layout = Layout(;title="Colorscale for Contour Plot")
    plot(data, layout)
end

function contour5()
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    data = contour(;z=z,
                   colorscale="Jet",
                   autocontour=false,
                   contours=Dict(:start=>0, :end=>8, :size=>2))

    layout = Layout(;title="Customizing Size and Range of Contours")
    plot(data, layout)
end

function contour6()
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    data = contour(;z=z, colorscale="Jet", dx=10, x0=5, dy=10, y0=10)

    layout = Layout(;title="Customizing Spacing Between X and Y Axis Ticks")

    plot(data, layout)
end

function contour7()
    z = [[nothing, nothing, nothing, 12, 13, 14, 15, 16],
        [nothing, 1, nothing, 11, nothing, nothing, nothing, 17],
        [nothing, 2, 6, 7, nothing, nothing, nothing, 18],
        [nothing, 3, nothing, 8, nothing, nothing, nothing, 19],
        [5, 4, 10, 9, nothing, nothing, nothing, 20],
        [nothing, nothing, nothing, 27, nothing, nothing, nothing, 21],
        [nothing, nothing, nothing, 26, 25, 24, 23, 22]]
    trace1 = contour(;z=z, showscale=false, xaxis="x1", yaxis="y1")
    trace2 = contour(;z=z, connectgaps=true, showscale=false,
                     xaxis="x2", yaxis="y2")
    trace3 = heatmap(;z=z, zsmooth="best",showscale=false,
                     xaxis="x3", yaxis="y3")
    trace4 = heatmap(;z=z, zsmooth="best", connectgaps=true,
                     showscale=false, xaxis="x4", yaxis="y4")
    data = [trace1, trace2, trace3, trace4]

    t = "Connect the Gaps Between Null Values in the Z Matrix"
    layout = Layout(;title=t,
                    xaxis=attr(;domain=[0,0.45], anchor="y1"),
                    yaxis=attr(;domain=[0.55,1], anchor="x1"),
                    xaxis2=attr(;domain=[0.55,1], anchor="y2"),
                    yaxis2=attr(;domain=[0.55,1], anchor="x2"),
                    xaxis3=attr(;domain=[0,0.45], anchor="y3"),
                    yaxis3=attr(;domain=[0,0.45], anchor="x3"),
                    xaxis4=attr(;domain=[0.55,1], anchor="y4"),
                    yaxis4=attr(;domain=[0,0.45], anchor="x4"))
    plot(data, layout)
end

function contour8()
    z = [2  4   7   12  13  14  15  16
         3  1   6   11  12  13  16  17
         4  2   7   7   11  14  17  18
         5  3   8   8   13  15  18  19
         7  4   10  9   16  18  20  19
         9  10  5   27  23  21  21  21
         11 14  17  26  25  24  23  22]
    trace1 = contour(;z=z, line_smoothing=0,
                     xaxis="x1", yaxis="y1")
    trace2 = contour(;z=z, line_smoothing=0.85,
                     xaxis="x2", yaxis="y2")
    data = [trace1, trace2]

    layout = Layout(;title="Smoothing Contour Lines",
                    xaxis=attr(;domain=[0,0.45], anchor="y1"),
                    yaxis=attr(;domain=[0,1], anchor="x1"),
                    xaxis2=attr(;domain=[0.55,1], anchor="y2"),
                    yaxis2=attr(;domain=[0,1], anchor="x2"))
    plot(data, layout)
end

function contour9()
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    data = contour(;z=z, contours_coloring="heatmap")

    layout = Layout(;title="Smooth Contour Coloring")
    plot(data, layout)
end

function contour10()
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    data = contour(;z=z, colorscale="Jet", contours_coloring="lines")

    layout = Layout(;title="Contour Lines")
    plot(data, layout)
end

function contour11()
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
   data = contour(;z=z,
                  colorscale=[[0, "rgb(166,206,227)"],
                              [0.25, "rgb(31,120,180)"],
                              [0.45, "rgb(178,223,138)"],
                              [0.64, "rgb(51,160,44)"],
                              [0.85, "rgb(251,154,153)"],
                              [1, "rgb(227,26,28)"]])

   layout = Layout(;title="Custom Contour Plot Colorscale")

   plot(data, layout)
end

function contour12()
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    data = contour(;z=z,
                   colorbar=attr(;title="Color Bar Title",titleside="right",
                                 titlefont=attr(;size=14,
                                                family="Arial, sans-serif")))

    layout = Layout(;title="Colorbar with Title")
    plot(data,layout)
end

function contour13()
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    data = contour(;z=z,
                   colorbar=attr(;thickness=75, thicknessmode="pixels",
                                 len=0.9, lenmode="fraction",
                                 outlinewidth=0))

    layout = Layout(;title="Colorbar Size for Contour Plots")
    plot(data,layout)
end

function contour14()
    z = [10     10.625  12.5  15.625  20
         5.625  6.25    8.125 11.25   15.625
         2.5    3.125   5.    8.125   12.5
         0.625  1.25    3.125 6.25    10.625
         0      0.625   2.5   5.625   10]
    data = contour(;z=z,
                   colorbar=attr(;ticks="outside", dtick=1,
                                 tickwidth=2, ticklen=10,
                                 tickcolor="grey", showticklabels=true,
                                 tickfont_size=15, xpad=50))

    layout = Layout(;title="Styling Color Bar Ticks for Contour Plots")
    plot(data,layout)
end
