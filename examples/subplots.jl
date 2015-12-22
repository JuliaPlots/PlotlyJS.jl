include("line_scatter.jl")

function subplots1(showme=true)
    p1 = linescatter1(false)
    p2 = linescatter2(false)
    p = [p1 p2]
    showme && show(p)
    p
end

function subplots2(showme=true)
    p1 = linescatter1(false)
    p2 = linescatter2(false)
    p = [p1, p2]
    showme && show(p)
    p
end


function subplots3(showme=true)
    p1 = linescatter6(false)
    p2 = linescatter2(false)
    p3 = linescatter3(false)
    p4 = linescatter4(false)
    p = [p1 p2; p3 p4]
    p.layout["showlegend"] = false
    p.layout["width"] = 1000
    p.layout["height"] = 600
    showme && show(p)
    p
end
