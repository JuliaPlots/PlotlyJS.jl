module DataFramesExt

using PlotlyJS
isdefined(Base, :get_extension) ? (using DataFrames) : (using ..DataFrames)
isdefined(Base, :get_extension) ? (using CSV) : (using ..CSV)


PlotlyJS.dataset(::Type{DataFrames.DataFrame}, name::String) = DataFrames.DataFrame(PlotlyJS.dataset(CSV.File, name))

end