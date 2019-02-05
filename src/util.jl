PlotlyBase.trace_map(p::SyncPlot, axis) = trace_map(p.plot, axis)
JSON.lower(sp::SyncPlot) = sp.plot

PlotlyBase._is3d(p::SyncPlot) = _is3d(p.plot)

# subplot methods on syncplot
Base.hcat(sps::SyncPlot...) = SyncPlot(hcat([sp.plot for sp in sps]...))
Base.vcat(sps::SyncPlot...) = SyncPlot(vcat([sp.plot for sp in sps]...))
Base.vect(sps::SyncPlot...) = vcat(sps...)
Base.hvcat(rows::Tuple{Vararg{Int}}, sps::SyncPlot...) =
    SyncPlot(hvcat(rows, [sp.plot for sp in sps]...))

function PlotlyBase.add_recession_bands!(p::SyncPlot; kwargs...)
    new_shapes = add_recession_bands!(p.plot; kwargs...)
    relayout!(p, shapes=new_shapes)
    new_shapes
end
