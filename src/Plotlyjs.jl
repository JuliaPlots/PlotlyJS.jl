module Plotlyjs

using JSON
using Blink
using Colors

abstract AbstractPlotlyElement

# ---------- #
# attributes #
# ---------- #
abstract AbstractAttributeRole
abstract AbstractValRole <: AbstractAttributeRole
immutable DataRole <: AbstractValRole end
immutable InfoRole <: AbstractValRole end
immutable StyleRole <: AbstractValRole end
immutable ObjectRole <: AbstractAttributeRole end

# abstract AbstractAttribute{Role,ValType} <: AbstractPlotlyElement
# NOTE: make ValType Void for ObjectRole
abstract AbstractAttribute{Role} <: AbstractPlotlyElement

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

Plot{T<:AbstractTrace}(data::Vector{T}) =
    Plot(data, TempLayout(), Base.Random.uuid4(), Nullable{Window}())

Plot(data::AbstractTrace) = Plot([data])

include("display.jl")
include("api.jl")
include("Errors.jl")
include("TraceTypes.jl")
include("Scatter.jl")

# -------------------------------- #
# Custom JSON output for our types #
# -------------------------------- #
function JSON._print(io::IO, state::JSON.State, a::AbstractTrace)
    JSON.start_object(io, state, true)
    range = fieldnames(a)
    if length(range) > 0
        Base.print(io, JSON.prefix(state), "\"", :type, "\"", JSON.colon(state))
        JSON._print(io, state, plottype(a))

        for name in range
            Base.print(io, ",")
            JSON.printsp(io, state)
            Base.print(io, "\"", name, "\"", colon(state))
            JSON._print(io, state, a.(name))
        end
    end
    JSON.end_object(io, state, true)
end

function JSON._print(io::IO, state::JSON.State, a::AbstractAttribute{ObjectRole})
    JSON.start_object(io, state, true)
    range = fieldnames(a)
    if length(range) > 0
        Base.print(io, JSON.prefix(state), "\"", :type, "\"", JSON.colon(state))
        JSON._print(io, state, plottype(a))

        for name in range
            Base.print(io, ",")
            JSON.printsp(io, state)
            Base.print(io, "\"", name, "\"", colon(state))
            JSON._print(io, state, a.(name))
        end
    end
    JSON.end_object(io, state, true)
end

JSON._print{T<:AbstractValRole}(io::IO, state::JSON.State, a::AbstractAttribute{T}) =
    JSON._print(io, state, a.value)

JSON._print(io::IO, state::JSON.State, a::Colors.Colorant) =
    JSON._print(io, state, string("#", hex(a)))

# show(Plot())
end # module
