# This script gets run once, on a developer's machine, to generate artifacts
using Pkg.Artifacts
using Downloads

function generate_artifacts(ver="latest", repo="https://github.com/JuliaPlots/PlotlyJS.jl")
    artifacts_toml = joinpath(dirname(@__DIR__), "Artifacts.toml")

    # if Artifacts.toml does not exist we also do not have to remove it
    isfile(artifacts_toml) && rm(artifacts_toml)

    plotschema_url = "https://api.plot.ly/v2/plot-schema?sha1"
    plotly_url = "https://cdn.plot.ly/plotly-$ver.min.js"

    plotlyartifacts_hash = create_artifact() do artifact_dir
        @show artifact_dir
        Downloads.download(plotschema_url, joinpath(artifact_dir, "plot-schema.json"))
        Downloads.download(plotly_url, joinpath(artifact_dir, "plotly.min.js"))
        cp(joinpath(dirname(@__DIR__), "datasets"), joinpath(artifact_dir, "datasets"))
    end

    tarball_hash = archive_artifact(plotlyartifacts_hash, "plotly-artifacts-$ver.tar.gz")

    bind_artifact!(artifacts_toml, "plotly-artifacts", plotlyartifacts_hash; download_info=[
        ("$repo/releases/download/plotly-artifacts-$ver/plotly-artifacts-$ver.tar.gz", tarball_hash)
    ])
end
