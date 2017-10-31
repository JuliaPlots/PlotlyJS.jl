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


for t in _TRACE_TYPES
    str_t = string(t)
    @eval $t(df::AbstractDataFrame; kwargs...) = GenericTrace(df; kind=$(str_t), kwargs...)
end
