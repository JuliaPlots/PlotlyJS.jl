module PlotlyJSTest

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

include(joinpath(dirname(dirname(abspath(@__FILE__))), "src", "PlotlyJS.jl"))
using .PlotlyJS
typealias M PlotlyJS

tests = length(ARGS) > 0 ? ARGS : ["traces", "api"]

for fn in tests
    include(string(fn, ".jl"))
end

end
