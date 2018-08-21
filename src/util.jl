PlotlyBase.trace_map(p::SyncPlot, axis) = trace_map(p.plot, axis)
JSON.lower(sp::SyncPlot) = JSON.lower(sp.plot)

PlotlyBase._is3d(p::SyncPlot) = _is3d(p.plot)

# subplot methods on syncplot
Base.hcat(sps::TP...) where {TP<:SyncPlot} = TP(hcat([sp.plot for sp in sps]...))
Base.vcat(sps::TP...) where {TP<:SyncPlot} = TP(vcat([sp.plot for sp in sps]...))
Base.vect(sps::TP...) where {TP<:SyncPlot} = vcat(sps...)
Base.hvcat(rows::Tuple{Vararg{Int}}, sps::TP...) where {TP<:SyncPlot} =
    TP(hvcat(rows, [sp.plot for sp in sps]...))


function PlotlyBase.add_recession_bands!(p::SyncPlot; kwargs...)
    new_shapes = add_recession_bands!(p.plot; kwargs...)
    relayout!(p, shapes=new_shapes)
    new_shapes
end
