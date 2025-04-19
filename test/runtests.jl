using PlotlyJS
using Test

# Sys.isunix() && PlotlyJS.@unsafe_electron

@eval PlotlyJS.Blink.AtomShell function init(; debug = false)
    electron() # Check path exists
    p, dp = port(), port()
    debug && inspector(dp)
    dbg = debug ? "--debug=$dp" : []
    # vvvvvvvvvvvv begin addition
    cmd = `$(electron()) --no-sandbox $dbg $mainjs port $p`
    # ^^^^^^^^^^^^ end addition
    proc = (debug ? run_rdr : run)(cmd; wait = false)
    conn = try_connect(ip"127.0.0.1", p)
    shell = Electron(proc, conn)
    initcbs(shell)
    return shell
end

# using Blink
# !Blink.AtomShell.isinstalled() && Blink.AtomShell.install()

include("blink.jl")
include("kaleido.jl")

# these are public API
@test isfile(PlotlyJS._js_path)
@test !isempty(PlotlyJS._js_version)
@test !startswith(PlotlyJS._js_version, "v")
