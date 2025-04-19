using PlotlyJS
using Test

PlotlyJS.@unsafe_electron

# using Blink
# !Blink.AtomShell.isinstalled() && Blink.AtomShell.install()

include("blink.jl")
include("kaleido.jl")

# these are public API
@test isfile(PlotlyJS._js_path)
@test !isempty(PlotlyJS._js_version)
@test !startswith(PlotlyJS._js_version, "v")
