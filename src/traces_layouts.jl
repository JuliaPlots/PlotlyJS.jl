GenericTrace(kind::AbstractString; kwargs...) = GenericTrace(kind, Dict(kwargs))

Layout(;kwargs...) = Layout(Dict(kwargs))

kind(gt::GenericTrace) = gt.kind
kind(l::Layout) = "layout"

for T in (GenericTrace, Layout)
    @eval Base.writemime(io::IO, ::MIME"text/plain", g::$T) =
        println(io, json(g, 2))

    # methods that allow you to do `obj["first.second.third"] = val`
    @eval Base.setindex!(gt::$T, val, key::ASCIIString) =
        setindex!(gt, val, map(symbol, split(key, "."))...)

    @eval Base.setindex!(gt::$T, val, keys::ASCIIString...) =
        setindex!(gt, val, map(symbol, keys)...)

    # Now for deep setindex. The deepest the json schema ever goes is 4 levels deep
    # so we will simply write out the setindex calls for 4 levels by hand. If the
    # schema gets deeper in the future we can @generate them with @nexpr
    @eval function Base.setindex!(gt::$T, val, key::Symbol)
        gt.fields[key] = val
    end

    @eval function Base.setindex!(gt::$T, val, k1::Symbol, k2::Symbol)
        d1 = get(gt.fields, k1, Dict())
        d1[k2] = val
        gt.fields[k1] = d1
        val
    end

    @eval function Base.setindex!(gt::$T, val, k1::Symbol, k2::Symbol, k3::Symbol)
        d1 = get(gt.fields, k1, Dict())
        d2 = get(d1, k2, Dict())
        d2[k3] = val
        d1[k2] = d2
        gt.fields[k1] = d1
        val
    end

    @eval function Base.setindex!(gt::$T, val, k1::Symbol, k2::Symbol,
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
    @eval Base.getindex(gt::$T, key::ASCIIString) =
        getindex(gt, map(symbol, split(key, "."))...)

    @eval Base.getindex(gt::$T, keys::ASCIIString...) =
        getindex(gt, map(symbol, keys)...)

    @eval function Base.getindex(gt::$T, key::Symbol)
        get(gt.fields, key, Dict())
    end

    @eval function Base.getindex(gt::$T, k1::Symbol, k2::Symbol)
        d1 = get(gt.fields, k1, Dict())
        get(d1, k2, Dict())
    end

    @eval function Base.getindex(gt::$T, k1::Symbol, k2::Symbol, k3::Symbol)
        d1 = get(gt.fields, k1, Dict())
        d2 = get(d1, k2, Dict())
        get(d2, k3, Dict())
    end

    @eval function Base.getindex(gt::$T, k1::Symbol, k2::Symbol,
                            k3::Symbol, k4::Symbol)
        d1 = get(gt.fields, k1, Dict())
        d2 = get(d1, k2, Dict())
        d3 = get(d2, k3, Dict())
        get(d3, k4, Dict())
    end
end
