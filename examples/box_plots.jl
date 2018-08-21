using PlotlyJS

function box1()
    y0 = rand(50)
    y1 = rand(50) + 1
    trace1 = box(;y=y0)
    trace2 = box(;y=y1)
    data = [trace1, trace2]
    plot(data)
end

function box2()
    data = box(;y=[0, 1, 1, 2, 3, 5, 8, 13, 21],
                boxpoints="all",
                jitter=0.3,
                pointpos=-1.8)
    plot(data)
end


function box3()
    trace1 = box(;x=[1, 2, 3, 4, 4, 4, 8, 9, 10],
                  name="Set 1")
    trace2 = box(;x=[2, 3, 3, 3, 3, 5, 6, 6, 7],
                  name="Set 2")
    data = [trace1, trace2]
    layout = Layout(;title="Horizontal Box Plot")

    plot(data, layout)
end


function box4()
    x0 = ["day 1", "day 1", "day 1", "day 1", "day 1", "day 1",
          "day 2", "day 2", "day 2", "day 2", "day 2", "day 2"]
    trace1 = box(;y=[0.2, 0.2, 0.6, 1.0, 0.5, 0.4, 0.2, 0.7, 0.9, 0.1, 0.5, 0.3],
                  x=x0,
                  name="kale",
                  marker_color="#3D9970")
    trace2 = box(;y=[0.6, 0.7, 0.3, 0.6, 0.0, 0.5, 0.7, 0.9, 0.5, 0.8, 0.7, 0.2],
                  x=x0,
                  name="radishes",
                  marker_color="#FF4136")
    trace3 = box(;y=[0.1, 0.3, 0.1, 0.9, 0.6, 0.6, 0.9, 1.0, 0.3, 0.6, 0.8, 0.5],
                  x=x0,
                  name="carrots",
                  marker_color="#FF851B")
    data = [trace1, trace2, trace3]
    layout = Layout(;yaxis=attr(title="normalized moisture", zeroline=false),
                    boxmode="group")
    plot(data, layout)
end


function box5()
    trace1 = box(;y=[0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5,
                     7.75, 8.15, 8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5,
                     12, 16, 20.90, 22.3, 23.25],
                  name="All Points",
                  jitter=0.3,
                  pointpos=-1.8,
                  marker_color="rgb(7, 40, 89)",
                  boxpoints="all")
    trace2 = box(;y=[0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5,
                     7.75, 8.15, 8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5,
                     12, 16, 20.90, 22.3, 23.25],
                  name="Only Wiskers",
                  marker_color="rgb(9, 56, 125)",
                  boxpoints=false)
    trace3 = box(;y=[0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5,
                     7.75, 8.15, 8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5,
                     12, 16, 20.90, 22.3, 23.25],
                  name="Suspected Outlier",
                  marker=attr(color="rgb(8, 8, 156)",
                              outliercolor="rgba(219, 64, 82, 0.6)",
                              line=attr(outliercolor="rgba(219, 64, 82, 1.0)",
                                        outlierwidth=2)),
                  boxpoints="suspectedoutliers")
    trace4 = box(;y=[0.75, 5.25, 5.5, 6, 6.2, 6.6, 6.80, 7.0, 7.2, 7.5, 7.5,
                     7.75, 8.15, 8.15, 8.65, 8.93, 9.2, 9.5, 10, 10.25, 11.5,
                     12, 16, 20.90, 22.3, 23.25],
                  name="Wiskers and Outliers",
                  marker_color="rgb(107, 174, 214)",
                  boxpoints="Outliers")
    data = [trace1, trace2, trace3, trace4]
    layout = Layout(;title="Box Plot Styling Outliers")
    plot(data, layout)
end


function box6()
    trace1 = box(;y=[2.37, 2.16, 4.82, 1.73, 1.04, 0.23, 1.32, 2.91, 0.11,
                     4.51, 0.51, 3.75, 1.35, 2.98, 4.50, 0.18, 4.66, 1.30,
                     2.06, 1.19],
                  name="Only Mean",
                  marker_color="rgb(8, 81, 156)",
                  boxmean=true)
    trace2 = box(;y=[2.37, 2.16, 4.82, 1.73, 1.04, 0.23, 1.32, 2.91, 0.11,
                     4.51, 0.51, 3.75, 1.35, 2.98, 4.50, 0.18, 4.66, 1.30,
                     2.06, 1.19],
                  name="Mean and Standard Deviation",
                  marker_color="rgb(10, 140, 208)",
                  boxmean="sd")
    data = [trace1, trace2]
    layout = Layout(;title="Box Plot Styling Mean and Standard Deviation")
    plot(data, layout)
end


