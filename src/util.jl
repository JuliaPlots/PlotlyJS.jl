PlotlyBase.trace_map(p::SyncPlot, axis) = trace_map(p.plot, axis)
JSON.lower(sp::SyncPlot) = JSON.lower(sp.plot)

PlotlyBase._is3d(p::SyncPlot) = _is3d(p.plot)

# subplot methods on syncplot
Base.hcat{TP<:SyncPlot}(sps::TP...) = TP(hcat([sp.plot for sp in sps]...))
Base.vcat{TP<:SyncPlot}(sps::TP...) = TP(vcat([sp.plot for sp in sps]...))
Base.vect{TP<:SyncPlot}(sps::TP...) = vcat(sps...)
Base.hvcat{TP<:SyncPlot}(rows::Tuple{Vararg{Int}}, sps::TP...) =
    TP(hvcat(rows, [sp.plot for sp in sps]...))


function PlotlyBase.add_recession_bands!(p::SyncPlot; kwargs...)
    new_shapes = add_recession_bands!(p.plot; kwargs...)
    relayout!(p, shapes=new_shapes)
    new_shapes
end
