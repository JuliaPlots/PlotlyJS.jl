type Line1
    x
    y
end

type Line2
    x
    width
    dash
end

type Line
    x
    y
    width
    dash
end

Base.convert(::Type{Line1}, l::Line) = Line1(l.x, l.y)
Base.convert(::Type{Line2}, l::Line) = Line2(l.x, l.width, l.dash)

type Marker
    symbol
    line::Line2
end

type Scatter
    line::Line1
    marker::Marker
end

@show l = Line(1, 2, 0.5, "-.")
@show m = Marker("x", l)
@show Scatter(l, m)
