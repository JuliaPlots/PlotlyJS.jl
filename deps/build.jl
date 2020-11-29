const _pkg_root = dirname(dirname(@__FILE__))
const _pkg_deps = joinpath(_pkg_root,"deps")
const _pkg_assets = joinpath(_pkg_root,"assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

include("make_schema_docs.jl")
include("find_attr_groups.jl")
AttrGroups.main()
