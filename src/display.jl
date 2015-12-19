# ----------- #
# Blink setup #
# ----------- #

const _js_path = joinpath(dirname(dirname(@__FILE__)),
                          "deps", "plotly-latest.min.js")

function html_body(p::Plot)
    """
    <div id="$(p.divid)"></div>

    <script>
       thediv = document.getElementById('$(p.divid)');
       var data = $(json(p.data))
       var layout = $(json(p.layout))

       Plotly.plot(thediv, data,  layout, {showLink: false});
     </script>
    """
end

stringmime(::MIME"text/html", p::Plot) =  """
    <html>
    <head>
        <script src="$(_js_path)"></script>
    </head>

    <body>
      $(html_body(p))
    </body>
    </html>
    """

Base.writemime(io::IO, ::MIME"text/html", p::Plot) =
    print(io, stringmime(MIME"text/html"(), p))


get_blink() = Blink.AtomShell.shell()

function get_window(p::Plot)
    if !isnull(p.window) && active(get(p.window))
        w = get(p.window)
    else
        width, height = size(p)
        w = Window(get_blink(), Dict{Any,Any}(:width=>width, :height=>height))
        p.window = Nullable{Window}(w)
    end
    w
end

function Base.show(p::Plot)
    w = get_window(p)
    Blink.load!(w, _js_path)
    Blink.body!(w, html_body(p))
    p
end

# ---------------------- #
# Jupyter notebook setup #
# ---------------------- #

# if we're in IJulia call setupnotebook to load js and css
if isdefined(Main, :IJulia) && Main.IJulia.inited
    # the first script is some hack I needed to do in order for the notebook
    # to not complain about Plotly being undefined
    display("text/html", """
        <script type="text/javascript">
            require=requirejs=define=undefined;
        </script>
        <script type="text/javascript">
            $(open(readall, _js_path, "r"))
        </script>
     """)
    display("text/html", "<p>Plotly javascript loaded.</p>")
end

# -------------- #
# Javascript API #
# -------------- #
# TODO: update the fields on the Plot object also for functions that mutate the
#       plot

Blink.js(p::Plot, code::JSString; callback = true) =
    Blink.js(get_window(p), :(Blink.evalwith(thediv, $(Blink.jsstring(code)))), callback = callback)

restyle!(p::Plot, update = Dict(); kwargs...) =
    @js_ p Plotly.restyle(this, $(merge(update, prep_kwargs(kwargs))))

restyle!(p::Plot, traces::Integer...; kwargs...) =
    @js_ p Plotly.restyle(this, $(prep_kwargs(kwargs)), $(collect(traces)))

relayout!(p::Plot, update = Dict(); kwargs...) =
    @js_ p Plotly.relayout(this, $(merge(update, prep_kwargs(kwargs))))

addtraces!(p::Plot, traces::AbstractTrace...) =
    @js_ p Plotly.addTraces(this, $traces)

addtraces!(p::Plot, where::Union{Int,Vector{Int}}, traces::AbstractTrace...) =
    @js_ p Plotly.addTraces(this, $traces, $where)

deletetraces!(p::Plot, traces::Int...) =
    @js_ p Plotly.deleteTraces(this, $(collect(traces)))

movetraces!(p::Plot, to_end) =
    @js_ p Plotly.moveTraces(this, $to_end)

movetraces!(p::Plot, to_end...) = movetraces!(p, collect(to_end))

movetraces!(p::Plot, src::Union{Int,Vector{Int}}, dest::Union{Int,Vector{Int}}) =
    @js_ p Plotly.moveTraces(this, $src, $dest)

redraw!(p::Plot) =
    @js_ p Plotly.redraw(this)


redraw!(p::Plot) =
    @js_ p Plotly.redraw(this)

# --------------------------------- #
# unexported methods in plot_api.js #
# --------------------------------- #

tovec(v) = tovec([v])
tovec(v::Vector) = eltype(v) <: Vector ? v : Vector[v]

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
extendtraces!(p, Dict(:y=>Vector[[1, 3]]), [0], -1)
extendtraces!(p, Dict(:y=>Vector[[1, 3]]))  # equivalent to above
```

```julia
# adds the values [1, 3] to the end of the third trace's marker.size attribute
# and [5,5,6] to the end of the 5th traces marker.size -- leaving at most 10
# points per marker.size attribute
extendtraces!(p, Dict("marker.size"=>Vector[[1, 3], [5, 5, 6]]), [2, 4], 10)
```

"""
function extendtraces!(p::Plot, update::Dict, indices::Vector{Int}=[0], maxpoints=-1;
                       update_jl::Bool=false)
    # update data in Julia object
    if update_jl
        for ix in indices
            tr = p.data[ix+1]
            for k in keys(update)
                v = update[k][ix+1]
                tr[k] = push!(tr[k], v...)
            end
        end
    end

    @js_ p Plotly.extendTraces(this, $update, $indices, $maxpoints)
end

"""
The API for `prependtraces` is equivalent to that for `extendtraces` except that
the data is added to the front of the traces attributes instead of the end. See
Those docstrings for more information
"""
function prependtraces!(p::Plot, update::Dict, indices::Vector{Int}=[0], maxpoints=-1)
    # update data in Julia object
    if update_jl
        for ix in indices
            tr = p.data[ix+1]
            for k in keys(update)
                v = update[k][ix+1]
                tr[k] = vcat(v, tr[k])
            end
        end
    end
    @js_ p Plotly.prependTraces(this, $update, $indices, $maxpoints)
end


for f in (:extendtraces!, :prependtraces!)
    @eval $(f)(p::Plot, inds::Vector{Int}=[0], maxpoints=-1; update_jl=false, update...) =
        ($f)(p, Dict(map(x->(x[1], tovec(x[2])), update)), inds, maxpoints; update_jl=update_jl)

    @eval $(f)(p::Plot, inds::Int, maxpoints=-1; update_jl=false, update...) =
        ($f)(p, [inds], maxpoints; update_jl=update_jl, update...)

    @eval $(f)(p::Plot, update::Dict, inds::Int, maxpoints=-1; update_jl=false) =
        ($f)(p, update, [inds], maxpoints; update_jl=update_jl)
end
