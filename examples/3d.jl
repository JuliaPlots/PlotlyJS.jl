using PlotlyJS
using DataFrames

import Colors: color, RGB
import CSV
import Distributions: MvNormal
import LinearAlgebra
import RDatasets

const DATA_DIR = joinpath(dirname(pathof(PlotlyJS)), "..", "datasets"); # hide
nothing # hide

function random_line()
    n = 400
    rw() = cumsum(randn(n))
    trace1 = scatter3d(;x=rw(),y=rw(), z=rw(), mode="lines",
                        marker=attr(color="#1f77b4", size=12, symbol="circle",
                                    line=attr(color="rgb(0,0,0)", width=0)),
                        line=attr(color="#1f77b4", width=1))
    trace2 = scatter3d(;x=rw(),y=rw(), z=rw(), mode="lines",
                        marker=attr(color="#9467bd", size=12, symbol="circle",
                                    line=attr(color="rgb(0,0,0)", width=0)),
                        line=attr(color="rgb(44, 160, 44)", width=1))
    trace3 = scatter3d(;x=rw(),y=rw(), z=rw(), mode="lines",
                        marker=attr(color="#bcbd22", size=12, symbol="circle",
                                    line=attr(color="rgb(0,0,0)", width=0)),
                        line=attr(color="#bcbd22", width=1))
    layout = Layout(autosize=false, width=500, height=500,
                    margin=attr(l=0, r=0, b=0, t=65))
    plot([trace1, trace2, trace3], layout)
end

function topo_surface()
    # Source: "https://raw.githubusercontent.com/plotly/datasets/master/api_docs/mt_bruno_elevation.csv"
    # Read data into DataFrame:
    z = collect.(Float64, CSV.File(joinpath(DATA_DIR, "mt_bruno_elevation.csv"); drop=[1], normalizenames=true))
    
    trace = surface(z=z)
    layout = Layout(title="Mt. Bruno Elevation", autosize=false, width=500,
                    height=500, margin=attr(l=65, r=50, b=65, t=90))
    plot(trace, layout)
end

function multiple_surface()
    z1 = Vector[[8.83, 8.89, 8.81, 8.87, 8.9, 8.87],
                [8.89, 8.94, 8.85, 8.94, 8.96, 8.92],
                [8.84, 8.9, 8.82, 8.92, 8.93, 8.91],
                [8.79, 8.85, 8.79, 8.9, 8.94, 8.92],
                [8.79, 8.88, 8.81, 8.9, 8.95, 8.92],
                [8.8, 8.82, 8.78, 8.91, 8.94, 8.92],
                [8.75, 8.78, 8.77, 8.91, 8.95, 8.92],
                [8.8, 8.8, 8.77, 8.91, 8.95, 8.94],
                [8.74, 8.81, 8.76, 8.93, 8.98, 8.99],
                [8.89, 8.99, 8.92, 9.1, 9.13, 9.11],
                [8.97, 8.97, 8.91, 9.09, 9.11, 9.11],
                [9.04, 9.08, 9.05, 9.25, 9.28, 9.27],
                [9, 9.01, 9, 9.2, 9.23, 9.2],
                [8.99, 8.99, 8.98, 9.18, 9.2, 9.19],
                [8.93, 8.97, 8.97, 9.18, 9.2, 9.18]]
    z2 = map(x -> x .+ 1, z1)
    z3 = map(x -> x .- 1, z1)
    trace1 = surface(z=z1, colorscale="Viridis")
    trace2 = surface(z=z2, showscale=false, opacity=0.9, colorscale="Viridis")
    trace3 = surface(z=z3, showscale=false, opacity=0.9, colorscale="Viridis")
    plot([trace1, trace2, trace3])
end

