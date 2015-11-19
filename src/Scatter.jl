type Scatter <: AbstractTrace
    visible::Visible
    showlegend::Bool
    legendgroup::AbstractString
    opacity::Opacity
    name::AbstractString
    hoverinfo::HoverInfo
    x::Vector
    # x0::Number  # Decide how to handle steps
    # dx::Number  # Decide how to handle steps
    y::Vector
    # y0::Number  # Decide how to handle steps
    # dy::Number  # Decide how to handle steps
    text::Union{Array{ASCIIString}, ASCIIString}
    mode::Mode  # These can take multiple args separated by `+`
    line::Line
    connectgaps::Bool
    fill::Fill
    fillcolor::Colors.Colorant
    marker::Marker
    textposition::TextPosition
    textfont::TextFont
    # r::Vector
    # t::Vector
    # error_y::PlotlyError
    # error_x::PlotlyError
    xaxis::ASCIIString
    yaxis::ASCIIString

    # Don't worry about the following arguments until we introduce an
    # the website interface to interact with
    # stream::PlotlyStream
    # xsrc::AbstractString
    # ysrc::AbstractString
    # textsrc::AbstractString
    # textpositionsrc::AbstractString
    # rsrc::AbstractString
    # tsrc::AbstractString
end

function Scatter(x=collect(1:50), y=randn(50);
                 visible=Visible(), showlegend=true, legendgroup="",
                 opacity=Opacity(), name="foobar", hoverinfo=HoverInfo(),
                 text="Point", mode=Mode(), line=Line(), connectgaps=true,
                 fill=Fill(), fillcolor=colorant"red", marker=Marker(),
                 textposition=TextPosition(), textfont=TextFont(), #r=[], t=[],
                 xaxis="x1", yaxis="y1")

    return Scatter(visible, showlegend, legendgroup, opacity, name,
                   hoverinfo, x, y, text, mode, line, connectgaps, fill,
                   fillcolor, marker, textposition, textfont,# r, t, 
                   xaxis, yaxis)

end

plottype(::Scatter) = "scatter"
