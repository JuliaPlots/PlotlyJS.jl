module IJuliaExt

using PlotlyJS
isdefined(Base, :get_extension) ? (using IJulia) : (using ..IJulia)
isdefined(Base, :get_extension) ? (using JSON) : (using ..JSON)
isdefined(Base, :get_extension) ? (using PlotlyBase) : (using ..PlotlyBase)


function IJulia.display_dict(p::PlotlyJS.SyncPlot)
    Dict(
        "application/vnd.plotly.v1+json" => JSON.lower(p),
        "text/plain" => sprint(show, "text/plain", p),
        "text/html" => let
            buf = IOBuffer()
            show(buf, MIME("text/html"), p)
            String(resize!(buf.data, buf.size))
        end
    )
end

end
