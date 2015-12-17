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


function to_svg(p::Plot)
    Blink.js(Plotlyjs.get_window(p), Blink.JSString("""
       var plt = document.getElementById('$(p.divid)');
       Plotly.Snapshot.toSVG(plt, 'pdf')
       """))
end

# TODO: add width and height and figure out how to convert from measures to the
#       pixels that will be expected in the SVG
function savefig(p::Plot, fn::AbstractString; dpi::Real=300)
    bas, ext = split(fn, ".")
    if !(ext in ["pdf", "png", "ps"])
        error("Only `pdf`, `png` and `ps` output supported")
    end
    # make sure plot window is active
    show(p)

    # write svg to tempfile
    temp = tempname()
    open(temp, "w") do f
        write(f, to_svg(p))
    end

    # hand off to cairosvg for conversion
    run(`cairosvg $temp -d $dpi -o $fn`)

    # remove temp file
    rm(temp)

    # return plot
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

    mime = "image/$format"
    # show the plot so we can access canvas
    show(p)
    code = """
    var plt = document.getElementById('$(p.divid)');
    var svg = Plotly.Snapshot.toSVG(plt);
    var canvasContainer = window.document.createElement('div');
    var canvas = window.document.createElement('canvas');
    canvasContainer.appendChild(canvas);
    var width = plt._fullLayout.width;
    var height = plt._fullLayout.height;
    var Image = window.Image;
    var Blob = window.Blob;
    var ctx = canvas.getContext('2d');
    var img = new Image();
    var DOMURL = window.URL || window.webkitURL;
    var svgBlob = new Blob([svg], {type: 'image/svg+xml;charset=utf-8'});
    var url = DOMURL.createObjectURL(svgBlob);
    canvas.height = height;
    canvas.width = width;

    img.onload = function() {
        ctx.drawImage(img, 0, 0);
        DOMURL.revokeObjectURL(url);
    }

    img.src = url;
    canvas.toDataURL('$mime');
    """
    Blink.js(get_window(p), Blink.JSString(code))
end
