function GenericTrace{T<:Number,T2<:Number}(x::AbstractArray{T},
                                            y::AbstractArray{T2};
                                            kind="scatter",
                                            kwargs...)
    GenericTrace(kind; x=x, y=y, kwargs... )
end

"""
$(SIGNATURES)
Build a plot of with one trace of type `kind`and set `x` to x and `y` to y. All
keyword arguments are passed directly as keyword arguments to the constructed
trace.

**NOTE**: If `y` is a matrix, one trace is constructed for each column of `y`

**NOTE**: If `x` and `y` are both matrices, they must have the same number of
columns (say `N`). Then `N` traces are constructed, where the `i`th column of
`x` is paired with the `i`th column of `y`.
"""
function plot{T<:Number,T2<:Number}(x::AbstractArray{T}, y::AbstractArray{T2},
                                    l::Layout=Layout();
                                    style::Style=DEFAULT_STYLE[1],
                                    kind="scatter", kwargs...)
    plot(GenericTrace(x, y; kind=kind, kwargs...), l, style=style)
end

function plot{T<:Number,T2<:Number}(x::AbstractVector{T}, y::AbstractMatrix{T2},
                                    l::Layout=Layout();
                                    style::Style=DEFAULT_STYLE[1],
                                    kwargs...)
    traces = GenericTrace[GenericTrace(x, view(y, :, i); kwargs...)
                          for i in 1:size(y,2)]
    plot(traces, l, style=style)
end

function plot{T<:Number,T2<:Number}(x::AbstractMatrix{T}, y::AbstractMatrix{T2},
                                    l::Layout=Layout();
                                    style::Style=DEFAULT_STYLE[1],
                                    kwargs...)
    if size(x, 2) == 1
        # use method above
        plot(view(x, :, 1), y, l; style=style, kwargs...)
    end

    size(x, 2) == size(y, 2) || error("x and y must have same number of cols")

    traces = GenericTrace[GenericTrace(view(x, :, i), view(y, :, i); kwargs...)
                          for i in 1:size(y,2)]
    plot(traces, l; style=style)
end

"""
$(SIGNATURES)
Build a scatter plot and set  `y` to y. All keyword arguments are passed directly
as keyword arguments to the constructed scatter.
"""
function plot{T<:Number}(y::AbstractArray{T}, l::Layout=Layout(); kwargs...)
    # call methods above to get many traces if y is >1d
    plot(1:size(y, 1), y, l; kwargs...)
end


"""
$(SIGNATURES)
Construct a plot of `f` from `x0` to `x1`, using the layout `l`. All
keyword arguments are applied to the constructed trace.
"""
function plot(f::Function, x0::Number, x1::Number, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1],
              kwargs...)
    x = linspace(x0, x1, 50)
    y = [f(_) for _ in x]
    plot(GenericTrace(x, y; name=Symbol(f), kwargs...), l, style=style)
end

"""
$(SIGNATURES)
For each function in `f` in `fs`, construct a scatter trace that plots `f` from
`x0` to `x1`, using the layout `l`. All keyword arguments are applied to all
constructed traces.
"""
function plot(fs::AbstractVector{Function}, x0::Number, x1::Number,
              l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1],
              kwargs...)
    x = linspace(x0, x1, 50)
    traces = GenericTrace[GenericTrace(x, map(f, x); name=Symbol(f), kwargs...)
                          for f in fs]
    plot(traces, l; style=style)
end
