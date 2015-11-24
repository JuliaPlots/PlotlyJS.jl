module GeneratePlotly
using JSON
using Colors
import Base: ==

# the following type definitions need to be bootstrapped. They are part of both
# the codegen stage and the final package. So we will quote them so we can
# put them back in final pacakge, but will also eval them here
bootstrap = quote
    abstract AbstractPlotlyElement
    abstract AbstractAttributeRole
    abstract AbstractValRole <: AbstractAttributeRole
    immutable DataRole <: AbstractValRole end
    immutable InfoRole <: AbstractValRole end
    immutable StyleRole <: AbstractValRole end
    immutable ObjectRole <: AbstractAttributeRole end

    # abstract AbstractAttribute{Role,ValType} <: AbstractPlotlyElement
    # NOTE: make ValType Void for ObjectRole
    abstract AbstractAttribute{Role} <: AbstractPlotlyElement

    abstract AbstractTrace <: AbstractPlotlyElement
    abstract AbstractLayout <: AbstractPlotlyElement

    # TODO: fill these in so they print properly
    type FlaglistError <: Exception
        flags
    end

    type EnumerateError <: Exception
        values
    end
end
eval(bootstrap)

# ----------- #
# Load Schema #
# ----------- #
schema = JSON.parsefile(joinpath(dirname(dirname(@__FILE__)), "deps", "plotschema.json"))

# -------------------------------- #
# Check that we consider all cases #
# -------------------------------- #
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
    true
end

verify_schema_knowledge()

# --------------------------------------- #
# Types to represent valTypes and options #
# --------------------------------------- #
## Valtype description
abstract AbstractValType

for nm in [:_String, :_Number, :_Flaglist, :_Any, :_Geoid, :_Angle, :_Colorscale,
           :_Data_array, :_Enumerated, :_Integer, :_Info_array, :_Sceneid,
           :_Axisid, :_Color, :_Boolean, :_NotApplicable]
    @eval immutable $(nm) <: AbstractValType end
end

Base.isless{S<:AbstractValType,T<:AbstractValType}(::S, ::T) = string(S) < string(T)

## opt descriptions
abstract AbstractOpt

for nm in [:_Dflt, :_Min, :_Max, :_ArrayOk, :_NoBlank, :_Strict, :_Values,
           :_Extras, :_CoerceNumber, :_Flags, :_Items]
    @eval immutable $(nm) <: AbstractOpt; value; end
end

# defining `isless` lets us sort a vector of AbtractOpt. Implementation
# here just sorts alphabetically based on type name
Base.isless{S<:AbstractOpt,T<:AbstractOpt}(::S, ::T) = string(S) < string(T)

# equality checks
=={T<:AbstractOpt, S<:AbstractOpt}(::T, ::S) = false

function =={T<:AbstractOpt}(o1::T, o2::T)
    v1 = o1.value
    v2 = o2.value
    eltype1 = typeof(v1)
    eltype2 = typeof(v2)

    eltype1 <: Array && eltype2 <: Array ? v1 .== v2 : v1 == v2
end


# --------------------------- #
# Attribute description types #
# --------------------------- #
abstract AbstractAttribueDescription

# ValAttributeDescription will be used to describe attribues whose role is one
# of data, info, style
type ValAttributeDescription{T<:AbstractValType,S<:AbstractOpt} <: AbstractAttribueDescription
    name::Symbol
    role::Symbol
    valType::T
    opts::Vector{S}
    docstring::AbstractString
end

function Base.isless{A<:AbstractValType,B<:AbstractValType}(::ValAttributeDescription{A},
                                                            ::ValAttributeDescription{B})
    string(A) < string(B)
end

=={T,S}(v1::ValAttributeDescription{T}, v2::ValAttributeDescription{S}) = false
function =={T}(v1::ValAttributeDescription{T}, v2::ValAttributeDescription{T})
    !(v1.name == v2.name && v1.role == v2.role) && return false
    !(strip(v1.docstring) == strip(v2.docstring)) && return false

    # if we made it here we just need to compare all the options.
    # first compare lengths, then compare elementwise with map
    length(v1.opts) == length(v2.opts) || false
    length(v1.opts) == 0 && true  # if no opts, just return ;)
    all(map(==, sort(v1.opts), sort(v2.opts)))
