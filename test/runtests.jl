using PlotlyJS
using Test

if Sys.islinux()
    debug = Base.get_bool_env("CI", false) ? false : true
    PlotlyJS.unsafe_electron(debug)
    include("blink.jl")
end
include("kaleido.jl")

# these are public API
@test isfile(PlotlyJS._js_path)
@test !isempty(PlotlyJS._js_version)
@test !startswith(PlotlyJS._js_version, "v")
