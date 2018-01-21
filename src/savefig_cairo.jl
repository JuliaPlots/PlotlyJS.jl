import Cairo, Rsvg
using Rsvg.handle_new_from_data
using Cairo.CairoPDFSurface

function _savefig_cairo(
        p::Plot, raw_svg::AbstractString, fn::AbstractString,
        suf::AbstractString
    )
    if suf == "pdf"
        r = Rsvg.handle_new_from_data(raw_svg)
        cs = Cairo.CairoPDFSurface(fn, size(p)...)
        ctx = Cairo.CairoContext(cs)
        Rsvg.handle_render_cairo(ctx, r)
        Cairo.show_page(ctx)
        Cairo.finish(cs)
    elseif suf == "png"
        r = Rsvg.handle_new_from_data(raw_svg)
        cs = Cairo.CairoImageSurface(size(p)..., Cairo.FORMAT_ARGB32)
        ctx = Cairo.CairoContext(cs)
        Rsvg.handle_render_cairo(ctx, r)
        Cairo.write_to_png(cs, fn)
    elseif suf == "eps"
        r = Rsvg.handle_new_from_data(raw_svg)
        cs = Cairo.CairoEPSSurface(fn, size(p)...)
        ctx = Cairo.CairoContext(cs)
        Rsvg.handle_render_cairo(ctx, r)
        Cairo.show_page(ctx)
        Cairo.finish(cs)
    else
        error("Unknown file-suffix $suf")
    end
end
