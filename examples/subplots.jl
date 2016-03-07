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
