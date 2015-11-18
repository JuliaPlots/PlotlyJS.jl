immutable ScatterTrace <: AbstractTrace
    plottype::AbstractString
    visible::PlotlyVisible
    showlegend::Bool
    legendgroup::AbstractString
    opacity::PlotlyOpaque
    name::String
    hoverinfo::PlotlyHoverInfo
    x::Vector
    x0::Number  # Decide how to handle steps
    dx::Number  # Decide how to handle steps
    y::Vector
    y0::Number  # Decide how to handle steps
    dy::Number  # Decide how to handle steps
    text::Union{Array{ASCIIString}, ASCIIString}
    mode::AbstractString  # These can take multiple args separated by `+`
    line::PlotlyLine
    connectgaps::Bool
    fill::PlotlyEnumerated
    fillcolor::Colors.Colorant
    marker::PlotlyMarker
    textposition::PlotlyEnumerated
    textfont::PlotlyFont
    r::Vector
    t::Vector
    error_y::PlotlyError
    error_x::PlotlyError
    xaxis::PlotlyAxisID
    yaxis::PlotlyAxisID

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

function ScatterTrace(x=collect(1:length(y)), y=randn(50);
                      visible=true, showlegend=true, legendgroup="",
                      opacity=1.0, name="Plotly Plot", hoverinfo="all",
                      stream=("token", 50), text=Union{Array{AbstractString}, AbstractString},
                      mode="markers", line=PlotlyLine(), connectgaps=true,
                      fill="none", fillcolor="blue", marker=PlotlyMarker(),
                      textposition, textfont, r, t, error_y, error_x,
                       xaxis, yaxis)



    return ScatterTrace("scatter", plottype, visible, showlegend, legendgroup,
                        opacity, name, hoverinfo, stream, x, x0, dx, y, y0, dy,
                        text, mode, line, connectgaps, fill, fillcolor, marker,
                        textposition, textfont, r, t, error_y, error_x,
                        xaxis, yaxis)
end