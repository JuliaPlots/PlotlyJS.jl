using JSON

js_dict = JSON.parsefile(joinpath(dirname(@__FILE__, "deps", "plotschema.json")))

# recursively determine all unique values for a key in the Dict form of the json
get_unique(::Any, key, the_set) = nothing

function get_unique!(d::Dict, key, the_set=Set())
    haskey(d, key) &&  push!(the_set, d[key])
    map(x->get_unique(x, key, the_set), values(d))
    return the_set
end

valtypes = get_unique!(js_dict, "valType")
defaults = get_unique!(js_dict, "dflt")

immutable Angle
    x::Float16

    function Angle(x::Float64)
        (x < -180 || x > 180) && error("Angle must be between -180 and 180")
        new(x)
    end
end
