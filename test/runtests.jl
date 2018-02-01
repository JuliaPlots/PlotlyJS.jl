module PlotlyJSTest
using TestSetExtensions

using Base.Test

using PlotlyJS
const M = PlotlyJS

using Blink
!Blink.AtomShell.isinstalled() && Blink.AtomShell.install()

try
    @testset ExtendedTestSet "PlotlyJS Tests" begin
        @includetests ARGS
    end
catch
    exit(-1)
end

end
