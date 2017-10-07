module PlotlyJSTest
using TestSetExtensions
using Compat

using Base.Test

using PlotlyJS
const M = PlotlyJS

try
    @testset DottedTestSet "PlotlyJS Tests" begin
        @includetests ARGS
    end
catch
    exit(-1)
end

end
