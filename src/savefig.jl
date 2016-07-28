# ----------------------------------- #
# Methods for saving figures to files #
# ----------------------------------- #

# TODO: add width and height and figure out how to convert from measures to the
#       pixels that will be expected in the SVG
function savefig_cairosvg(p::SyncPlot, fn::AbstractString; dpi::Real=96)
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
function savefig_imagemagick(p::SyncPlot, fn::AbstractString; js::Symbol=:local
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

function savefig(p::SyncPlot, fn::AbstractString; js::Symbol=:local)
    suf = split(fn, ".")[end]

    # if html we don't need a plot window
    if suf == "html"
        open(fn, "w") do f
            writemime(f, MIME"text/html"(), p, js)
        end
        return p
    end

    # for all the rest we need raw svg data. to get that we'd have to display
    # the plot
    opened_here = !isactive(p.view)

    if opened_here
        display(p)
    end
    raw_svg = svg_data(p)

    # we can export svg directly
    if suf == "svg"
        open(fn, "w") do f
            write(f, raw_svg)
        end
        opened_here && close(p)
        return p
    end

    # now we need to use librsvg/Cairo to finish
    try
        @eval import Rsvg
        @eval import Cairo
    catch e
        if isa(e, ArgumentError)
            msg = string("You need to install the Rsvg package use this",
                         " routine for file type $suf\n",
                         "Try insalling with `Pkg.add(\"Rsvg\")`")
            error(msg)
        else
            rethrow(e)
        end
    end

    if suf == "pdf"
        r = Rsvg.handle_new_from_data(raw_svg)
        cs = Cairo.CairoPDFSurface(fn, size(p.plot)...)
        ctx = Cairo.CairoContext(cs)
        Rsvg.handle_render_cairo(ctx, r)
        Cairo.show_page(ctx)
        Cairo.finish(cs)
    elseif suf == "png"
        r = Rsvg.handle_new_from_data(raw_svg)
        cs = Cairo.CairoImageSurface(size(p.plot)...,Cairo.FORMAT_ARGB32)
        ctx = Cairo.CairoContext(cs)
        Rsvg.handle_render_cairo(ctx, r)
        Cairo.write_to_png(cs, fn)
    elseif suf == "eps"
        r = Rsvg.handle_new_from_data(raw_svg)
        cs = Cairo.CairoEPSSurface(fn, size(p.plot)...)
        ctx = Cairo.CairoContext(cs)
        Rsvg.handle_render_cairo(ctx, r)
        Cairo.show_page(ctx)
        Cairo.finish(cs)
    else
        error("Only html, svg, png, pdf, eps output supported")
    end

    opened_here && close(p)

    p
end

function png_data(p::SyncPlot)
    raw = _img_data(p, "png")
    raw[length("data:image/png;base64,")+1:end]
end

function jpeg_data(p::SyncPlot)
    raw = _img_data(p, "jpeg")
    raw[length("data:image/jpeg;base64,")+1:end]
end

function webp_data(p::SyncPlot)
    raw = _img_data(p, "webp")
    raw[length("data:image/webp;base64,")+1:end]
end

const _mimeformats =  Dict("application/eps"         => "eps",
                           "image/eps"               => "eps",
                           "application/pdf"         => "pdf",
                           "image/png"               => "png",
                           "image/jpeg"              => "jpeg",
                           "application/postscript"  => "ps",
                           # "image/svg+xml"           => "svg"
)

# TODO: replace ElectronPlot with SyncPlot once I figure out how to get
#       img_data from within IJulia
for (mime, fmt) in _mimeformats
    @eval @compat function Base.show(io::IO, ::MIME{Symbol($mime)}, p::ElectronPlot)
        @eval import ImageMagick

        # construct a magic wand and read the image data from png
        wand = ImageMagick.MagickWand()
        ImageMagick.readimage(wand, base64decode(png_data(p)))
        ImageMagick.setimageformat(wand, $fmt)
        ImageMagick.writeimage(wand, io)

    end
end


for func in [:png_data, :jpeg_data, :wepb_data, :svg_data,
             :_img_data, :savefig, :savefig_cairosvg, :savefig_imagemagick]
    @eval function $(func)(::Plot, args...; kwargs...)
        msg = string("$($func) not available without a frontend. ",
                     "Try calling `$($func)(plot(p))` instead")
        error(msg)
    end
end
