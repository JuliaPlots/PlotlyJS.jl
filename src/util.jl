PlotlyBase.trace_map(p::SyncPlot, axis) = trace_map(p.plot, axis)
JSON.lower(sp::SyncPlot) = sp.plot

PlotlyBase._is3d(p::SyncPlot) = _is3d(p.plot)

# subplot methods on syncplot
Base.hcat(sps::SyncPlot...) = SyncPlot(hcat(Plot[sp.plot for sp in sps]...))
Base.vcat(sps::SyncPlot...) = SyncPlot(vcat(Plot[sp.plot for sp in sps]...))
Base.hvcat(rows::Tuple{Vararg{Int}}, sps::SyncPlot...) =
    SyncPlot(hvcat(rows, Plot[sp.plot for sp in sps]...))

function PlotlyBase.add_recession_bands!(p::SyncPlot; kwargs...)
    new_shapes = add_recession_bands!(p.plot; kwargs...)
    relayout!(p, shapes=new_shapes)
    new_shapes
end

function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end
