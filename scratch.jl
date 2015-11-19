using JSON

js_dict = JSON.parsefile(joinpath(dirname(@__FILE__), "deps", "plotschema.json"))

# recursively determine all unique values for a key in the Dict form of the json
get_unique!(::Any, key, the_set) = nothing

function get_unique!(d::Dict, key, the_set=Set())
    haskey(d, key) &&  push!(the_set, d[key])
    map(x->get_unique!(x, key, the_set), values(d))
    the_set
end

valtypes = get_unique!(js_dict, "valType")
defaults = get_unique!(js_dict, "dflt")
roles = get_unique!(js_dict, "role")
