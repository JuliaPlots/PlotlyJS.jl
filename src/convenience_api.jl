function GenericTrace(x::AbstractArray, y::AbstractArray;
                      kind="scatter", kwargs...)
    GenericTrace(kind; x=x, y=y, kwargs... )
end

function GenericTrace(df::AbstractDataFrame; kind="scatter", kwargs...)
    d = Dict{Symbol,Any}(kwargs)

    for (k, v) in d
        if isa(v, Symbol) && haskey(df, v)
            d[k] = df[v]
        end
    end
    GenericTrace(kind; d...)
end

function GenericTrace(df::AbstractDataFrame, x::Symbol, y::Symbol; kwargs...)
    GenericTrace(df; x=x, y=y, kwargs...)
end

function GenericTrace(df::AbstractDataFrame, y::Symbol; kwargs...)
    GenericTrace(df; y=y, kwargs...)
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
function plot(x::AbstractArray, y::AbstractArray, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1], kwargs...)
    plot(GenericTrace(x, y; kind=kind, kwargs...), l, style=style)
end

function plot(x::AbstractVector, y::AbstractMatrix, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1], kwargs...)
    traces = GenericTrace[GenericTrace(x, view(y, :, i); kwargs...)
                          for i in 1:size(y,2)]
    plot(traces, l, style=style)
end

function plot(x::AbstractMatrix, y::AbstractMatrix, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1], kwargs...)
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
function plot(y::AbstractArray, l::Layout=Layout(); kwargs...)
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

function plot(df::AbstractDataFrame, l::Layout=Layout(); group=nothing,
              style::Style=DEFAULT_STYLE[1], kwargs...)
    if group != nothing
        # the user passed a group argument, we actually have to do something...
        if isa(group, Symbol) && haskey(df, group)
            _traces = by(df, group) do dfg
                GenericTrace(dfg; name=dfg[1, group], kwargs...)
            end
            traces = GenericTrace[t for t in _traces[:x1]]
            # for some reason I need to bypass calling `plot` due to a type
            # inference error??
            return SyncPlot(Plot(traces, l, style=style))
        else
            warn("Unknown group $(group), skipping")
        end
    end
    plot(GenericTrace(df; kwargs...), l, style=style)
end

function plot(d::AbstractDataFrame, x::Symbol, y::Symbol, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1], kwargs...)
    plot(d, l; x=x, y=y, style=style, kwargs...)
end

function plot(d::AbstractDataFrame, y::Symbol, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1], kwargs...)
    plot(d, l; y=y, style=style, kwargs...)
end

"""
$(SIGNATURES)
Creates a "stem" or "lollipop" trace. It is implemented using plotly.js's
`scatter` type, using the error bars to draw the stem.

## Keyword Arguments:
* All properties accepted by `scatter` except `error_y`, which is used to draw
    the stems
* stem_color - sets the color of the stems
* stem_thickness - sets the thickness of the stems
"""
function stem(;y=nothing, stem_color="grey", stem_thickness=1, kwargs...)
    line_up = -min(y, 0)
    line_down = max(y, 0)
    trace = scatter(; y=y, text=y, marker_size=10, mode="markers", hoverinfo="text", kwargs...)
    trace.fields[:error_y] = Dict(
        :type => "data",
        :symmetric => false,
        :array => line_up,
        :arrayminus => line_down,
        :visible => true,
        :color => stem_color,
        :width => 0,
        :thickness => stem_thickness)
    trace
end
