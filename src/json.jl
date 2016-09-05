# -------------------------------- #
# Custom JSON output for our types #
# -------------------------------- #
JSON.lower(a::HasFields) = a.fields

function JSON.lower(p::Plot)
    if p.style.name == :default
        return Dict(:data => p.data, :layout => p.layout)
    end

    # apply color cycle
    if !isempty(p.style.color_cycle)
        n = length(p.style.color_cycle)
        ix = 1
        for t in p.data
            haskey(t["marker"], :color) && continue
            t["marker.color"] = p.style.color_cycle[ix]
            ix = ix == n ? 1 : ix + 1
        end
    end

    # apply layout attrs
    if !isempty(p.style.layout_attrs)
        p.layout = merge(p.style.layout_attrs, p.layout)
    end

    # apply global trace attrs
    if !isempty(p.style.global_trace_attrs)
        for (k, v) in p.style.global_trace_attrs.fields
            for t in p.data
                get(t, k, nothing) != nothing && continue
                t[k] = v
            end
        end
    end

    # apply trace specific attrs
    if !isempty(p.style.trace_attrs)
        for t in p.data
            t_type = Symbol(get(t, :type, :scatter))
            for (k, v) in get(p.style.trace_attrs, t_type, Dict())
                get(t, k, nothing) != nothing && continue
                t[k] = v
            end
        end
    end
    Dict(:data => p.data, :layout => p.layout)
end

JSON.lower(sp::SyncPlot) = JSON.lower(sp.plot)
JSON.lower(a::Colors.Colorant) = string("#", hex(a))

# Let string interpolation stringify to JSON format
Base.print(io::IO, a::Union{Shape,GenericTrace,PlotlyAttribute,Layout,Plot}) = print(io, JSON.json(a))
Base.print{T<:GenericTrace}(io::IO, a::Vector{T}) = print(io, JSON.json(a))

# methods to re-construct a plot from JSON
_symbol_dict(x) = x
@compat _symbol_dict(d::Associative) =
    Dict{Symbol,Any}(Symbol(k) => _symbol_dict(v) for (k, v) in d)

GenericTrace(d::Associative{Symbol}) = GenericTrace(pop!(d, :type, "scatter"), d)
GenericTrace{T<:AbstractString}(d::Associative{T}) = GenericTrace(_symbol_dict(d))
Layout{T<:AbstractString}(d::Associative{T}) = Layout(_symbol_dict(d))

function JSON.parse(::Type{Plot}, str::AbstractString)
    d = JSON.parse(str)
    data = GenericTrace[GenericTrace(tr) for tr in d["data"]]
    layout = Layout(d["layout"])
    Plot(data, layout)
end

JSON.parsefile(::Type{Plot}, fn) =
    open(fn, "r") do f; JSON.parse(Plot, readall(f)) end
