using PlotlyKaleido: kill, is_running, start, restart, ALL_FORMATS, TEXT_FORMATS

"""
    savefig(
        [io::IO], p::Plot, [fn:AbstractString];
        width::Union{Nothing,Integer}=700,
        height::Union{Nothing,Integer}=500,
        scale::Union{Nothing,Real}=nothing,
        format::String="png",
        plotlyjs::Union{AbstractString, Nothing}=nothing,
        plotly_version::Union{AbstractString, Nothing}=nothing
    )

Save a plot `p` to the IO stream `io` or to the file named `fn`.

If both `io` and `fn` are not specified, returns the image as a vector of bytes.

## Keyword Arguments

  - `format`: the image format, must be one of $(join(string.("*", ALL_FORMATS, "*"), ", ")), or *html*.
  - `scale`: the image scale.
  - `width` and `height`: the image dimensions, in pixels.
  - `plotly_version`, `plotly_js`: the version of *Plotly* JavaScript library to use for rendering.
     These arguments are mutually exclusive.
     Defaults to using the Plotly library bundled with *PlotlyJS.jl*.
"""
function savefig(
        p::Plot;
        width::Union{Nothing,Integer}=700,
        height::Union{Nothing,Integer}=500,
        scale::Union{Nothing,Real}=nothing,
        format::String="png",
        plotlyjs::Union{AbstractString, Nothing}=nothing,
        plotly_version::Union{AbstractString, Nothing}=nothing
    )
    in(format, ALL_FORMATS) ||
        throw(ArgumentError("Unknown format: $format. Expected one of: $(join(ALL_FORMATS, ", "))"))

    # construct payload
    payload = Dict(
        :format => format,
        :data => p
    )
    isnothing(width) || (payload[:width] = width)
    isnothing(height) || (payload[:height] = height)
    isnothing(scale) || (payload[:scale] = scale)

    _ensure_kaleido_running(; plotlyjs, plotly_version)
    P = PlotlyKaleido.P
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

savefig(p::SyncPlot; kwargs...) = savefig(p.plot; kwargs...)

@inline _get_Plot(p::Plot) = p
@inline _get_Plot(p::SyncPlot) = p.plot

function savefig(io::IO, p::Union{SyncPlot,Plot};
                 format::AbstractString="png",
                 kwargs...)
    if format == "html"
        return show(io, MIME("text/html"), _get_Plot(p), include_mathjax="cdn", include_plotlyjs="cdn", full_html=true)
    end

    bytes = savefig(p; format, kwargs...)
    write(io, bytes)
end

function savefig(
        p::Union{SyncPlot,Plot}, fn::AbstractString;
        format::Union{Nothing,AbstractString}=nothing,
        kwargs...
    )
    ext = split(fn, ".")[end]
    format = something(format, String(ext))

    open(fn, "w") do f
        savefig(f, p; format, kwargs...)
    end
    return fn
end

# If kaleido is not running, starts it using the specified plotly library.
# The plotly library is specified either as the `plotlyjs` path to the javascript library,
# or as a `plotly_version` (in the latter case the library is taken from `https://cdn.plot.ly/`).
# If none are specified, the plotly library from the `Artifacts.toml` is used.
function _ensure_kaleido_running(;
    plotlyjs::Union{AbstractString, Nothing} = nothing,
    plotly_version::Union{AbstractString, Nothing} = nothing,
    kwargs...
)
    if !is_running()
        !isnothing(plotly_version) && !isnothing(plotlyjs) &&
            throw(ArgumentError("Cannot specify both `plotly_version` and `plotlyjs`"))
        if !isnothing(plotly_version)
            restart(; plotly_version, kwargs...)
        else
            restart(; plotlyjs=something(plotlyjs, _js_path), kwargs...)
        end
    end
end

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
    @eval Base.show(
        io::IO, ::MIME{Symbol($mime)}, plt::Plot;
        kwargs...
    ) = savefig(io, plt; format=$fmt, kwargs...)

    @eval Base.show(
        io::IO, ::MIME{Symbol($mime)}, plt::SyncPlot;
        kwargs...
    ) = savefig(io, plt.plot; format=$fmt, kwargs...)
end
