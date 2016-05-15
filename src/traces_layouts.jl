abstract AbstractTrace
abstract AbstractLayout

type GenericTrace{T<:Associative{Symbol,Any}} <: AbstractTrace
    kind::String
    fields::T
end

function GenericTrace(kind::AbstractString, fields=Dict{Symbol,Any}(); kwargs...)
    # use setindex! methods below to handle `_` substitution
    gt = GenericTrace(kind, fields)
    map(x->setindex!(gt, x[2], x[1]), kwargs)
    gt
end

const _layout_defaults = Dict{Symbol,Any}(:margin => Dict(:l=>50, :r=>50, :t=>60, :b=>50))

type Layout{T<:Associative{Symbol,Any}} <: AbstractLayout
    fields::T

    function Layout(fields; kwargs...)
        l = new(merge(_layout_defaults, fields))
        map(x->setindex!(l, x[2], x[1]), kwargs)
        l
    end
end

Layout{T<:Associative{Symbol,Any}}(fields::T=Dict{Symbol,Any}(); kwargs...) =
    Layout{T}(fields; kwargs...)

kind(gt::GenericTrace) = gt.kind
kind(l::Layout) = "layout"

# -------------------------------------------- #
# Specific types of trace or layout attributes #
# -------------------------------------------- #
abstract AbstractPlotlyAttribute

type PlotlyAttribute{T<:Associative{Symbol,Any}} <: AbstractPlotlyAttribute
    fields::T
end

function attr(fields=Dict{Symbol,Any}(); kwargs...)
    # use setindex! methods below to handle `_` substitution
    s = PlotlyAttribute(fields)
    map(x->setindex!(s, x[2], x[1]), kwargs)
    s
end

abstract AbstractLayoutAttribute <: AbstractPlotlyAttribute
abstract AbstractShape <: AbstractLayoutAttribute

kind{T<:AbstractPlotlyAttribute}(::T) = string(T)

# TODO: maybe loosen some day
typealias _Scalar Union{Base.Dates.Date,Number,AbstractString}

# ------ #
# Shapes #
# ------ #

type Shape <: AbstractLayoutAttribute
    kind::String
    fields::Associative{Symbol}
end

function Shape(kind::AbstractString, fields=Dict{Symbol,Any}(); kwargs...)
    # use setindex! methods below to handle `_` substitution
    s = Shape(kind, fields)
    map(x->setindex!(s, x[2], x[1]), kwargs)
    s
end

# helper method needed below
_rep(x) = Base.cycle(x)
_rep(x::_Scalar) = Base.cycle([x])
_rep(x::Union{AbstractArray,Tuple}) = x

# line, circle, and rect share same x0, x1, y0, y1 args. Define methods for
# them here
for t in [:line, :circle, :rect]
    str_t = string(t)
    @eval $t(d::Associative=Dict{Symbol,Any}(), ;kwargs...) =
        Shape($str_t, d; kwargs...)
    eval(Expr(:export, t))

    @eval function $(t)(x0::_Scalar, x1::_Scalar, y0::_Scalar, y1::_Scalar,
                        fields::Associative=Dict{Symbol,Any}(); kwargs...)
        $(t)(fields; x0=x0, x1=x1, y0=y0, y1=y1, kwargs...)
    end


    @eval function $(t)(x0::Union{AbstractVector,_Scalar},
                        x1::Union{AbstractVector,_Scalar},
                        y0::Union{AbstractVector,_Scalar},
                        y1::Union{AbstractVector,_Scalar},
                        fields::Associative=Dict{Symbol,Any}(); kwargs...)
        f(_x0, _x1, _y0, _y1) = $(t)(_x0, _x1, _y0, _y1, copy(fields); kwargs...)
        map(f, _rep(x0), _rep(x1), _rep(y0), _rep(y1))
    end
end

@doc "Draw a line through the points (x0, y0) and (x1, y2)" line

@doc """
Draw a circle from ((`x0`+`x1`)/2, (`y0`+`y1`)/2)) with radius
 (|(`x0`+`x1`)/2 - `x0`|, |(`y0`+`y1`)/2 -`y0`)|) """ circle

@doc """
Draw a rectangle linking (`x0`,`y0`), (`x1`,`y0`),
(`x1`,`y1`), (`x0`,`y1`), (`x0`,`y0`)""" rect


"Draw an arbitrary svg path"
path(p::AbstractString; kwargs...) = Shape("path"; path=p, kwargs...)

export path

# derived shapes

vline(x, ymin, ymax, fields::Associative=Dict{Symbol,Any}(); kwargs...) =
    line(x, x, ymin, ymax, fields; kwargs...)