function box7()
    y0 = ["day 1", "day 1", "day 1", "day 1", "day 1", "day 1",
          "day 2", "day 2", "day 2", "day 2", "day 2", "day 2"]
    trace1 = box(;x=[0.2, 0.2, 0.6, 1.0, 0.5, 0.4, 0.2, 0.7, 0.9, 0.1, 0.5, 0.3],
                  y=y0,
                  name="kale",
                  marker_color="#3D9970",
                  boxmean=false,
                  orientation="h")
    trace2 = box(;x=[0.6, 0.7, 0.3, 0.6, 0.0, 0.5, 0.7, 0.9, 0.5, 0.8, 0.7, 0.2],
                  y=y0,
                  name="radishes",
                  marker_color="#FF4136",
                  boxmean=false,
                  orientation="h")
    trace3 = box(;x=[0.1, 0.3, 0.1, 0.9, 0.6, 0.6, 0.9, 1.0, 0.3, 0.6, 0.8, 0.5],
                  y=y0,
                  name="carrots",
                  marker_color="#FF851B",
                  boxmean=false,
                  orientation="h")
    data = [trace1, trace2, trace3]
    layout = Layout(;title="Grouped Horizontal Box Plot",
                     xaxis=attr(title="normalized moisture", zeroline=false),
                     boxmode="group")
    plot(data, layout)
end


function box8()
    trace1 = box(;y=[1, 2, 3, 4, 4, 4, 8, 9, 10],
                  name="Sample A",
                  marker_color="rgb(214, 12, 140)")
    trace2 = box(;y=[2, 3, 3, 3, 3, 5, 6, 6, 7],
                  name="Sample B",
                  marker_color="rgb(0, 128, 128)")
    data = [trace1, trace2]
    layout = Layout(;title="Colored Box Plot")
    plot(data, layout)
end

function box9()
    xData = ["Carmelo<br>Anthony", "Dwyane<br>Wade", "Deron<br>Williams",
             "Brook<br>Lopez", "Damian<br>Lillard", "David<br>West",
             "Blake<br>Griffin", "David<br>Lee", "Demar<br>Derozan"]

    _getrandom(num, mul) = mul .* rand(num)

    yData = Array[
            _getrandom(30, 10),
            _getrandom(30, 20),
            _getrandom(30, 25),
            _getrandom(30, 40),
            _getrandom(30, 45),
            _getrandom(30, 30),
            _getrandom(30, 20),
            _getrandom(30, 15),
            _getrandom(30, 43)
        ]
    colors = ["rgba(93, 164, 214, 0.5)", "rgba(255, 144, 14, 0.5)",
              "rgba(44, 160, 101, 0.5)", "rgba(255, 65, 54, 0.5)",
              "rgba(207, 114, 255, 0.5)", "rgba(127, 96, 0, 0.5)",
              "rgba(255, 140, 184, 0.5)", "rgba(79, 90, 117, 0.5)",
              "rgba(222, 223, 0, 0.5)"]

    data = GenericTrace[]
    for i in 1:length(xData)
        trace = box(;y=yData[i],
                     name=xData[i],
                     boxpoints="all",
                     jitter=0.5,
                     whiskerwidth=0.2,
                     fillcolor="cls",
                     marker_size=2,
                     line_width=1)
        push!(data, trace)
    end

    t = "Points Scored by the Top 9 Scoring NBA Players in 2012"
    layout = Layout(;title=t,
                     yaxis=attr(autorange=true, showgrid=true, zeroline=true,
                                dtick=5, gridcolor="rgb(255, 255, 255)",
                                gridwidth=1,
                                zerolinecolor="rgb(255, 255, 255)",
                                zerolinewidth=2),
                     margin=attr(l=40, r=30, b=80, t=100),
                     paper_bgcolor="rgb(243, 243, 243)",
                     plot_bgcolor="rgb(243, 243, 243)",
                     showlegend=false)
    plot(data, layout)
end

function box10()
    n_box = 30
    colors = ["hsl($i, 50%, 50%)" for i in range(0, stop=360, length=n_box)]

    gen_y_data(i) =
        3.5*sin(pi*i/n_box) + i/n_box + (1.5+0.5*cos(pi*i/n_box)).*rand(10)

    ys = Array[gen_y_data(i) for i in 1:n_box]

    # Create Traces
    data = GenericTrace[box(y=y, marker_color=mc) for (y, mc) in zip(ys, colors)]

    #Format the layout
    layout = Layout(;xaxis=attr(;showgrid=false, zeroline=false,
                                 tickangle=60, showticklabels=true),
                     yaxis=attr(;zeroline=false, gridcolor="white"),
                     paper_bgcolor="rgb(233, 233, 233)",
                     plot_bgcolor="rgb(233, 233, 233)",
                     showlegend=true)
    plot(data, layout)
end
