using PlotlyJS
using Test

Sys.isunix() && PlotlyJS.unsafe_electron(true)

Sys.islinux() && include("blink.jl")  # xvfb-run
include("kaleido.jl")

# these are public API
@test isfile(PlotlyJS._js_path)
@test !isempty(PlotlyJS._js_version)
@test !startswith(PlotlyJS._js_version, "v")
