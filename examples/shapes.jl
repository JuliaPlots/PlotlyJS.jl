using PlotlyJS

function house()
    trace1 = scatter()
    x0 = [2,   2,   5.5, 9,   9, 2,   5, 5, 6]
    y0 = [1,   5.5, 9.5, 5.5, 1, 5.5, 1, 4, 4]
    x1 = [2,   5.5, 9,   9,   2, 9,   5, 6, 6]
    y1 = [5.5, 9.5, 5.5, 1,   1, 5.5, 4, 4, 1]
    shapes = line(x0, x1, y0, y1; xref="x", yref="y")
    plot([trace1],
         Layout(;shapes=shapes, xaxis_range=(1, 10), yaxis_range=(0, 10)))
end

function house2()
    trace1 = scatter()
    _p = string("M 2 1 L 2 5.5 L 5.5 9.6 L 9 5.5 L 9 1 L 2 1 ",
                "M 2 5.5 L 9 5.5 ",
                "M 5 1 L 5 4 L 6 4 L 6 1 Z")
    plot([trace1],
         Layout(;shapes=[path(_p)], xaxis_range=(1, 10), yaxis_range=(0, 10)))
end

function clusters()
    @eval using Distributions
    x0 = rand(Normal(2, 0.45), 300)
    y0 = rand(Normal(2, 0.45), 300)
    x1 = rand(Normal(6, 0.4), 200)
    y1 = rand(Normal(6, 0.4), 200)
    x2 = rand(Normal(4, 0.3), 200)
    y2 = rand(Normal(4, 0.3), 200)

    data = [scatter(;x=x0, y=y0, mode="markers"),
              scatter(;x=x1, y=y1, mode="markers"),
              scatter(;x=x2, y=y2, mode="markers"),
              scatter(;x=x1, y=y0, mode="markers")]

    args = [(x0, y0, "blue"), (x1, y1, "orange"), (x2, y2, "green"),
            (x1, y0, "red")]
    shapes = [circle(x0=minimum(x), y0=minimum(y),
                     x1=maximum(x), y1=maximum(y);
                     opacity=0.2, fillcolor=c, line_color=c)
              for (x, y, c) in args]
    plot(data, Layout(;height=400, width=480, showlegend=false, shapes=shapes))
end

function temperature()
    x = ["2015-02-01", "2015-02-02", "2015-02-03", "2015-02-04", "2015-02-05",
         "2015-02-06", "2015-02-07", "2015-02-08", "2015-02-09", "2015-02-10",
         "2015-02-11", "2015-02-12", "2015-02-13", "2015-02-14", "2015-02-15",
         "2015-02-16", "2015-02-17", "2015-02-18", "2015-02-19", "2015-02-20",
         "2015-02-21", "2015-02-22", "2015-02-23", "2015-02-24", "2015-02-25",
         "2015-02-26", "2015-02-27", "2015-02-28"]
    y = rand(1:20, length(x))
    data = scatter(;x=x, y=y, name="temperature", mode="line")

    shapes = rect(["2015-02-04", "2015-02-20"], ["2015-02-06", "2015-02-22"],
                  0, 1; fillcolor="#d3d3d3", opacity=0.2, line_width=0,
                  xref="x", yref="paper")
    plot(data, Layout(shapes=shapes, width=500, height=500))
end

function vlines1()
    # one scalar argument produces one line. Need to wrap in an array because
    # layout.shapes should be an array
    trace1 = scatter(;x=1:10, y=(1:10).^2)
    shapes = [vline(2)]
    plot([trace1], Layout(;shapes=shapes))
end

function vlines2()
    # one argument draws a vertical line up the entire plot
    trace1 = scatter(;x=1:10, y=(1:10).^2)
    shapes = vline([2, 6])
    plot([trace1], Layout(;shapes=shapes))
end

function vlines3()
    # yref paper makes the 2nd and 3rd arguments on a (0, 1) scale vertically
    # so 0.5 is 1/2 through the plot regardless of the values on y-axis
    trace1 = scatter(;x=1:10, y=(1:10).^2)
    shapes = vline([2, 6], 0, 0.5; yref="paper")
    plot([trace1], Layout(;shapes=shapes))
end

function vlines4()
    # Whichever argument is a scalar is repeated
    trace1 = scatter(;x=1:10, y=(1:10).^2)
    shapes = vline([2, 6], 0, [0.5, 0.75]; yref="paper")
    plot([trace1], Layout(;shapes=shapes))
end

function vlines5()
    # we can also set arbitrary line attributes line color and dash
    trace1 = scatter(;x=1:10, y=(1:10).^2)
    shapes = vline([2, 6], 0, [0.5, 0.75]; yref="paper",
                   line_color="green", line_dash="dashdot")
    plot([trace1], Layout(;shapes=shapes))
end

function hlines1()
    # one scalar argument produces one line. Need to wrap in an array because
    # layout.shapes should be an array
    trace1 = scatter(;x=1:10, y=(1:10).^2)
    shapes = [hline(2)]
    plot([trace1], Layout(;shapes=shapes))
end

function hlines2()
    # one argument draws a horizontal line across the entire plot
    trace1 = scatter(;x=1:10, y=(1:10).^2)
    shapes = hline([25, 81])
    plot([trace1], Layout(;shapes=shapes))
end

function hlines3()
    # xref paper makes the 2nd and 3rd arguments on a (0, 1) scale horizontally
    # so 0.5 is 1/2 through the plot regardless of the values on x-axis
    trace1 = scatter(;x=1:10, y=(1:10).^2)
    shapes = hline([25, 81], 0, 0.5; xref="paper")
    plot([trace1], Layout(;shapes=shapes))
end

function hlines4()
    # Whichever argument is a scalar is repeated
    trace1 = scatter(;x=1:10, y=(1:10).^2)
    shapes = hline([25, 81], 0, [0.5, 0.75]; xref="paper")
    plot([trace1], Layout(;shapes=shapes))
end

function hlines5()
    # we can also set arbitrary line attributes line color and dash
    trace1 = scatter(;x=1:10, y=(1:10).^2)
    shapes = hline([25, 81], 0, [0.5, 0.75]; xref="paper",
                   line_color="green", line_dash="dashdot")
    plot([trace1], Layout(;shapes=shapes))
end
