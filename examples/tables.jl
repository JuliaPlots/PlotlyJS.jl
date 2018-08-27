using PlotlyJS
using DataFrames

function table1()
    values = [
        "Salaries" 1200000 1300000 1300000 1400000
        "Office" 20000 20000 20000 20000
        "Merchandise" 80000 70000 120000 90000
        "Legal" 2000 2000 2000 2000
        "TOTAL" 12120000 130902000 131222000 14102000
    ]

    trace = table(
        header=attr(
            values=["Expenses", "Q1", "Q2", "Q3", "Q4"],
            align="center", line=attr(width=1, color="black"),
            fill_color="grey", font=attr(family="Arial", size=12, color="white")
        ),
        cells=attr(
            values=values, align="center", line=attr(color="black", width=1),
            font=attr(family="Arial", size=11, color="black")
        )
    )
    plot(trace)

end

function table2()
    values = [
        "Salaries" 1200000 1300000 1300000 1400000
        "Office" 20000 20000 20000 20000
        "Merchandise" 80000 70000 120000 90000
        "Legal" 2000 2000 2000 2000
        "TOTAL" 12120000 130902000 131222000 14102000
    ]

    trace = table(
        header=attr(
            values=["EXPENSES", "Q1", "Q2", "Q3", "Q4"],
            align=["left", "center"], line=attr(width=1, color="#506784"),
            fill_color="#119DFF",
            font=attr(family="Arial", size=12, color="white")
        ),
        cells=attr(
            values=values, align=["left", "center"],
            line=attr(color="#506784", width=1),
            font=attr(family="Arial", size=11, color="#506784"),
            fill_color=["#25FEFD", "white"]
        )
    )
    plot(trace)

end


function table2a()
    p1 = table1()
    restyle!(p1,
        header=attr(
            align=["left", "center"], line_color="#506784", fill_color="#119DFF"
        ),
        cells=attr(
            align=["left", "center"], line_color="#506784",
            fill_color=["#25FEFD", "white"], font_color="#506784"
        )
    )
    p1
end


function table3()
    nm = tempname()
    url = "https://raw.githubusercontent.com/plotly/datasets/master/Mining-BTC-180.csv"
    download(url, nm)
    df = readtable(nm)
    rm(nm)

    data = Array(df)

    trace = table(
        columnwidth=[200, 500, 600, 600, 400, 400, 600, 600, 600],
        # columnorder=0:9,
        header=attr(
            values=map(x-> replace(string(x), '_' => '-'), names(df)),
            align="center",
            line=attr(width=1, color="rgb(50, 50, 50)"),
            fill_color=["rgb(235, 100, 230)"],
            font=attr(family="Arial", size=12, color="white")
        ),
        cells=attr(
            values=Array(df),
            align=["center", "center"],
            line=attr(width=1, color="black"),
            fill_color=["rgba(228, 222, 249, 0.65)", "rgb(235, 193, 238)", "rgba(228, 222, 249, 0.65)"],
            font=attr(family="Arial", size=10, color="black")
        )
    )

    layout = Layout(
        title="Bitcoin mining stats for 180 days",
        width=1200
    )
    plot(trace, layout)
end