function clustering_alpha_shapes()
    # load data
    iris = RDatasets.dataset("datasets", "iris")
    nms = unique(iris.Species)
    colors = [RGB(0.89, 0.1, 0.1), RGB(0.21, 0.50, 0.72), RGB(0.28, 0.68, 0.3)]

    data = GenericTrace[]

    for (i, nm) in enumerate(nms)
        df = iris[iris[!, :Species] .== nm, :]
        x = df[!, :SepalLength]
        y = df[!, :SepalWidth]
        z = df[!, :PetalLength]
        trace = scatter3d(;name=nm, mode="markers",
                           marker_size=3, marker_color=colors[i], marker_line_width=0,
                           x=x, y=y, z=z)
        push!(data, trace)

        cluster = mesh3d(;color=colors[i], opacity=0.3, x=x, y=y, z=z)
        push!(data, cluster)
    end

    # notice the nested attrs to create complex JSON objects
    layout = Layout(width=800, height=550, autosize=false, title="Iris dataset",
                    scene=attr(xaxis=attr(gridcolor="rgb(255, 255, 255)",
                                          zerolinecolor="rgb(255, 255, 255)",
                                          showbackground=true,
                                          backgroundcolor="rgb(230, 230,230)"),
                               yaxis=attr(gridcolor="rgb(255, 255, 255)",
                                           zerolinecolor="rgb(255, 255, 255)",
                                           showbackground=true,
                                           backgroundcolor="rgb(230, 230,230)"),
                               zaxis=attr(gridcolor="rgb(255, 255, 255)",
                                           zerolinecolor="rgb(255, 255, 255)",
                                           showbackground=true,
                                           backgroundcolor="rgb(230, 230,230)"),
                               aspectratio=attr(x=1, y=1, z=0.7),
                               aspectmode="manual"))
    plot(data, layout)
end

function scatter_3d()
    Σ = fill(0.5, 3, 3) + LinearAlgebra.Diagonal([0.5, 0.5, 0.5])
    obs1 = rand(MvNormal(zeros(3), Σ), 200)'
    obs2 = rand(MvNormal(zeros(3), 0.5Σ), 100)'

    trace1 = scatter3d(;x=obs1[:, 1], y=obs1[:, 2], z=obs1[:, 3],
                        mode="markers", opacity=0.8,
                        marker_size=12, marker_line_width=0.5,
                        marker_line_color="rgba(217, 217, 217, 0.14)")

    trace2 = scatter3d(;x=obs2[:, 1], y=obs2[:, 2], z=obs2[:, 3],
                        mode="markers", opacity=0.9,
                        marker=attr(color="rgb(127, 127, 127)",
                                    symbol="circle", line_width=1.0,
                                    line_color="rgb(204, 204, 204)"))

    layout = Layout(margin=attr(l=0, r=0, t=0, b=0))

    plot([trace1, trace2], layout)
end


function trisurf()
    facecolor = repeat([
    	"rgb(50, 200, 200)",
    	"rgb(100, 200, 255)",
    	"rgb(150, 200, 115)",
    	"rgb(200, 200, 50)",
    	"rgb(230, 200, 10)",
    	"rgb(255, 140, 0)"
    ], inner=[2])

    t = mesh3d(
        x=[0, 0, 1, 1, 0, 0, 1, 1],
        y=[0, 1, 1, 0, 0, 1, 1, 0],
        z=[0, 0, 0, 0, 1, 1, 1, 1],
        i=[7, 0, 0, 0, 4, 4, 2, 6, 4, 0, 3, 7],
        j=[3, 4, 1, 2, 5, 6, 5, 5, 0, 1, 2, 2],
        k=[0, 7, 2, 3, 6, 7, 1, 2, 5, 5, 7, 6],
        facecolor=facecolor)

    plot(t)
end

function meshcube()
    t = mesh3d(
        x=[0, 0, 1, 1, 0, 0, 1, 1],
        y=[0, 1, 1, 0, 0, 1, 1, 0],
        z=[0, 0, 0, 0, 1, 1, 1, 1],
        i=[7, 0, 0, 0, 4, 4, 6, 6, 4, 0, 3, 2],
        j=[3, 4, 1, 2, 5, 6, 5, 2, 0, 1, 6, 3],
        k=[0, 7, 2, 3, 6, 7, 1, 1, 5, 5, 7, 6],
        intensity=range(0, stop=1, length=8),
        colorscale=[
            [0, "rgb(255, 0, 255)"],
            [0.5, "rgb(0, 255, 0)"],
            [1, "rgb(0, 0, 255)"]
        ]
    )
    plot(t)
end
