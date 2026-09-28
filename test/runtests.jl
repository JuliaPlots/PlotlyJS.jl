using PlotlyJS
using Test

if Sys.islinux()
    debug = Base.get_bool_env("CI", false) ? false : true
    PlotlyJS.unsafe_electron(debug)
    include("blink.jl")
end
include("kaleido.jl")

@testset "SyncPlot with non-finite data" begin
    # `NaN` is commonly used for gaps in trace data; it must be written as `null`
    @test plot(scatter(x=1:4, y=[1.0, NaN, Inf, 4.0])) isa PlotlyJS.SyncPlot
end

# these are public API
@test isfile(PlotlyJS._js_path)
@test !isempty(PlotlyJS._js_version)
@test !startswith(PlotlyJS._js_version, "v")
