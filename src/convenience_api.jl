function plot{T<:Number,T2<:Number}(x::AbstractArray{T}, y::AbstractArray{T2},
                                    l::Layout=Layout(); kwargs...)
    plot(scatter(x=x, y=y; kwargs...), l)
end

function plot{T<:Number}(y::AbstractArray{T}, l::Layout=Layout(); kwargs...)
    plot(scatter(y=y; kwargs...), l)
end

function plot(l::Layout=Layout(); kwargs...)
    kind_ix = findfirst(x->x[1] == :kind, kwargs)
    kind = kind_ix == 0 ? "scatter" : kwargs[kind_ix][2]
    plot(GenericTrace(kind; kwargs...), l)
end

plot(kind::Symbol, l::Layout=Layout(); kwargs...) =
    plot(GenericTrace(kind; kwargs...), l)

function plot(f::Function, x0::Number, x1::Number, l::Layout=Layout();
              kwargs...)
    x = linspace(x0, x1, 50)
    y = [f(_) for _ in x]
    plot(scatter(x=x, y=y; kwargs...), l)
end

function plot(fs::AbstractVector{Function}, x0::Number, x1::Number,
              l::Layout=Layout(); kwargs...)
    x = linspace(x0, x1, 50)
    traces = GenericTrace[scatter(x=x, y=map(f, x); kwargs...) for f in fs]
    plot(traces, l)
end

function plot{T<:Number,T2<:Number}(x::AbstractVector{T}, y::AbstractMatrix{T2},
                                    l::Layout=Layout(); kwargs...)
    traces = GenericTrace[scatter(x=x, y=slice(y, :, i); kwargs...)
                          for i in 1:size(y,2)]
    plot(traces, l)
end
