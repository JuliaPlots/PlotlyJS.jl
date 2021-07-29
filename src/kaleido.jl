using Kaleido_jll

mutable struct Pipes
    stdin::Pipe
    stdout::Pipe
    stderr::Pipe
    proc::Base.Process
    Pipes() = new()
end

const P = Pipes()

const ALL_FORMATS = ["png", "jpeg", "webp", "svg", "pdf", "eps", "json"]
const TEXT_FORMATS = ["svg", "json", "eps"]

function _restart_kaleido_process()
    if isdefined(P, :proc) && process_running(P.proc)
        kill(P.proc)
    end
    _start_kaleido_process()
end


function _start_kaleido_process()
    global P
    try
        BIN = let
            art = Kaleido_jll.artifact_dir
            cmd = if Sys.islinux() || Sys.isapple()
                joinpath(art, "kaleido")
            else
                # Windows
                joinpath(art, "kaleido.cmd")
            end
            no_sandbox = "--no-sandbox"
            Sys.isapple() ? `$(cmd) plotly --disable-gpu --single-process` : `$(cmd) plotly --disable-gpu $(no_sandbox)`
        end
        kstdin = Pipe()
        kstdout = Pipe()
        kstderr = Pipe()
        kproc = run(pipeline(BIN,
                             stdin=kstdin, stdout=kstdout, stderr=kstderr),
                    wait=false)
        process_running(kproc) || error("There was a problem startink up kaleido.")
        close(kstdout.in)
        close(kstderr.in)
        close(kstdin.out)
        Base.start_reading(kstderr.out)
        P.stdin = kstdin
        P.stdout = kstdout
        P.stderr = kstderr
        P.proc = kproc

        # read startup message and check for errors
        res = readline(P.stdout)
        if length(res) == 0
            error("Could not start Kaleido process")
        end

        js = JSON.parse(res)
        if get(js, "code", 0) != 0
            error("Could not start Kaleido process")
        end
    catch e
        @warn "Kaleido is not available on this system. Julia will be unable to save images of any plots."
        @warn "$e"
    end
    nothing
end

savefig(p::SyncPlot; kwargs...) = savefig(p.plot; kwargs...)

function savefig(
        p::Plot;
        width::Union{Nothing,Int}=nothing,
        height::Union{Nothing,Int}=nothing,
        scale::Union{Nothing,Real}=nothing,
        format::String="png"
    )::Vector{UInt8}
    if !(format in ALL_FORMATS)
        error("Unknown format $format. Expected one of $ALL_FORMATS")
    end

    # construct payload
    _get(x, def) = x === nothing ? def : x
    payload = Dict(
        :width => _get(width, 700),
        :height => _get(height, 500),
        :scale => _get(scale, 1),
        :format => format,
        :data => p
    )

    _ensure_kaleido_running()

    # convert payload to vector of bytes
    bytes = transcode(UInt8, JSON.json(payload))
    write(P.stdin, bytes)
    write(P.stdin, transcode(UInt8, "\n"))
    flush(P.stdin)

    # read stdout and parse to json
    res = readline(P.stdout)
    js = JSON.parse(res)

    # check error code
    code = get(js, "code", 0)
    if code != 0
        msg = get(js, "message", nothing)
        error("Transform failed with error code $code: $msg")
    end

    # get raw image
    img = String(js["result"])

    # base64 decode if needed, otherwise transcode to vector of byte
    if format in TEXT_FORMATS
        return transcode(UInt8, img)
    else
        return base64decode(img)
    end
end


@inline _get_Plot(p::Plot) = p
@inline _get_Plot(p::SyncPlot) = p.plot

"""
    savefig(
        io::IO,
        p::Plot;
        width::Union{Nothing,Int}=nothing,
        height::Union{Nothing,Int}=nothing,
        scale::Union{Nothing,Real}=nothing,
        format::String="png"
    )

Save a plot `p` to the io stream `io`. They keyword argument `format`
determines the type of data written to the figure and must be one of
$(join(ALL_FORMATS, ", ")), or html. `scale` sets the
image scale. `width` and `height` set the dimensions, in pixels. Defaults
are taken from `p.layout`, or supplied by plotly
"""
function savefig(io::IO,
        p::Union{SyncPlot,Plot};
        width::Union{Nothing,Int}=nothing,
        height::Union{Nothing,Int}=nothing,
        scale::Union{Nothing,Real}=nothing,
        format::String="png")
    if format == "html"
        return show(io, MIME("text/html"), _get_Plot(p), include_mathjax="cdn", include_plotlyjs="cdn", full_html=true)
    end

    bytes = savefig(p, width=width, height=height, scale=scale, format=format)
    write(io, bytes)
end


"""
    savefig(
        p::Plot, fn::AbstractString;
        format::Union{Nothing,String}=nothing,
        width::Union{Nothing,Int}=nothing,
        height::Union{Nothing,Int}=nothing,
        scale::Union{Nothing,Real}=nothing,
    )

Save a plot `p` to a file named `fn`. If `format` is given and is one of
$(join(ALL_FORMATS, ", ")), or html; it will be the format of the file. By
default the format is guessed from the extension of `fn`. `scale` sets the
image scale. `width` and `height` set the dimensions, in pixels. Defaults
are taken from `p.layout`, or supplied by plotly
"""
function savefig(
        p::Union{SyncPlot,Plot}, fn::AbstractString;
        format::Union{Nothing,String}=nothing,
        width::Union{Nothing,Int}=nothing,
        height::Union{Nothing,Int}=nothing,
        scale::Union{Nothing,Real}=nothing,
    )
    ext = split(fn, ".")[end]
    if format === nothing
        format = String(ext)
    end

    open(fn, "w") do f
        savefig(f, p; format=format, scale=scale, width=width, height=height)
    end
    return fn
end

_kaleido_running() = isdefined(P, :stdin) && isopen(P.stdin) && process_running(P.proc)
_ensure_kaleido_running() = !_kaleido_running() && _restart_kaleido_process()

const _KALEIDO_MIMES = Dict(
    "application/pdf" => "pdf",
    "image/png" => "png",
    "image/svg+xml" => "svg",
    "image/eps" => "eps",
    "image/jpeg" => "jpeg",
    "image/jpeg" => "jpeg",
    "application/json" => "json",
    "application/json; charset=UTF-8" => "json",
)

for (mime, fmt) in _KALEIDO_MIMES
    @eval function Base.show(
        io::IO, ::MIME{Symbol($mime)}, plt::Plot,
        width::Union{Nothing,Int}=nothing,
        height::Union{Nothing,Int}=nothing,
        scale::Union{Nothing,Real}=nothing,
    )
        savefig(io, plt, format=$fmt)
    end

    @eval function Base.show(
        io::IO, ::MIME{Symbol($mime)}, plt::SyncPlot,
        width::Union{Nothing,Int}=nothing,
        height::Union{Nothing,Int}=nothing,
        scale::Union{Nothing,Real}=nothing,
    )
        savefig(io, plt.plot, format=$fmt)
    end
end
