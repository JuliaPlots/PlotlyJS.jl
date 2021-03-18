# This script gets run once, on a developer's machine, to generate artifacts
using Pkg.Artifacts
using SHA

artifacts_toml = joinpath(dirname(@__DIR__), "Artifacts.toml")

rm(artifacts_toml,force=true)

plotschema_url = "https://api.plot.ly/v2/plot-schema?sha1"
plotly_url = "https://cdn.plot.ly/plotly-latest.min.js"

plotlyartifacts_hash = create_artifact() do artifact_dir
    download(plotschema_url, joinpath(artifact_dir, "plotschema.json"))
    download(plotly_url, joinpath(artifact_dir, "plotly-latest.min.js"))
end

artifact_dir = artifact_path(plotlyartifacts_hash)
bind_artifact!(artifacts_toml, "plotly-artifacts", plotlyartifacts_hash; download_info = [
    (plotschema_url, bytes2hex(sha256(read(joinpath(artifact_dir, "plotschema.json"))))),
    (plotly_url, bytes2hex(sha256(read(joinpath(artifact_dir, "plotly-latest.min.js"))))),
])

archive_artifact(plotlyartifacts_hash, "plotly-artifacts.tar.gz")
