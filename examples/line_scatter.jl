module LineScatterExamples

using Plotlyjs

function example1()
    trace1 = scatter(;x=1:4, y=[10, 15, 13, 17], mode="markers")
    trace2 = scatter(;x=2:5, y=[16, 5, 11, 9], mode="lines")
    trace3 = scatter(;x=1:4, y=[12, 9, 15, 12], mode="lines+markers")
    p = Plot([trace1, trace2, trace3]); show(p); p
end

function example2()
    trace1 = scatter(;x=1:5, y=[1, 6, 3, 6, 1],
                      mode="markers", name="Team A",
                      text=["A-1", "A-2", "A-3", "A-4", "A-5"]
                      marker_size=12)

    trace2 = scatter(;x=1:5+0.5, y=[4, 1, 7, 1, 4],
                      mode="markers", name= "Team B",
                      text=["B-a", "B-b", "B-c", "B-d", "B-e"]
    # setting marker.size this way is _equivalent_ to what we did for trace1
    trace2["marker"] = Dict(:size => 12)

    data = [trace1, trace2]
    layout = Layout(;title="Data Labels Hover", xaxis_range=[0.75, 5.25],
                     yaxis_range=[0, 8])
    p = Plot(data, layout); show(p); p
end

function example3()
    trace1 = scatter(;x=1:5, y=[1, 6, 3, 6, 1],
                      mode="markers+text", name="Team A",
                      textposition="top center",
                      text=["A-1", "A-2", "A-3", "A-4", "A-5"],
                      marker_size=12, textfont_family="Raleway, sans-serif")

    trace2 = scatter(;x=1:5+0.5, y=[4, 1, 7, 1, 4],
                      mode="markers+text", name= "Team B",
                      textposition="bottom center",
                      text= ["B-a", "B-b", "B-c", "B-d", "B-e"],
                      marker_size=12, textfont_family="Times New Roman")

    data = [trace1, trace2]

    layout = Layout(;title="Data Labels on the Plot", xaxis_range=[0.75, 5.25],
                     yaxis_range=[0, 8], legend_y=0.5, legend_yref="paper",
                     legend_font=Dict(:family => "Arial, sans-serif", :size => 20,
                                      :color => "grey"))
    p = Plot(data, layout); show(p); p
end

function example4()
    trace1 = scatter(;y=fill(5, 40), mode="markers", marker_size=40,
                      marker_color=0:39)
    layout = Layout(title="Scatter Plot with a Color Dimension")
    p = Plot(trace1, layout); show(p); p
end

function example5()

    country = ["Switzerland (2011)", "Chile (2013)", "Japan (2014)",
               "United States (2012)", "Slovenia (2014)", "Canada (2011)",
               "Poland (2010)", "Estonia (2015)", "Luxembourg (2013)",
               "Portugal (2011)"]

    votingPop = [40, 45.7, 52, 53.6, 54.1, 54.2, 54.5, 54.7, 55.1, 56.6]
    regVoters = [49.1, 42, 52.7, 84.3, 51.7, 61.1, 55.3, 64.2, 91.1, 58.9]

    trace1 = scatter(;x=votingPop, y=country, mode="markers",
                      name="Percent of estimated voting age population",
                      marker_color="rgba(156, 165, 196, 0.95)",
                      marker_line_color="rgba(156, 165, 196, 1.0)",
                      marker_line_width=1,
                      marker_size=16, marker_symbol="circle")

    trace2 = scatter(;x=regVoters, y=country, mode="markers",
                      name="Percent of estimated registered voters")
    # also could have set the marker props above by using a dict
    trace2["marker"] = Dict(:color => "rgba(204, 204, 204, 0.95)",
                           :line => Dict(:color=> "rgba(217, 217, 217, 1.0)",
                                         :width=> 1),
                           :symbol => "circle",
                           :size => 16)

    data = [trace1, trace2]

    layout = Layout(title="Votes cast for ten lowest voting age population in OECD countries",
                    width=600,
                    height=600,
                    paper_bgcolor="rgb(254, 247, 234)",
                    plot_bgcolor="rgb(254, 247, 234)",
                    hovermode="closest")
    layout["xaxis"] = Dict(:showgrid => false,
                           :showline => true,
                           :linecolor => "rgb(102, 102, 102)",
                           :titlefont => Dict(:font=> Dict(:color =>"rgb(204, 204, 204)")),
                           :tickfont => Dict(:font=> Dict(:color =>"rgb(102, 102, 102)")),
                           :autotick => false,
                           :dtick => 10,
                           :ticks => "outside",
                           :tickcolor => "rgb(102, 102, 102)")
    layout[:margin] = Dict(:l => 140, :r => 40, :b => 50, :t => 80)
    layout["legend"] = Dict(:font => Dict(:size => 10),
                            :yanchor => "middle",
                            :xanchor => "right")
    p = Plot(data, layout); show(p); p
end

function example6()
    trace1 = scatter(;x=[52698, 43117], y=[53, 31],
                      mode="markers",
                      name="North America",
                      text=["United States", "Canada"])
    trace1["marker"] = Dict(:color => "rgb(164, 194, 244)",
                            :size => 12,
                            :line => Dict(:color => "white", :width => 0.5))

    trace2 = scatter(;x=[39317, 37236, 35650, 30066, 29570, 27159, 23557, 21046, 18007],
                      y=[33, 20, 13, 19, 27, 19, 49, 44, 38],
                      mode="markers", name="Europe",
                      marker_size=12, marker_color="rgb(255, 217, 102)",
                      text=["Germany", "Britain", "France", "Spain", "Italy", "Czech Rep.",
                            "Greece", "Poland"])

    trace3 = scatter(;x=[42952, 37037, 33106, 17478, 9813, 5253, 4692, 3899],
                      y=[23, 42, 54, 89, 14, 99, 93, 70],
                      mode="markers",
                      name="Asia/Pacific",
                      marker_size=12, marker_color="rgb(234, 153, 153)",
                      text=["Australia", "Japan", "South Korea", "Malaysia", "China", "Indonesia", "Philippines", "India"])

    trace4 = scatter(;x=[19097, 18601, 15595, 13546, 12026, 7434, 5419],
                      y=[43, 47, 56, 80, 86, 93, 80],
                      mode="markers", name="Latin America",
                      marker_size=12, marker_color="rgb(142, 124, 195)",
                      text=["Chile", "Argentina", "Mexico", "Venezuela", "Venezuela", "El Salvador", "Bolivia"])

    data = [trace1, trace2, trace3, trace4]

    layout = Layout(;title="Quarter 1 Growth",
                     xaxis_title="GDP per Capita", xaxis_showgrid=false, xaxis_zeroline=false,
                     yaxis_title="Percent", yaxis_zeroline=false)
    layout["xaxis"] = Dict(:title => "GDP per Capita", :showgrid => false, :zeroline => false)
    layout["yaxis"] = Dict(:title => "Percent", :showline => false)

    p = Plot(data, layout); show(p); p
end

end  # module
