const _pkg_root = dirname(dirname(@__FILE__))
const _pkg_deps = joinpath(_pkg_root,"deps")
const _pkg_assets = joinpath(_pkg_root,"assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

function datadown(thepath, thefile, theurl)
    filepath = joinpath(thepath, thefile)
    try
        download(theurl, filepath)
    catch 
        if isfile(filepath)
            @warn("Failed to update $thefile, but you already have it. Things might continue to work, but if you would like to make sure you have the latest version of $thefile, use may use your web-browser to download it from $theurl and place it in $_pkg_deps.")
        else
            error("Failed to download $thefile from $theurl. You may use your web-browser to download it from $theurl and place it in $_pkg_deps.")
        end
    end
end

datadown(_pkg_deps, "plotschema.json",
         "https://api.plot.ly/v2/plot-schema?sha1")
datadown(_pkg_assets, "plotly-latest.min.js",
         "https://cdn.plot.ly/plotly-latest.min.js")

include("make_schema_docs.jl")
include("find_attr_groups.jl")
AttrGroups.main()
