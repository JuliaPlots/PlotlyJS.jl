include("line_scatter.jl")

function subplots1()
    p1 = linescatter1()
    p2 = linescatter2()
    p = [p1 p2]
    p
end

function subplots2()
    p1 = linescatter1()
    p2 = linescatter2()
    p = [p1, p2]
    p
end


function subplots3()
    p1 = linescatter6()
    p2 = linescatter2()
    p3 = linescatter3()
    p4 = batman()
    p = [p1 p2; p3 p4]
    p.plot.layout["showlegend"] = false
    p.plot.layout["width"] = 1000
    p.plot.layout["height"] = 600
    p
end


function subplots_withcomprehension()
    hcat([plot(scatter(x = 1:5, y = rand(5))) for i in 1:3]...)
end


function subplots_withsharedaxes()
    data =  [
    scatter(x=1:3, y=2:4),
    scatter(x=20:10:40, y=fill(5, 3), xaxis="x2", yaxis="y"),
    scatter(x=2:4, y=600:100:800, xaxis="x", yaxis="y3"),
    scatter(x=4000:1000:6000, y=7000:1000:9000, xaxis="x4", yaxis="y4")
    ]
    layout = Layout(
        xaxis_domain=[0, 0.45],
        yaxis_domain=[0, 0.45],
        xaxis4=attr(domain=[0.55, 1.0], anchor="y4"),
        xaxis2_domain=[0.55, 1],
        yaxis3_domain=[0.55, 1],
        yaxis4=attr(domain=[0.55, 1], anchor="x4")    
    )
    plot(data, layout)
end