"""
`vline(x, fields::Associative=Dict{Symbol,Any}(); kwargs...)`

Draw vertical lines at each point in `x` that span the height of the plot
"""
vline(x, fields::Associative=Dict{Symbol,Any}(); kwargs...) =
    vline(x, 0, 1, fields; xref="x", yref="paper")

hline(y, xmin, xmax, fields::Associative=Dict{Symbol,Any}(); kwargs...) =
    line(xmin, xmax, y, y, fields; kwargs...)

"""
`hline(y, fields::Associative=Dict{Symbol,Any}(); kwargs...)`

Draw horizontal lines at each point in `y` that span the width of the plot
"""
hline(y, fields::Associative=Dict{Symbol,Any}(); kwargs...) =
    hline(y, 0, 1, fields; xref="paper", yref="y")

# ---------------------------------------- #
# Implementation of getindex and setindex! #
# ---------------------------------------- #

typealias HasFields Union{GenericTrace,Layout,Shape,PlotlyAttribute}

Base.merge(hf::HasFields, d::Dict) = merge(hf.fields, d)
Base.merge{T<:HasFields}(hf1::T, hf2::T) = merge(hf1.fields, hf2.fields)
Base.get(hf::HasFields, k::Symbol, default) = get(hf.fields, k, default)

# methods that allow you to do `obj["first.second.third"] = val`
Base.setindex!(gt::HasFields, val, key::String) =
    setindex!(gt, val, map(symbol, split(key, ['.', '_']))...)

Base.setindex!(gt::HasFields, val, keys::String...) =
    setindex!(gt, val, map(symbol, keys)...)

# Now for deep setindex. The deepest the json schema ever goes is 4 levels deep
# so we will simply write out the setindex calls for 4 levels by hand. If the
# schema gets deeper in the future we can @generate them with @nexpr
function Base.setindex!(gt::HasFields, val, key::Symbol)
    # check if single key has underscores, if so split at str and call above
    if contains(string(key), "_")
        return setindex!(gt, val, string(key))
    end
    gt.fields[key] = val
end

function Base.setindex!(gt::HasFields, val, k1::Symbol, k2::Symbol)
    d1 = get(gt.fields, k1, Dict())
    d1[k2] = val
    gt.fields[k1] = d1
    val
end

function Base.setindex!(gt::HasFields, val, k1::Symbol, k2::Symbol, k3::Symbol)
    d1 = get(gt.fields, k1, Dict())
    d2 = get(d1, k2, Dict())
    d2[k3] = val
    d1[k2] = d2
    gt.fields[k1] = d1
    val
end

function Base.setindex!(gt::HasFields, val, k1::Symbol, k2::Symbol,
                        k3::Symbol, k4::Symbol)
    d1 = get(gt.fields, k1, Dict())
    d2 = get(d1, k2, Dict())
    d3 = get(d2, k3, Dict())
    d3[k4] = val
    d2[k3] = d3
    d1[k2] = d2
    gt.fields[k1] = d1
    val
end

# now on to the simpler getindex methods. They will try to get the desired
# key, but if it doesn't exist an empty dict is returned
Base.getindex(gt::HasFields, key::String) =
    getindex(gt, map(symbol, split(key, ['.', '_']))...)

Base.getindex(gt::HasFields, keys::String...) =
    getindex(gt, map(symbol, keys)...)

function Base.getindex(gt::HasFields, key::Symbol)
    if contains(string(key), "_")
        return getindex(gt, string(key))
    end
    get(gt.fields, key, Dict())
end

function Base.getindex(gt::HasFields, k1::Symbol, k2::Symbol)
    d1 = get(gt.fields, k1, Dict())
    get(d1, k2, Dict())
end

function Base.getindex(gt::HasFields, k1::Symbol, k2::Symbol, k3::Symbol)
    d1 = get(gt.fields, k1, Dict())
    d2 = get(d1, k2, Dict())
    get(d2, k3, Dict())
end

function Base.getindex(gt::HasFields, k1::Symbol, k2::Symbol,
                       k3::Symbol, k4::Symbol)
    d1 = get(gt.fields, k1, Dict())
    d2 = get(d1, k2, Dict())
    d3 = get(d2, k3, Dict())
    get(d3, k4, Dict())
end

# Function used to have meaningful display of traces and layouts
function _describe(x::HasFields)
    fields = sort(map(string, keys(x.fields)))
    n_fields = length(fields)
    if n_fields == 0
        return "$(kind(x)) with no fields"
    elseif n_fields == 1
        return "$(kind(x)) with field $(fields[1])"
    elseif n_fields == 2
        return "$(kind(x)) with fields $(fields[1]) and $(fields[2])"
    else
        return "$(kind(x)) with fields $(join(fields, ", ", ", and "))"
    end
end

Base.writemime(io::IO, ::MIME"text/plain", g::HasFields) =
    println(io, _describe(g))
