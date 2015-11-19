#
# Plotly Miscellaneous Enumerated Types
#
type Visible <: AbstractValueAttribute
    value

    function Visible(x=true)
        validvalues = [true, false, "LegendOnly"]
        if !(x ∈ validvalues)
            throw_enumerate_error(validvalues)
        end
        new(x)
    end
end
Base.convert(::Type{Visible}, x::Union{Bool,ASCIIString}) = Visible(x)

type Fill <: AbstractValueAttribute
    value::ASCIIString

    function Fill(x::ASCIIString="none")
        validvalues = ["none", "tozeroy", "tozerox", "tonexty", "tonextx"]
        if !(x ∈ validvalues)
            throw_enumerate_error(validvalues)
        end
        new(x)
    end
end
Base.convert(::Type{Fill}, x::ASCIIString) = Fill(x)

type TextPosition <: AbstractValueAttribute
    value::ASCIIString

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
Base.convert(::Type{TextPosition}, x::ASCIIString) = TextPosition(x)

#
# Plotly Miscellaneous Flag Lists
#
type HoverInfo <: PlotlyFlagList
    value::ASCIIString

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
Base.convert(::Type{HoverInfo}, x::ASCIIString) = HoverInfo(x)

type Mode <: PlotlyFlagList
    value::ASCIIString

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
Base.convert(::Type{Mode}, x::ASCIIString) = Mode(x)

#
# Plotly Miscellaneous Types
#
type Opacity <: AbstractValueAttribute
    value::Float16

    function Opacity(x::Float16=1)
        if !(x >= 0 && x <= 1)
            msg = "This object must be >= 0 and <= 1 the values"
            error(msg)
        end
        new(x)
    end
end
Base.convert(::Type{Opacity}, x::Real) = Opacity(Float16(x))

#
# Plotly Line
#
abstract LineElement <: AbstractValueAttribute

type LineWidth <: LineElement
    value::Float16

    function LineWidth(x::Float16=Float16(2.0))
        if x < 0.0
            error("The line width must be greater than 0")
        end

        new(x)
    end
end
Base.convert(::Type{LineWidth}, x::Real) = LineWidth(Float16(x))


type LineShape <: PlotlyEnumerated
    value::ASCIIString

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
Base.convert(::Type{LineShape}, x::ASCIIString) = LineShape(x)

type LineSmooth <: LineElement
    value::Float16

    function LineSmooth(x::Float16=Float16(1.0))
        if x < 0.0 || x > 1.3
            error("The line smoothing must be greater than 0 and less than 1.3")
        end

        new(x)
    end
end
Base.convert(::Type{LineSmooth}, x::Real) = LineSmooth(Float16(x))

type LineDash <: PlotlyEnumerated
    value::ASCIIString

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
Base.convert(::Type{LineDash}, x::ASCIIString) = LineDash(x)

type Line <: AbstractObjectAttribute
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
abstract TextElement <: AbstractAttribute

type FontSize <: TextElement
    value::Float16

    function FontSize(x::Float16)
        if x < 1.0
            error("Text size must be greater than 1")
        end

        new(x)
    end
end
FontSize(x::Number=12) = FontSize(Float16(x))
Base.convert(::Type{FontSize}, x::Real) = FontSize(Float16(x))

type TextFont <: AbstractObjectAttribute
    family::ASCIIString
    size::FontSize
    color::Colors.Colorant
end

TextFont() = TextFont("Arial", FontSize(), colorant"black")


#
# Plotly Marker
#
type MarkerSize <: AbstractValueAttribute
    value::Float16

    function MarkerSize(x::Float16=Float16(6))
        if x < 0
            msg = "Marker size must be great than or equal to 0"
        end
        new(x)
    end
end

Base.convert(::Type{MarkerSize}, x::Real) = MarkerSize(Float16(x))

# Base.convert(::Type{MarkerSize}, xc::Number) = MarkerSize(x)

type Marker <: AbstractObjectAttribute
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
