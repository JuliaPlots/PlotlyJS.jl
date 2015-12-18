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

to_svg(p::Plot, format="pdf") = @js p Plotly.Snapshot.toSVG(this, $format)

# TODO: add width and height and figure out how to convert from measures to the
#       pixels that will be expected in the SVG
function savefig(p::Plot, fn::AbstractString; dpi::Real=96)
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
function savefig2(p::Plot, fn::AbstractString)
    # make sure plot window is active
    show(p)
    @eval begin
        import ImageMagick, FileIO
    end
    img = ImageMagick.load_(base64decode(png_data(p)))
    FileIO.save(fn, img)
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

    if format == "svg"
        return to_svg(p)
    end

    @js p begin
        ev = Plotly.Snapshot.toImage(this, d("format"=>$format))
        @new Promise(resolve -> ev.once("success", resolve))
    end
end
