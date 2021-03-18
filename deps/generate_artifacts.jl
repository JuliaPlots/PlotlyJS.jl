# This script gets run once, on a developer's machine, to generate artifacts
using Pkg.Artifacts

artifacts_toml = joinpath(dirname(@__DIR__), "Artifacts.toml")

rm(artifacts_toml)

plotschema_url = "https://api.plot.ly/v2/plot-schema?sha1"
plotly_url = "https://cdn.plot.ly/plotly-latest.min.js"

plotlyartifacts_hash = create_artifact() do artifact_dir
    download(plotschema_url, joinpath(artifact_dir, "plot-schema.json"))
    download(plotly_url, joinpath(artifact_dir, "plotly.min.js"))
end

tarball_hash = archive_artifact(plotlyartifacts_hash, "plotly-artifacts.tar.gz")

bind_artifact!(artifacts_toml, "plotly-artifacts", plotlyartifacts_hash; download_info = [
    ("https://github.com/jonas-kr/PlotlyJS.jl/releases/download/plotly-artifacts/plotly-artifacts.tar.gz", tarball_hash)
])
