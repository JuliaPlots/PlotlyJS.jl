module JSON3Ext

using PlotlyJS
isdefined(Base, :get_extension) ? (using JSON3) : (using ..JSON3)

JSON3.write(io::IO, p::PlotlyJS.SyncPlot) = JSON3.write(io, p.plot)
JSON3.write(p::PlotlyJS.SyncPlot) = JSON3.write(p.plot)

end
