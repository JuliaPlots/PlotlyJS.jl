module PlotlyJSTest
using TestSetExtensions

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

using PlotlyJS
@compat const M = PlotlyJS

try
    @testset DottedTestSet "PlotlyJS Tests" begin
        @includetests ARGS
    end
catch
    exit(-1)
end

end
