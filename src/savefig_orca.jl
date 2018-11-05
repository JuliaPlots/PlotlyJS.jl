PlotlyBase.savefig(p::SyncPlot, a...; k...) = savefig(p.plot, a...; k...)
PlotlyBase.savefig(io::IO, p::SyncPlot, a...; k...) = savefig(io, p.plot, a...; k...)

# TODO: overload mime methods once they are implemented via ORCA server
