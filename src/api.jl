# -------------------------- #
# Standard Julia API methods #
# -------------------------- #

prep_kwarg(pair::Tuple) = (symbol(replace(string(pair[1]), "_", ".")), pair[2])
prep_kwargs(pairs::Vector) = Dict(map(prep_kwarg, pairs))

"""
`size(::PlotlyJS.Plot)`

Return the size of the plot in pixels. Obtained from the `layout.width` and
`layout.height` fields.
"""
Base.size(p::Plot) = (get(p.layout.fields, :width, 800),
                      get(p.layout.fields, :height, 450))

for t in [:histogram, :scatter3d, :surface, :mesh3d, :bar, :histogram2d,
          :histogram2dcontour, :scatter, :pie, :heatmap, :contour,
          :scattergl, :box, :area, :scattergeo, :choropleth]
    str_t = string(t)
    @eval $t(;kwargs...) = GenericTrace($str_t; kwargs...)
    eval(Expr(:export, t))
end

Base.copy(gt::GenericTrace) = GenericTrace(gt.kind, deepcopy(gt.fields))
Base.copy(l::Layout) = Layout(deepcopy(l.fields))
Base.copy(p::Plot) = Plot([copy(t) for t in p.data], copy(p.layout))
fork(p::Plot) = Plot(deepcopy(p.data), copy(p.layout), Base.Random.uuid4())

# -------------- #
# Javascript API #
# -------------- #

function _update_fields(hf::HasFields, update::Dict=Dict(); kwargs...)
    map(x->setindex!(hf, x[2], x[1]), update)
    map(x->setindex!(hf, x[2], x[1]), kwargs)
end

"Update layout using update dict and/or kwargs"
relayout!(l::Layout, update::Associative=Dict(); kwargs...) =
    _update_fields(l, update; kwargs...)

"Update layout using update dict and/or kwargs"
relayout!(p::Plot, update::Associative=Dict(); kwargs...) =
    relayout!(p.layout, update; kwargs...)

"update a trace using update dict and/or kwargs"
restyle!(gt::GenericTrace, update::Associative=Dict(); kwargs...) =
    _update_fields(gt, update; kwargs...)

"Update a single trace using update dict and/or kwargs"
restyle!(p::Plot, ind::Int=1, update::Associative=Dict(); kwargs...) =
    restyle!(p.data[ind], update; kwargs...)

"Update specific traces using update dict and/or kwargs"
restyle!(p::Plot, inds::AbstractVector{Int}, update::Associative=Dict(); kwargs...) =
    map(ind -> restyle!(p.data[ind], update; kwargs...), inds)

"Update all traces using update dict and/or kwargs"
restyle!(p::Plot, update::Associative=Dict(); kwargs...) =
    restyle!(p, 1:length(p.data), update; kwargs...)

"Add trace(s) to the end of the Plot's array of data"
addtraces!(p::Plot, traces::AbstractTrace...) = push!(p.data, traces...)

"""
Add trace(s) at a specified location in the Plot's array of data.

The new traces will start at index `p.data[where]`
"""
function addtraces!(p::Plot, where::Int, traces::AbstractTrace...)
    new_data = vcat(p.data[1:where-1], traces..., p.data[where:end])
    p.data = new_data
end

"Remove the traces at the specified indices"
deletetraces!(p::Plot, inds::Int...) =
    (p.data = p.data[setdiff(1:length(p.data), inds)])

"Move one or more traces to the end of the data array"
movetraces!(p::Plot, to_end::Int...) =
    (p.data = p.data[vcat(setdiff(1:length(p.data), to_end), to_end...)])

function _move_one!(x::AbstractArray, from::Int, to::Int)
    el = splice!(x, from)  # extract the element
    splice!(x, to:to-1, (el,))  # put it back in the new position
    x
end

"""
Move traces from indices `src` to indices `dest`.

Both `src` and `dest` must be `Vector{Int}`
"""
movetraces!(p::Plot, src::AbstractVector{Int}, dest::AbstractVector{Int}) =
    (map((i,j) -> _move_one!(p.data, i, j), src, dest); p)

# no-op here
redraw!(p::Plot) = nothing

# --------------------------------- #
# unexported methods in plot_api.js #
# --------------------------------- #

_tovec(v) = _tovec([v])
_tovec(v::Vector) = eltype(v) <: Vector ? v : Vector[v]

"""
`extendtraces!(::Plot, ::Dict{Union{Symbol,AbstractString},Vector{Vector{Any}}}), indices, maxpoints)`

Extend one or more traces with more data. A few notes about the structure of the
update dict are important to remember:

- The keys of the dict should be of type `Symbol` or `AbstractString` specifying
  the trace attribute to be updated. These attributes must already exist in the
  trace
- The values of the dict _must be_ a `Vector` of `Vector` of data. The outer index
  tells Plotly which trace to update, whereas the `Vector` at that index contains
  the value to be appended to the trace attribute.

These concepts are best understood by example:

```julia
# adds the values [1, 3] to the end of the first trace's y attribute and doesn't
# remove any points
extendtraces!(p, Dict(:y=>Vector[[1, 3]]), [1], -1)
extendtraces!(p, Dict(:y=>Vector[[1, 3]]))  # equivalent to above
```

```julia
# adds the values [1, 3] to the end of the third trace's marker.size attribute
# and [5,5,6] to the end of the 5th traces marker.size -- leaving at most 10
# points per marker.size attribute
extendtraces!(p, Dict("marker.size"=>Vector[[1, 3], [5, 5, 6]]), [3, 5], 10)
```

"""
function extendtraces!(p::Plot, update::Dict, indices::Vector{Int}=[1], maxpoints=-1)
    # TODO: maxpoints not handled here
    for ix in indices
        tr = p.data[ix]
        for k in keys(update)
            v = update[k][ix]
            tr[k] = push!(tr[k], v...)
        end
    end
end

"""
The API for `prependtraces` is equivalent to that for `extendtraces` except that
the data is added to the front of the traces attributes instead of the end. See
Those docstrings for more information
"""
function prependtraces!(p::Plot, update::Dict, indices::Vector{Int}=[1], maxpoints=-1)
    # TODO: maxpoints not handled here
    for ix in indices
        tr = p.data[ix]
        for k in keys(update)
            v = update[k][ix]
            tr[k] = vcat(v, tr[k])
        end
    end
end


for f in (:extendtraces!, :prependtraces!)
    @eval $(f)(p::Plot, inds::Vector{Int}=[0], maxpoints=-1; update...) =
        ($f)(p, Dict(map(x->(x[1], _tovec(x[2])), update)), inds, maxpoints)

    @eval $(f)(p::Plot, inds::Int, maxpoints=-1, update...) =
        ($f)(p, [inds], maxpoints, update...)

    @eval $(f)(p::Plot, update::Dict, inds::Int, maxpoints=-1) =
        ($f)(p, update, [inds], maxpoints)
end
