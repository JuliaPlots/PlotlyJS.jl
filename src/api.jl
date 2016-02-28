# ----------------- #
# Basic API methods #
# ----------------- #

prep_kwarg(pair::Tuple) = (symbol(replace(string(pair[1]), "_", ".")), pair[2])
prep_kwargs(pairs::Vector) = Dict(map(prep_kwarg, pairs))

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

# TODO: add width and height and figure out how to convert from measures to the
#       pixels that will be expected in the SVG
function savefig2(p::Plot, fn::AbstractString; dpi::Real=96)
    bas, ext = split(fn, ".")
    if !(ext in ["pdf", "png", "ps"])
        error("Only `pdf`, `png` and `ps` output supported")
    end
    # make sure plot window is active
    display(p)

    # write svg to tempfile
    temp = tempname()
    open(temp, "w") do f
        write(f, svg_data(p, ext))
    end

    # hand off to cairosvg for conversion
    run(`cairosvg $temp -d $dpi -o $fn`)

    # remove temp file
    rm(temp)

    # return plot
    p
end

# an alternative way to save plots -- no shelling out, but output less pretty

"""
`savefig(p::Plot, fn::AbstractString, js::Symbol)`

## Arguments

- `p::Plot`: Plotly Plot
- `fn::AbstractString`: Filename with extension (html, pdf, png)
- `js::Symbol`: One of the following:
    - `:local` - reference the javascript from PlotlyJS installation
    - `:remote` - reference the javascript from plotly CDN
    - `:embed` - embed the javascript in output (add's 1.7MB to size)
"""
function savefig(p::Plot, fn::AbstractString; js::Symbol=:local
                #   sz::Tuple{Int,Int}=(8,6),
                #   dpi::Int=300
                  )

    # Extract file type
    suf = split(fn, ".")[end]

    # if html we don't need a plot window
    if suf == "html"
        open(fn, "w") do f
            writemime(f, MIME"text/html"(), p, js)
        end
        return p
    end

    # for all the rest we need an active plot window
    show(p)

    # we can export svg directly
    if suf == "svg"
        open(fn, "w") do f
            write(f, svg_data(p))
        end
        return p
    end

    # now for the rest we need ImageMagick
    @eval import ImageMagick

    # construct a magic wand and read the image data from png
    wand = ImageMagick.MagickWand()
    # readimage(wand, _img_data(p, "svg"))
    ImageMagick.readimage(wand, base64decode(png_data(p)))
    ImageMagick.resetiterator(wand)

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
    ImageMagick.writeimage(wand, fn)

    p
end

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

# TODO: somehow `length(svg_data(p))` is not idempotent
svg_data(p::Plot, format="pdf") = @js p Plotly.Snapshot.toSVG(this, $format)

function _img_data(p::Plot, format::ASCIIString)
    _formats = ["png", "jpeg", "webp", "svg"]
    if !(format in _formats)
        error("Unsupported format $format, must be one of $_formats")
    end

    display(p)

    @js p begin
        ev = Plotly.Snapshot.toImage(this, d("format"=>$format))
        @new Promise(resolve -> ev.once("success", resolve))
    end
end

const _mimeformats =  Dict("application/eps"         => "eps",
                           "image/eps"               => "eps",
                           "application/pdf"         => "pdf",
                           "image/png"               => "png",
                           "image/jpeg"              => "jpeg",
                           "application/postscript"  => "ps",
                           # "image/svg+xml"           => "svg"
)

for (mime, fmt) in _mimeformats
    @eval function Base.writemime(io::IO, ::MIME{symbol($mime)}, p::Plot)
        @eval import ImageMagick

        # construct a magic wand and read the image data from png
        wand = ImageMagick.MagickWand()
        ImageMagick.readimage(wand, base64decode(png_data(p)))
        ImageMagick.setimageformat(wand, $fmt)
        ImageMagick.writeimage(wand, io)

    end
end


# -------------- #
# Javascript API #
# -------------- #

## methods that operate on the Julia object only

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

The new traces will start at index `p.data[where+1]`
"""
function addtraces!(p::Plot, where::Int, traces::AbstractTrace...)
    new_data = vcat(p.data[1:where], traces..., p.data[where+1:end])
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
        ($f)(p, Dict(map(x->(x[1], _tovec(x[2])), update)), inds, maxpoints; update_jl=update_jl)

    @eval $(f)(p::Plot, inds::Int, maxpoints=-1; update_jl=false, update...) =
        ($f)(p, [inds], maxpoints; update_jl=update_jl, update...)

    @eval $(f)(p::Plot, update::Dict, inds::Int, maxpoints=-1; update_jl=false) =
        ($f)(p, update, [inds], maxpoints; update_jl=update_jl)
end
