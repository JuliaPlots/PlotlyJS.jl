function GenericTrace(kind::AbstractString, fields=Dict{Symbol,Any}(); kwargs...)
    # use setindex! methods below to handle `_` substitution
    gt = GenericTrace(kind, fields)
    map(x->setindex!(gt, x[2], x[1]), kwargs)
    gt
end

function Layout(fields=Dict{Symbol,Any}(); kwargs...)
    l = Layout(fields)
    map(x->setindex!(l, x[2], x[1]), kwargs)
    l
end

kind(gt::GenericTrace) = gt.kind
kind(l::Layout) = "layout"

typealias HasFields Union{GenericTrace, Layout}

Base.writemime(io::IO, ::MIME"text/plain", g::HasFields) =
    println(io, json(g, 2))

# methods that allow you to do `obj["first.second.third"] = val`
Base.setindex!(gt::HasFields, val, key::ASCIIString) =
    setindex!(gt, val, map(symbol, split(key, "."))...)

Base.setindex!(gt::HasFields, val, keys::ASCIIString...) =
    setindex!(gt, val, map(symbol, keys)...)

# Now for deep setindex. The deepest the json schema ever goes is 4 levels deep
# so we will simply write out the setindex calls for 4 levels by hand. If the
# schema gets deeper in the future we can @generate them with @nexpr
function Base.setindex!(gt::HasFields, val, key::Symbol)
    # check if single key has underscores, if so split at str and call above
    if contains(string(key), "_")
        return setindex!(gt, val, replace(string(key), "_", "."))
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
Base.getindex(gt::HasFields, key::ASCIIString) =
    getindex(gt, map(symbol, split(key, "."))...)

Base.getindex(gt::HasFields, keys::ASCIIString...) =
    getindex(gt, map(symbol, keys)...)

function Base.getindex(gt::HasFields, key::Symbol)
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
