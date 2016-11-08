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

type StemTrace{T} <: AbstractTrace
    trace::GenericTrace{T}
    stem_color
    stem_thickness
end

Base.setindex!(st::StemTrace, args...; kwargs...) = setindex!(st.trace, args...; kwargs...)
Base.getindex(st::StemTrace, args...; kwargs...) = getindex(st.trace, args...; kwargs...)
Base.get(st::StemTrace, args...; kwargs...) = get(st.trace, args...; kwargs...)
JSON.lower(st::StemTrace) = JSON.lower(st.trace)
kind(trace::StemTrace) = :scatter

"""
$(SIGNATURES)
Creates a "stem" or "lollipop" trace. It is implemented using plotly.js's
`scatter` type, using the error bars to draw the stem.

## Keyword Arguments:
* All properties accepted by `scatter` except `mode` and `error_y`, which are used to draw
    the stems
* stem_color - sets the color of the stems
* stem_thickness - sets the thickness of the stems
"""
function stem(fields::Associative=Dict{Symbol, Any}();
              stem_color="grey", stem_thickness=1, marker_size=10, kwargs...)
    _check_stemargs(fields, kwargs)
    st = StemTrace(
        scatter(
            fields;
            marker_size=marker_size,
            mode="markers",
            hoverinfo="text",
            kwargs...),
        stem_color,
        stem_thickness)

    _update_stemfields(st)

    st
end

function restyle!(st::StemTrace, i::Int=1, update::Associative=Dict();
                  stem_thickness=st.stem_thickness,
                  stem_color=st.stem_color,
                  kwargs...)
    _check_stemargs(update, kwargs)
    _apply_restyle_setfield!(st, :stem_thickness, stem_thickness, i)
    _apply_restyle_setfield!(st, :stem_color, stem_color, i)
    updatedict = Dict()
    for coll in (update, kwargs)
        for (k, v) in coll
            _apply_restyle_setindex!(st.trace, k, v, i)
            # maintain `outer.inner` to keep with plotly.js update semantics.
            # nesting the inner value would cause plotly to replace the whole
            # outer dict instead of just editing the inner value
            if !(Symbol(k) in _UNDERSCORE_ATTRS)
                k = replace(string(k), "_", ".")
            end
            updatedict[k] = v
        end
    end

    # _update_stemfields updates the trace fields and returns a dict of the
    # changed fields
    merge(_update_stemfields(st), updatedict)
end

# check that the user isn't trying to set any of the properties that we're
# using to make the stem plot
# update is an Associative. kwargs is a list of tuples, as you'd get from
# splatting keyword arguments
function _check_stemargs(update::Associative, kwargs)
    for key in keys(update)
        if key in (:error_y, :mode)
            error("`$key` property not allowed in stem plots")
        end
    end
    for (key, _) in kwargs
        if key in (:error_y, :mode)
            error("`$key` property not allowed in stem plots")
        end
    end
end

# take the given stem plot and set the extra properties we need
function _update_stemfields(st::StemTrace)
    y = get(st, :y, nothing)
    if y != nothing
        st[:text] = y
        line_up = -min(y, 0)
        line_down = max(y, 0)
        st[:error_y] = Dict(
            :type => "data",
            :symmetric => false,
            :array => line_up,
            :arrayminus => line_down,
            :visible => true,
            :color => st.stem_color,
            :width => 0,
            :thickness => st.stem_thickness)

        # return the new fields that got modified, y needs to be wrapped in an
        # extra array for restyle to work correctly
        Dict(:text => [y], :error_y => st[:error_y])
    else
        nothing
    end
end
