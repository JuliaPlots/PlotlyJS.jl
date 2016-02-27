module PlotlyJSTest

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

include(joinpath(dirname(dirname(abspath(@__FILE__))), "src", "PlotlyJS.jl"))
typealias M PlotlyJS


include("traces.jl")

end
