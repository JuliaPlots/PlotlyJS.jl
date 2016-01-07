Base.size(p::Plot) = (get(p.layout.fields, :width, 800),
                      get(p.layout.fields, :height, 450))

Base.resize!(p::Plot, w::Int, h::Int) = size(get_window(p), w, h)
function Base.resize!(p::Plot)
    sz = size(p)
    # this padding was found by trial and error to not show vertical or
    # horizontal scroll bars
    resize!(p, sz[1]+10, sz[2]+25)
end

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

# TODO: somehow `length(to_svg(p))` is not idempotent
to_svg(p::Plot, format="pdf") = @js p Plotly.Snapshot.toSVG(this, $format)

# TODO: add width and height and figure out how to convert from measures to the
#       pixels that will be expected in the SVG
function savefig2(p::Plot, fn::AbstractString; dpi::Real=96)
    bas, ext = split(fn, ".")
    if !(ext in ["pdf", "png", "ps"])
        error("Only `pdf`, `png` and `ps` output supported")
    end
    # make sure plot window is active
    show(p)

    # write svg to tempfile
    temp = tempname()
    open(temp, "w") do f
        write(f, to_svg(p, ext))
    end

    # hand off to cairosvg for conversion
    run(`cairosvg $temp -d $dpi -o $fn`)

    # remove temp file
    rm(temp)

    # return plot
    p
end

# an alternative way to save plots -- no shelling out, but output less pretty
function savefig(p::Plot, fn::AbstractString,
                #   sz::Tuple{Int,Int}=(8,6),
                #   dpi::Int=300
                  )
    # make sure plot window is active
    show(p)

    # construct a magic wand and read the image data from png
    wand = MagickWand()
    # readimage(wand, _img_data(p, "svg"))
    readimage(wand, base64decode(png_data(p)))
    resetiterator(wand)

    # # set units to inches
    # status = ccall((:MagickSetImageUnits, ImageMagick.libwand), Cint,
    #       (Ptr{Void}, Cint), wand.ptr, 1)
    # status == 0 && error(wand)
    #
    # # calculate number of rows/cols
    # width, height = sz[1]*dpi, sz[2]*dpi
    #
    # # set resolution
    # status = ccall((:MagickSetImageResolution, ImageMagick.libwand), Cint,
    # (Ptr{Void}, Cdouble, Cdouble), wand.ptr, Cdouble(dpi), Cdouble(dpi))
    # status == 0 && error(wand)
    #
    # # set number of columns and rows
    # status = ccall((:MagickAdaptiveResizeImage, ImageMagick.libwand), Cint,
    #       (Ptr{Void}, Csize_t, Csize_t), wand.ptr, Csize_t(width), Csize_t(height))
    # status == 0 && error(wand)


    # finally write the image out
    writeimage(wand, fn)

    p
end


# TODO: I'm not really sure what to do with this... I _think_ it is base64 encoded
#       and I will need to do some sort of encode/decode... not sure though

function png_data(p::Plot)
    raw = _img_data(p, "png")
    raw[length("data:image/png;base64,")+1:end]
end

function jpeg_data(p::Plot)
    raw = _img_data(p, "jpeg")
    raw[length("data:image/jpeg;base64,")+1:end]
end

function webp_data(p::Plot)
    raw = _img_data(p, "webp")
    raw[length("data:image/webp;base64,")+1:end]
end

function _img_data(p::Plot, format::ASCIIString)
    _formats = ["png", "jpeg", "webp", "svg"]
    if !(format in _formats)
        error("Unsupported format $format, must be one of $_formats")
    end

    show(p)

    @js p begin
        ev = Plotly.Snapshot.toImage(this, d("format"=>$format))
        @new Promise(resolve -> ev.once("success", resolve))
    end
end


# -------------- #
# Javascript API #
# -------------- #
# TODO: update the fields on the Plot object also for functions that mutate the
#       plot

getdiv(p) = :(document.getElementById($(string(p.divid))))

Blink.js(p::Plot, code::JSString; callback = true) =
    Blink.js(get_window(p), :(Blink.evalwith($(getdiv(p)), $(Blink.jsstring(code)))), callback = callback)

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
