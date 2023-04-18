module JSON3Ext

isdefined(Base, :get_extension) ? (using PlotlyBase) : (using ..PlotlyBase)
isdefined(Base, :get_extension) ? (using JSON) : (using ..JSON)
isdefined(Base, :get_extension) ? (using JSON3) : (using ..JSON3)

JSON3.write(io::IO, p::PlotlyBase.SyncPlot) = JSON.print(io, p.plot)
JSON3.write(p::PlotlyBase.SyncPlot) = JSON.json(p.plot)

end