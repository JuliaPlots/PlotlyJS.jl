!isdir("../assets") && mkdir("../assets")

cd(dirname(@__FILE__)) do
    download("https://api.plot.ly/v2/plot-schema?sha1", "plotschema.json")
    download("https://cdn.plot.ly/plotly-latest.min.js", "../assets/plotly-latest.min.js")
end

include("make_schema_docs.jl")
include("find_attr_groups.jl")
AttrGroups.main()
