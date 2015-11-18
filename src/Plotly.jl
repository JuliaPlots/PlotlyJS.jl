module Plotly

using JSON
using Blink
using Colors

abstract AbstractPlotlyElement
abstract PlotlyEnumerated <: AbstractPlotlyElement
abstract PlotlyFlagList <: AbstractPlotlyElement
abstract AbstractTrace <: AbstractPlotlyElement
abstract AbstractLayout <: AbstractPlotlyElement

immutable TempLayout <: AbstractLayout end

type Plot
    data::Vector{AbstractTrace}
    layout::AbstractLayout
    divid::Base.Random.UUID
    window::Nullable{Window}
end

Plot() = Plot([], TempLayout(), Base.Random.uuid4(), Nullable{Window}())

include("display.jl")
include("api.jl")
include("Errors.jl")
include("TraceTypes.jl")
include("Scatter.jl")

# show(Plot())
end # module
