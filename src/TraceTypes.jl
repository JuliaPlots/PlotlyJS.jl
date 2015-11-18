#
# Plotly Miscellaneous Enumerated Types
#
type Visible <: PlotlyEnumerated
    value

    function Visible(x)
        validvalues = [true, false, "LegendOnly"]
        if !(x ∈ validvalues)
            throw_enumerate_error(validvalues)
        end
        new(x)
    end
end
Visible() = Visible(true)

type Fill <: PlotlyEnumerated
    value

    function Fill(x::ASCIIString="none")
        validvalues = ["none", "tozeroy", "tozerox", "tonexty", "tonextx"]
        if !(x ∈ validvalues)
            throw_enumerate_error(validvalues)
        end
        new(x)
    end
end

type TextPosition <: PlotlyEnumerated
    value

    function TextPosition(x::ASCIIString="middle center")
        validvalues = ["top left", "top center", "top right", "middle left",
                       "middle center", "middle right", "bottom left",
                       "bottom center", "bottom right"]
        if !(x ∈ validvalues)
            throw_enumerate_error(validvalues)
        end
        new(x)
    end
end

#
# Plotly Miscellaneous Flag Lists
#
type HoverInfo <: PlotlyFlagList
    value

    function HoverInfo(x::AbstractString)
        validvalues = ["x", "y", "z", "all", "none"]
        myvalues = split(x, "+")

        if !(myvalues ⊆ validvalues)
            morestr = join(validvalues, "\n\t-")
            msg = "This object must have some combination of values from \n\t-$(morestr)"
            error(msg)
        end

        new(x)
    end
end
HoverInfo(x::Vector{ASCIIString}=["x", "y"]) = HoverInfo(join(x, "+"))

type Mode <: PlotlyFlagList
    value

    function Mode(x::AbstractString)
        validvalues = ["line", "markers", "text", "none"]
        myvalues = split(x, "+")

        if !(myvalues ⊆ validvalues)
            morestr = join(validvalues, "\n\t-")
            msg = "This object must have some combination of values from \n\t-$(morestr)"
            error(msg)
        end

        new(x)
    end
end
Mode(x::Vector{ASCIIString}=["line"]) = Mode(join(x, "+"))

#
# Plotly Miscellaneous Types
#
type Opacity <: AbstractPlotlyElement
    value::Float16

    function Opacity(x::Float16=1)
        if !(x >= 0 && x <= 1)
            msg = "This object must be >= 0 and <= 1 the values"
            error(msg)
        end
        new(x)
    end
end
Opacity(x::Number) = Opacity(Float16(x))

#
# Plotly Line
#
abstract LineElement <: AbstractPlotlyElement

type LineWidth <: LineElement
    x::Float16

    function LineWidth(x::Float16=Float16(2.0))
        if x < 0.0
            error("The line width must be greater than 0")
        end

        new(x)
    end
end

type LineShape <: PlotlyEnumerated
    value

    function LineShape(x="linear")
        validvalues = ["linear", "spline", "hv", "vh", "hvh", "vhv"]
        if !(x ∈ validvalues)
            morestr = join(validvalues, "\n\t-")
            msg = "This object must take one of the values from \n\t-$(morestr)"
            error(msg)
        end
        new(x)
    end
end

type LineSmooth <: LineElement
    x::Float16

    function LineSmooth(x::Float16=Float16(1.0))
        if x < 0.0 || x > 1.3
            error("The line smoothing must be greater than 0 and less than 1.3")
        end

        new(x)
    end
end
LineSmooth(x::Number) = LineSmooth(Float16(x))

type LineDash <: PlotlyEnumerated
    value

    function LineDash(x="solid")
        validvalues = ["solid", "dot", "dash", "longdash", "dashdot", "longdashdot"]

        if !(x ∈ validvalues)
            morestr = join(validvalues, "\n\t-")
            msg = "This object must take one of the values from \n\t-$(morestr)"
            error(msg)
        end
        new(x)
    end
end
LineWidth(x::Number) = LineWidth(Float16(x))

type Line <: AbstractPlotlyElement
    color::Colors.Colorant
    width::LineWidth
    shape::LineShape
    smoothing::LineSmooth
    dash::LineDash
end

Line() = Line(colorant"red", LineWidth(), LineShape(), LineSmooth(), LineDash())



#
# Plotly Text Font
#
abstract TextElement <: AbstractPlotlyElement

type FontSize <: TextElement
    size::Float16

    function FontSize(x::Float16)
        if x < 1.0
            error("Text size must be greater than 1")
        end

        new(x)
    end
end

FontSize(x::Number=12) = FontSize(Float16(x))
type TextFont <: AbstractPlotlyElement
    family::ASCIIString
    size::FontSize
    color::Colors.Colorant
end

TextFont() = TextFont("Arial", FontSize(), colorant"black")


#
# Plotly Marker
#
type MarkerSize <: AbstractPlotlyElement
    value::Float16

    function MarkerSize(val::Float16=6)
        if val < 0
            msg = "Marker size must be great than or equal to 0"
        end
        new(val)
    end
end

MarkerSize(x::Number) = MarkerSize(Float16(x))

# convert(::Type{MarkerSize}, xc::Number) = MarkerSize(x)

type Marker <: AbstractPlotlyElement
    symbol::ASCIIString
    opacity::Opacity
    size::MarkerSize
    #-Many More ....-#

    function Marker(symbol::ASCIIString="circle", opacity::Opacity=Opacity(1), size::MarkerSize=MarkerSize(6))
        validsymbols = [ "0" , "circle" , "100" , "circle-open" , "200" , "circle-dot" , "300" ,
                        "circle-open-dot" , "1" , "square" , "101" , "square-open" , "201" ,
                        "square-dot" , "301" , "square-open-dot" , "2" , "diamond" , "102"]  #There are many other options
        if !(symbol ∈ validsymbols)
            throw_enumerate_error(validsymbols)
        end
        new(symbol, opacity, size)
    end
end
