include("line_scatter.jl")

function exsubplots1()
    p1 = exlinescatter1()
    p2 = exlinescatter2()
    p = [p1 p2]
    p
end

function exsubplots2()
    p1 = exlinescatter1()
    p2 = exlinescatter2()
    p = [p1, p2]
    p
end


function exsubplots3()
    p1 = exlinescatter6()
    p2 = exlinescatter2()
    p3 = exlinescatter3()
    p4 = exlinescatter4()
    p = [p1 p2; p3 p4]
    p.plot.layout["showlegend"] = false
    p.plot.layout["width"] = 1000
    p.plot.layout["height"] = 600
    p
end