end

type ObjectAttributeDescription{TAD<:AbstractAttribueDescription} <: AbstractAttribueDescription
    name::Symbol
    fields::Vector{TAD}
    role::Symbol
    docstring::AbstractString
end

# similar to above, see comments there
function ==(o1::ObjectAttributeDescription, o2::ObjectAttributeDescription)
    !(o1.name == o2.name && o1.role == o2.role) && return false
    !(strip(o1.docstring) == strip(o2.docstring)) && return false

    length(o1.fields) == length(o2.fields) || false
    length(o1.fields) == 0 && true
    all(map(==, sort(o1.fields), sort(o2.fields)))
end


type TraceDescription{TAD<:AbstractAttribueDescription}
    name::Symbol
    attributes::Vector{TAD}
    layout_attributes::Vector{TAD}
    docstring::AbstractString
end

type LayoutDescription{TAD<:AbstractAttribueDescription}
    layout_attributes::Vector{TAD}
end

# ------- #
# Parsing #
# ------- #
function _parse_object(name::Symbol, d::Dict)
    # remove anything deprcated. We just won't implement it
    pop!(d, "_deprecated", "")

    # extract a docstring, if any
    docstring = pop!(d, "description", "")

    # some layout object attributes have a _isSubplotObj. We don't do anything
    # with this, so we throw it out
    pop!(d, "_isSubplotObj", "")

    # the role key is gone, so the rest of the items are all sub-attributes
    # recurse over the other items and construct descriptions
    fields = Array(AbstractAttribueDescription, length(d))
    for (i, (k, v)) in enumerate(d)
        fields[i] = parse_attr(symbol(k), v)
        pop!(d, k)  # remove it from the dict
    end

    # make sure we have parsed the entire object
    @assert isempty(d) "on name: $name and d is not empty: $d"

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
    @assert isempty(d) "on name: $name and d is not empty: $d"

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
        attributes[i] = parse_attr(symbol(ucfirst(k)), v)
        pop!(attrs, k)
    end
    # make sure we parsed all the attributes
    @assert isempty(attrs)
    attributes
end

function parse_trace(name::Symbol, d::Dict)
    # remove anything deprcated. We just won't implement it
    pop!(d, "_deprecated", "")

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
    @assert isempty(d) "on name: $name and d is not empty: $d"

    TraceDescription(name, attributes, layout_attributes, docstring)
end

parse_traces(schema_traces::Dict) =
    TraceDescription[parse_trace(symbol(k), v) for (k, v) in schema_traces]


function parse_layout(d::Dict)
    # remove anything deprcated. We just won't implement it
    pop!(d, "_deprecated", "")

    # parse all layoutAttributes
    attrs = pop!(d, "layoutAttributes", Dict())
    pop!(attrs, "_deprecated", "")
    pop!(attrs, "type", "")

    # TOOD: shapes and annotations doen't really follow the pattern everything
    # else does. I just special cased them here, but even still they aren't
    # represented exactly as in the schema. What we do is
    layout_attributes = AbstractAttribueDescription[]
    for key in ("annotations", "shapes")
        v = pop!(attrs, key)
        sym = symbol(key[1:end-1])
        inner = parse_attr(sym, v["items"][string(sym)])
        single = AbstractAttribueDescription[inner]
        final = ObjectAttributeDescription(symbol(key), single, :object, "")
        push!(layout_attributes, final)
    end

    # parse the rest of the attributes
    layout_attributes = vcat(_parse_all_attrs(attrs), layout_attributes)

    # make sure we parsed everything in this trace
    @assert isempty(d) "on name: $name and d is not empty: $d"

    LayoutDescription(layout_attributes)
end

# ---------------------------------- #
# Map from valtype and role to Types #
# ---------------------------------- #
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
field_type(::_Colorscale)    = Union{AbstractString, Vector}
field_type(::_Data_array)    = Vector
field_type(::_Enumerated)    = AbstractString
field_type(::_Integer)       = Integer
field_type(::_Info_array)    = Vector
field_type(::_Sceneid)       = AbstractString
field_type(::_Axisid)        = AbstractString
field_type(::_Color)         = Union{Colors.Colorant, AbstractString}
field_type(::_Boolean)       = Bool
field_type(::_NotApplicable) = error("Shouldn't have been called!")
field_type{AVT<:AbstractValType}(::Type{AVT}) = field_type(AVT())

