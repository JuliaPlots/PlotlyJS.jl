# JSON.jl compatibility

# JSON.jl < 1 writes non-finite floats (e.g. `NaN` used for gaps in trace data)
# as `null`, whereas JSON.jl v1 throws on them by default. Keep the old behavior.
@static if isdefined(JSON, :JSONStyle) # JSON.jl >= 1
    struct PlotlyJSSerialization <: JSON.JSONStyle end
    JSON.lower(::PlotlyJSSerialization, x::AbstractFloat) = isfinite(x) ? x : nothing

    jsonstring(x) = JSON.json(x; style = PlotlyJSSerialization())
else
    jsonstring(x) = JSON.json(x)
end
