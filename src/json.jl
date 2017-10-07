# -------------------------------- #
# Custom JSON output for our types #
# -------------------------------- #
JSON.lower(a::HasFields) = a.fields

function _apply_style_axis!(p::Plot, ax, force::Bool=false)
    if haskey(p.style.layout.fields, Symbol(ax, "axis")) || force
        ax_names = Iterators.filter(
            _x-> startswith(string(_x), "$(ax)axis"),
            keys(p.layout.fields)
        )

        for ax_name in ax_names
            cur = p.layout.fields[ax_name]
            cur = merge(p.style.layout[Symbol(ax, "axis")], cur)
            p.layout.fields[ax_name] = cur
        end

        if isempty(ax_names)
            nm = Symbol(ax, "axis")
            p.layout.fields[nm] = deepcopy(p.style.layout[nm])
        end
    end

end

_maybe_set_attr!(hf::HasFields, k::Symbol, v::Any) =
    get(hf, k, nothing) == nothing && setindex!(hf, v, k)

# special case for associative to get nested application
function _maybe_set_attr!(hf::HasFields, k1::Symbol, v::Associative)
    for (k2, v2) in v
        _maybe_set_attr!(hf, Symbol(k1, "_", k2), v2)
    end
end

function JSON.lower(p::Plot)
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

    _is3d = any(_x -> contains(string(_x[:type]), "3d"), p.data)

    # apply layout attrs
    if !isempty(p.style.layout)
        # force xaxis and yaxis if plot is 2d
        _apply_style_axis!(p, "x", !_is3d)
        _apply_style_axis!(p, "y", !_is3d)
        _apply_style_axis!(p, "z")

        # extract this so we can pop! off xaxis and yaxis so they aren't
        # applied again
        la = deepcopy(p.style.layout)
        pop!(la.fields, :xaxis, nothing)
        pop!(la.fields, :yaxis, nothing)
        pop!(la.fields, :zaxis, nothing)
        p.layout = merge(la, p.layout)
    end

    # apply global trace attrs
    if !isempty(p.style.global_trace)
        for (k, v) in p.style.global_trace.fields
            for t in p.data
                _maybe_set_attr!(t, k, v)
            end
        end
    end

    # apply trace specific attrs
    if !isempty(p.style.trace)
        for t in p.data
            t_type = Symbol(get(t, :type, :scatter))
            for (k, v) in get(p.style.trace, t_type, Dict())
                _maybe_set_attr!(t, k, v)
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
    open(fn, "r") do f; JSON.parse(Plot, readstring(f)) end