function field_type{T<:AbstractValType}(spec::ValAttributeDescription{T})
    # if an _ArrayOk instance is in the opts, need to adjust the field_type
    # to be a Union, otherwise fall back to field_type(T)
    ft = field_type(T)

    opt_array_ok = filter(x->isa(x, _ArrayOk), spec.opts)
    opt_no_blank = filter(x->isa(x, _NoBlank), spec.opts)

    no_blank = !isempty(opt_no_blank) && opt_no_blank[1].value
    no_arrays = isempty(opt_array_ok) || !(opt_array_ok[1].value)

    # if we have a _NoBlank, we can't union with void
    if no_arrays && no_blank
        return ft
    elseif no_arrays && !no_blank
        return Union{ft, Void}
    elseif !no_arrays && no_blank
        return Union{ft, Vector}
    else
        return Union{ft, Vector, Void}
    end

end

# ------------ #
# Codegen time #
# ------------ #
#=
NOTES

The inner_constructor will dispatch on the valType and have different behavior
based on the `opts` are in the spec

In each case we make sure to check the `requiredOpts` and `otherOpts` fields of
the defs.valObjects array so that we cover all possible options.

=#

# generic inner_constructor to simply set default argument to nothing used for
# _Data_array, _Boolean, _Any, _Color, _Colorscale, _Axisid, _Sceneid, _Geoid
inner_constructor{T<:AbstractValType}(spec::ValAttributeDescription{T}) =
    :($(spec.name)(x::$(field_type(spec))=nothing) = new(x))

function inner_constructor(spec::ValAttributeDescription{_Angle})
    quote
        function $(spec.name)(x::$(field_type(spec))=nothing)
            if !(-180 <= x && x <= 180)
                error("Angle must be between -180 and 180")
            end
            new(x)
        end
    end
end

function inner_constructor(spec::ValAttributeDescription{_Enumerated})
    # _ArrayOk is optional, so build validation expression beforehand based
    # on the presence of _ArrayOk
    array_ok = !isempty(filter(x-> isa(x, _ArrayOk), spec.opts))

    validate_expr = array_ok ? :(all([i ∈ validvalues for i in x])) :
                                :(x ∈ validvalues)

    quote
        function $(spec.name)(x::$(field_type(spec))=nothing)
            # _Values is required
            validvalues = $(filter(_ -> isa(_, _Values), spec.opts)[1].value)

            if !(x === nothing) && !($validate_expr)
                # TODO: replace with throw(EnumerateError(validvalues))
                throw_enumerate_error(validvalues)
            end
            new(x)
        end
    end
end

function inner_constructor(spec::ValAttributeDescription{_Flaglist})
    # _Extras is optional, so build validation expression beforehand based
    # on the presence of _Extras
    opt_extras = filter(x-> isa(x, _Extras), spec.opts)
    has_extras = !isempty(opt_extras)

    if has_extras
        validate_expr = :(split(x, "+") ⊆ flags || x ∈ $(opt_extras[1].value))
    else
        validate_expr = :(split(x, "+") ⊆ flags)
    end

    quote
        function $(spec.name)(x::$(field_type(spec))=nothing)
            # _Flags is required
            flags = $(filter(_ -> isa(_, _Flags), spec.opts)[1].value)
            x = replace(x, " ", "")

            if !(x === nothing) && !($validate_expr)
                # TODO: replace with throw(FlaglistError(flags))
                throw_flaglist_error(flags)
            end
            new(x)
        end
    end
end

