module PlotlyJSTest
using TestSetExtensions

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

using PlotlyJS
typealias M PlotlyJS
using JSON

try
    @testset DottedTestSet "PlotlyJS Tests" begin
        @includetests ARGS
    end
catch
    exit(-1)
end

end
