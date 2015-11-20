using JSON
using Colors

schema = JSON.parsefile(joinpath(dirname(dirname(@__FILE__)), "deps", "plotschema.json"))

# recursively determine all unique values for a key in the Dict form of the json
get_unique!(::Any, key, the_set) = nothing

function get_unique!(d::Dict, key, the_set=Set())
    haskey(d, key) &&  push!(the_set, d[key])
    map(x->get_unique!(x, key, the_set), values(d))
    the_set
end


function verify_schema_knowledge()
    valtypes = get_unique!(schema, "valType")
    roles = get_unique!(schema, "role")
    opts = unique(vcat(get_unique!(schema["defs"]["valObjects"], "otherOpts")...))
    opts = unique(vcat(opts,
                       get_unique!(schema["defs"]["valObjects"], "requiredOpts")...))

    # make sure we don't have any roles or otherOpts we don't know about
    @assert isempty(symdiff(roles, Set(["data", "style", "info", "object"])))
    @assert isempty(symdiff(opts, ["dflt", "min", "max", "arrayOk", "noBlank",
                                   "strict", "values", "extras", "flags", "items",
                                    "coerceNumber"]))

    # make sure that valtypes is the same as the keys in our defs.valObjects:
    @assert isempty(symdiff(valtypes, collect(keys(schema["defs"]["valObjects"]))))

    valtypes, roles, opts
end

verify_schema_knowledge()

## Valtype description
abstract AbstractValType

for nm in [:_String, :_Number, :_Flaglist, :_Any, :_Geoid, :_Angle, :_Colorscale,
           :_Data_array, :_Enumerated, :_Integer, :_Info_array, :_Sceneid,
           :_Axisid, :_Color, :_Boolean, :_NotApplicable]
    @eval immutable $(nm) <: AbstractValType end
end

## opt descriptions
abstract AbstractOpt

for nm in [:_Dflt, :_Min, :_Max, :_ArrayOk, :_NoBlank, :_Strict, :_Values,
           :_Extras, :_CoerceNumber, :_Flags, :_Items]
    @eval immutable $(nm) <: AbstractOpt; value; end
end

# define the supertype for the attribute `type` based on the role
super_type(role::Symbol) = role == :data   ? :(AbstractAttribute{DataRole}) :
                           role == :info   ? :(AbstractAttribute{InfoRole}) :
                           role == :style  ? :(AbstractAttribute{StyleRole}) :
                           role == :object ? :(AbstractAttribute{ObjectRole}) :
                           error("Unknown role type $role.")

# define the root type of a field, given the `AbstractValType`
field_type(::_String)        = AbstractString
field_type(::_Number)        = Number
field_type(::_Flaglist)      = AbstractString
field_type(::_Any)           = Any
field_type(::_Geoid)         = AbstractString
field_type(::_Angle)         = Real
field_type(::_Colorscale)    = Union{String, Vector}
field_type(::_Data_array)    = Vector
field_type(::_Enumerated)    = AbstractSTring
field_type(::_Integer)       = Integer
field_type(::_Info_array)    = vector
field_type(::_Sceneid)       = AbstractString
field_type(::_Axisid)        = AbstractString
field_type(::_Color)         = Colors.Colorant
field_type(::_Boolean)       = Bool
field_type(::_NotApplicable) = error("Shouldn't have been called!")
field_type{AVT<:AbstractValType}(::Type{AVT}) = field_type(AVT())

abstract AbstractAttribueDescription
# ValAttributeDescription will be used to describe attribues whose role is one
# of data, info, style
type ValAttributeDescription{T<:AbstractOpt} <: AbstractAttribueDescription
    name::Symbol
    role::Symbol
    valType::AbstractValType
    opts::Vector{T}
    docstring::AbstractString
end

type ObjectAttributeDescription{TAD<:AbstractAttribueDescription} <: AbstractAttribueDescription
    name::Symbol
    fields::Vector{TAD}
    role::Symbol
    docstring::AbstractString
end

type TraceDescription{TAD<:AbstractAttribueDescription}
    name::Symbol
    attributes::Vector{TAD}
    layout_attributes::Vector{TAD}
    docstring::AbstractString
end

function _parse_object(name::Symbol, d::Dict)
    # remove anything deprcated. We just won't implement it
    pop!(d, "_deprecated", "")

    # extract a docstring, if any
    docstring = pop!(d, "description", "")

    # the role key is gone, so the rest of the items are all sub-attributes
    # recurse over the other items and construct descriptions
    fields = Array(AbstractAttribueDescription, length(d))
    for (i, (k, v)) in enumerate(d)
        fields[i] = parse_attr(symbol(k), v)
        pop!(d, k)  # remove it from the dict
    end

    # make sure we have parsed the entire object
    if !isempty(d)
        @show d
    end

    ObjectAttributeDescription(name, fields, :object, docstring)
end

function _parse_val(name::Symbol, d::Dict, role::Symbol)
    # remove anything deprcated. We just won't implement it
    pop!(d, "_deprecated", "")


    # parse this string to one of our valtype instances
    valtype = eval(Expr(:call, symbol("_", ucfirst(pop!(d, "valType")))))

    # grab the docstring
    docstring = pop!(d, "description", "")

    # at this point the remaining items in our dict will all be opts
    opts = Array(AbstractOpt, length(d))
    for (i, (k, v)) in enumerate(d)
        opts[i] = eval(Expr(:call, symbol("_", ucfirst(k)), v))
        pop!(d, k)  # remove it from the dict
    end

    # make sure we have parsed the entire object
    @assert isempty(d)

    ValAttributeDescription(name, role, valtype, opts, docstring)
end

# debugging helper. Method to dispatch on anything
parse_attr(name, d) = error("I have name: $name\nd: $d")

function parse_attr(name::Symbol, d::Dict)
    # remove anything deprcated. We just won't implement it
    pop!(d, "_deprecated", "")

    # make sure we really have an attribute here
    if !haskey(d, "role")
        @show name, d
        error("Not an attribute")
    end

    # parse role
    role = symbol(pop!(d, "role"))

    role == :object ? _parse_object(name, d) :
                      _parse_val(name, d, role)
end

function _parse_all_attrs(attrs::Dict)
    attributes = Array(AbstractAttribueDescription, length(attrs))
    for (i, (k, v)) in enumerate(attrs)
        attributes[i] = parse_attr(symbol(k), v)
        pop!(attrs, k)
    end
    # make sure we parsed all the attributes
    @assert isempty(attrs)
    attributes
end

function parse_trace(name::Symbol, d::Dict)
    # remove anything deprcated. We just won't implement it
    pop!(d, "_deprecated", "")

    # remove redundant `type` (this info is in `name`)

    # extract docstring
    docstring = pop!(d, "description", "")

    # parse all attributes
    attrs = pop!(d, "attributes")
    pop!(attrs, "type")
    pop!(attrs, "_deprecated", "")
    attributes = _parse_all_attrs(attrs)

    # parse all layoutAttributes
    attrs = pop!(d, "layoutAttributes", Dict())
    pop!(attrs, "_deprecated", "")
    pop!(attrs, "type", "")
    layout_attributes = _parse_all_attrs(attrs)

    # scatter3d has this strange "hrName" field. Throw it out
    pop!(d, "hrName", "")

    # make sure we parsed everything in this trace
    @assert isempty(d)

    TraceDescription(name, attributes, layout_attributes, docstring)
end

parse_traces(schema_traces::Dict) =
    TraceDescription[parse_trace(symbol(k), v) for (k, v) in schema_traces]