function inner_constructor{T<:Union{_Number,_Integer}}(spec::ValAttributeDescription{T})
    # _ArrayOk is optional, but we can handle the case with broadcasting
    # comparison operations, so we don't need to change behavior here

    # min max are both optional also, so be careful about handling them
    opt_min = filter(x -> isa(x, _Min), spec.opts)
    opt_max = filter(x -> isa(x, _Max), spec.opts)

    min_check = isempty(opt_min) ? true : :(all($(opt_min[1].value) .<= x))
    max_check = isempty(opt_max) ? true : :(all($(opt_max[1].value) .>= x))

    validate_expr = :($min_check && $max_check)

    err_msg = string("Input out of bounds, should be ∈",
                     isempty(opt_min) ? "(-∞, " : "($(opt_min[1].value), ",
                     isempty(opt_min) ? "∞)" : "$(opt_max[1].value))", )

    quote
        function $(spec.name)(x::$(field_type(spec))=nothing)
            if !(x === nothing) && !($validate_expr)
                error($err_msg)
            end
            new(x)
        end
    end
end

function inner_constructor(spec::ValAttributeDescription{_String})
    # _ArrayOk is optional
    opt_array_ok = filter(x->isa(x, _ArrayOk), spec.opts)
    array_ok = !isempty(opt_array_ok) && opt_array_ok[1].value

    # values optional
    opt_values = filter(x->isa(x, _Values), spec.opts)
    has_values = !isempty(opt_values)

    validvalues_expr = has_values ? :(validvalues = $(filter(_ -> isa(_, _Values), spec.opts)[1].value)) : nothing

    # noBlank optional
    opt_no_blank = filter(x->isa(x, _NoBlank), spec.opts)
    no_blank = !isempty(opt_no_blank) && opt_no_blank[1].value

    # build expression for argument to constructor. Will include default value
    # of `nothing` if !no_blank
    arg_expr = no_blank ? :(x::$(field_type(spec))) : :(x::$(field_type(spec))=nothing)

    # create the values part of the validate expresion
    if array_ok && has_values
        values_validate = :(all([i ∈ validvalues for i in x]))
    elseif !array_ok && has_values
        values_validate = :(x ∈ validvalues)
    else
        values_validate = :(true)
    end

    # create the no_blank part of the validate expression
    blank_validate = no_blank ? :(!isempty(x)) : true

    # put the validation expressions together
    validate_expr = :($values_validate && $blank_validate)

    quote
        function $(spec.name)($(arg_expr))
            $validvalues_expr

            if !(x === nothing) && !($validate_expr)
                error("Invalid string input")
            end
            new(x)
        end
    end
end

# TODO: implement inner_constructor for _Info_array


function gen_type{T<:AbstractValType}(spec::ValAttributeDescription{T})
    quote
        type $(spec.name) <: $(super_type(spec.role))
            value::$(field_type(spec))

            $(inner_constructor(spec))
        end

        Base.convert(::Type{$(spec.name)}, x::$(field_type(spec))) = $(spec.name)(x)
        Base.writemime(io::IO, ::MIME"text/plain", x::$(spec.name)) =
            print(io, json(x, 2))
    end
end


# spec = parse_attr(:Visible, deepcopy(schema["traces"]["scatter"]["attributes"]["visible"]))
# spec = parse_attr(:Legendgroup, deepcopy(schema["traces"]["scatter"]["attributes"]["marker"]["symbol"]))
# spec = parse_attr(:Showlegend, deepcopy(schema["traces"]["scatter"]["attributes"]["showlegend"]))
# spec = parse_attr(:Opacity, deepcopy(schema["traces"]["scatter"]["attributes"]["opacity"]))
# spec = parse_attr(:Opacity, deepcopy(schema["traces"]["scatter"]["attributes"]["marker"]["colorbar"]["nticks"]))
# spec = parse_attr(:Legendgroup, deepcopy(schema["traces"]["scatter"]["attributes"]["legendgroup"]))
# spec = parse_attr(:Legendgroup, deepcopy(schema["traces"]["scatter"]["attributes"]["stream"]["token"]))
# spec = parse_attr(:Legendgroup, deepcopy(schema["traces"]["scatter"]["attributes"]["text"]))
# spec = parse_attr(:Legendgroup, deepcopy(schema["traces"]["scatter"]["attributes"]["line"]["dash"]))
# spec = parse_attr(:Visible, deepcopy(schema["traces"]["scatter"]["attributes"]["hoverinfo"]))
# print(gen_type(spec))

#
#
#
# open("../its_alive.jl", "w") do f
#     print(f, string(ex))
# end
