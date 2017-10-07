module PlotlyJSTest
using TestSetExtensions

using Base.Test

using PlotlyJS
const M = PlotlyJS

try
    @testset ExtendedTestSet "PlotlyJS Tests" begin
        @includetests ARGS
    end
catch
    exit(-1)
end

end
