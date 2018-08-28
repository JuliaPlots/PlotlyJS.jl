module PlotlyJSTest
using Test

using PlotlyJS
const M = PlotlyJS

using Blink
!Blink.AtomShell.isinstalled() && Blink.AtomShell.install()

include("blink.jl")

end
