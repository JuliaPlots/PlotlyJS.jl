function GenericTrace(x::AbstractArray, y::AbstractArray;
                      kind="scatter", kwargs...)
    GenericTrace(kind; x=x, y=y, kwargs... )
end

"""
$(SIGNATURES)
Build a trace of kind `kind`, using the columns of `df` where possible. In
particular for all keyword arguments, if the value of the keyword argument is a
Symbol and matches one of the column names of `df`, replace the value of the
keyword argument with the column of `df`
"""
function GenericTrace(df::AbstractDataFrame; kind="scatter", kwargs...)
    d = Dict{Symbol,Any}(kwargs)

    for (k, v) in d
        if isa(v, Symbol) && haskey(df, v)
            d[k] = df[v]
        end
    end
    GenericTrace(kind; d...)
end

"""
$(SIGNATURES)
Pass the provided values of `x` and `y` as keyword arguments for constructing
the trace from `df`. See other method for more information
"""
function GenericTrace(df::AbstractDataFrame, x::Symbol, y::Symbol; kwargs...)
    GenericTrace(df; x=x, y=y, kwargs...)
end

"""
$(SIGNATURES)
Pass the provided value `y` as keyword argument for constructing the trace from
`df`. See other method for more information
"""
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
function Plot{T<:_Scalar}(x::AbstractVector{T}, y::AbstractVector, l::Layout=Layout();
              kind="scatter", style::Style=DEFAULT_STYLE[1], kwargs...)
    Plot(GenericTrace(x, y; kind=kind, kwargs...), l, style=style)
end

function Plot{T<:_Scalar}(x::AbstractVector{T}, y::AbstractMatrix, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1], kwargs...)
    traces = GenericTrace[GenericTrace(x, view(y, :, i); kwargs...)
                          for i in 1:size(y, 2)]
    Plot(traces, l, style=style)
end

function Plot{T<:AbstractVector}(x::AbstractVector{T}, y::AbstractMatrix, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1], kwargs...)
    size(x, 1) == size(y, 2) || error("x and y must have same number of cols")

    traces = GenericTrace[GenericTrace(x[i], view(y, :, i); kwargs...)
                          for i in 1:size(y,2)]
    Plot(traces, l; style=style)
end

function Plot(x::AbstractMatrix, y::AbstractMatrix, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1], kwargs...)
    if size(x, 2) == 1
        # use method above
        Plot(view(x, :, 1), y, l; style=style, kwargs...)
    end

    size(x, 2) == size(y, 2) || error("x and y must have same number of cols")

    traces = GenericTrace[GenericTrace(view(x, :, i), view(y, :, i); kwargs...)
                          for i in 1:size(y,2)]
    Plot(traces, l; style=style)
end

"""
$(SIGNATURES)
Build a scatter plot and set  `y` to y. All keyword arguments are passed directly
as keyword arguments to the constructed scatter.
"""
# AbstractArray{T,N}
function Plot{T<:_Scalar}(y::AbstractArray{T}, l::Layout=Layout(); kwargs...)
    # call methods above to get many traces if y is >1d
    Plot(1:size(y, 1), y, l; kwargs...)
end

"""
$(SIGNATURES)
Construct a plot of `f` from `x0` to `x1`, using the layout `l`. All
keyword arguments are applied to the constructed trace.
"""
function Plot(f::Function, x0::Number, x1::Number, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1],
              kwargs...)
    x = linspace(x0, x1, 50)
    y = [f(_) for _ in x]
    Plot(GenericTrace(x, y; name=Symbol(f), kwargs...), l, style=style)
end

"""
$(SIGNATURES)
For each function in `f` in `fs`, construct a scatter trace that plots `f` from
`x0` to `x1`, using the layout `l`. All keyword arguments are applied to all
constructed traces.
"""
function Plot(fs::AbstractVector{Function}, x0::Number, x1::Number,
              l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1],
              kwargs...)
    x = linspace(x0, x1, 50)
    traces = GenericTrace[GenericTrace(x, map(f, x); name=Symbol(f), kwargs...)
                          for f in fs]
    Plot(traces, l; style=style)
end

"""
$(SIGNATURES)
Construct a plot using the columns of `df` if possible. For each keyword
argument, if the value of the argument is a Symbol and the `df` has a column
whose name matches the value, replace the value with the column of the `df`.

If `group` is passed and is a Symbol that is one of the column names of `df`,
then call `by(df, group)` and construct one trace per SubDataFrame, passing
all other keyword arguments. This means all keyword arguments are passed
applied to all traces
"""
function Plot(df::AbstractDataFrame, l::Layout=Layout(); group=nothing,
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
            return Plot(traces, l, style=style)
        else
            warn("Unknown group $(group), skipping")
        end
    end
    Plot(GenericTrace(df; kwargs...), l, style=style)
end

"""
$(SIGNATURES)
Construct a plot from `df`, passing the provided values of x and y as keyword
arguments. See docstring for other method for more information.
"""
function Plot(d::AbstractDataFrame, x::Symbol, y::Symbol, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1], kwargs...)
    Plot(d, l; x=x, y=y, style=style, kwargs...)
end

"""
$(SIGNATURES)
Construct a plot from `df`, passing the provided value y as a keyword argument.
See docstring for other method for more information.
"""
function Plot(d::AbstractDataFrame, y::Symbol, l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1], kwargs...)
    Plot(d, l; y=y, style=style, kwargs...)
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
