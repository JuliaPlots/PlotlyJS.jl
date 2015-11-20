# Parsing

## `role`s

We need to look at the `role` tag on each attribute to determine how to set it up.

This tag only takes on one of 4 values: `data`, `info`, `style`, `object`.  For the first three, we can usually map them directly into native types *or* custom types with a single field named `value`. Some examples are


### `data`

```json
"x": {
    "valType": "data_array",
    "description": "Sets the x coordinates.",
    "role": "data"
},
```

In Julia we just have `x::Vector` as the field

### `style`

```json
"opacity": {
    "valType": "number",
    "role": "style",
    "min": 0,
    "max": 1,
    "dflt": 1,
    "description": "Sets the opacity of the trace."
},
```

In order to enforce the min/max constraints we use a custom type. The field we add is `opacity::Opacity`, where the type is defined as

```julia
type Opacity <: AbstractAttribute{StyleRole}
    value::Float16

    function Opacity(x::Float16=1)
        if !(x >= 0 && x <= 1)
            msg = "This object must be >= 0 and <= 1 the values"
            error(msg)
        end
        new(x)
    end
end
Base.convert(::Type{Opacity}, x::Real) = Opacity(Float16(x))
```

### `info`

```json
"visible": {
    "valType": "enumerated",
    "values": [
        true,
        false,
        "legendonly"
    ],
    "role": "info",
    "dflt": true,
    "description": "Determines whether or not this trace is visible. If *legendonly*, the trace is not drawn, but can appear as a legend item (provided that the legend itself is visible)."
},
```

This time we to enforce that the value belongs to the enumerated set. To do this we add a field `visible::Visible`, where

```julia
type Visible <: AbstractAttribute{InfoRole}
    value

    function Visible(x=true)
        validvalues = [true, false, "LegendOnly"]
        if !(x ∈ validvalues)
            throw_enumerate_error(validvalues)
        end
        new(x)
    end
end
Base.convert(::Type{Visible}, x::Union{Bool,ASCIIString}) = Visible(x)
```

### `object`

Things are a bit trickier when we have `role == object`. In this case what we have been doing is breaking down the object into many smaller types based on the above rules. Here's an example

```json
"textfont": {
    "family": {
        "valType": "string",
        "role": "style",
        "noBlank": true,
        "strict": true,
        "arrayOk": true
    },
    "size": {
        "valType": "number",
        "role": "style",
        "min": 1,
        "arrayOk": true
    },
    "color": {
        "valType": "color",
        "role": "style",
        "arrayOk": true
    },
    "description": "Sets the text font.",
    "role": "object",
},
```

Here we decided to do the following:

```julia
type FontSize <: AbstractAttribute{StyleRole}
    value::Float16

    function FontSize(x::Float16)
        if x < 1.0
            error("Text size must be greater than 1")
        end

        new(x)
    end
end
FontSize(x::Number=12) = FontSize(Float16(x))
Base.convert(::Type{FontSize}, x::Real) = FontSize(Float16(x))

type TextFont <: AbstractAttribute{ObjectRole}
    family::ASCIIString
    size::FontSize
    color::Colors.Colorant
end
```

We needed a custom type for the `fontsize` to enforce the minimum constraint.

## `valType`s

Each attribute in the schema has a `valType`. This, as you might expect, specifies the type of the attribute. Each of these `valType`s is defined in the `defs.valObjects` section of the schema. Below is a list of all the possible `valType`s in the schema and a short description of how we think about them in Julia:

- `string`: a string. In Julia this would have a type `AbstractString`
- `number`: a number. Represented in Julia as `Number`
- `flaglist`: A string representing a combination of flags (order independent). Different available `flags` with `+` (e.g. `x+y`). Represented as an `AbstractString`
- `any`: anything. Represented in Julia as `Any`
- `geoid`: A geoid string (e.g. `geo`, or `geo1`). `AbstractString` in Julia
- `angle`: A number between -180 and 180. A `Real` in Julia
- `colorscale`: This one is long, so I quote the schema:

>A Plotly colorscale either picked by a name: (any of Greys, YIGnBu, Greens, YIOrRd, Bluered, RdBu, Reds, Blues, Picnic, Rainbow, Portland, Jet, Hot, Blackbody, Earth, Electric, Viridis ) customized as an {array} of 2-element {arrays} where the first element is the normalized color level value (starting at *0* and ending at *1*), and the second item is a valid color string.

Represented as `T<:Real, Union{String, Vector{Tuple{T, String}}}`

- `data_array`: a 1d array. Julia's `Vector`
- `enumerated`: a object of any type that takes on one of a finite set of values. Just `Any` in Julia as we don't have information on the types of the enumeration (see `scatter.visible` for an example where this could be `Bool` or `ASCIIString`)
- `integer`: an integer. Julia `Int`
- `info_array`: just some array of plot info. `Vector` in Julia
- `sceneid`: a scene id string (e.g. `scene`, or `scene1`). `AbstractString` in Julia
- `axisid`: an axis id string (e.g. 'x', 'x2', 'x3', ...). `AbstractString` in Julia
- `color`: a string describing a color. In Julia we use `Colors.Colorant` and convert to a HEX string when sending to JSON
- `boolean`: simply `Bool`

## `opts`

Each attribute has associated with it a number of options, which we will call `opts`. For specific `valType`s some of these are required, some are optional, and some are not applicable (see `defs.valObjects`).

Below is a list of all possible `opts` that might be present in the specification of the attribute and a short description of how this impacts our codegen:

- `dflt`: what is the default argument. Here we set the default arg on the constructor
- `min`: minimim allowable value. Applies only to numeric objects. The precense of this field triggers the creation of a one field type, where the field is typed to be a `::Number` and an inner constructor is created to enforce the lower bound on the input. If present without `max`, `max` is implicitly set to `Inf`.
- `max`: same as `min`, but for upper bound. If present without `min`, `min` is implicitly set to `-Inf`.
- `arrayOk`: specifies that the field can take one value, or many in an array. This will trigger a `Union{T, Vector{T}}` type constraint on the field and will require elementwise constraint checking.
- `noBlank`: specifies that a particular field is required. By default, all fields that should be of type `T`, are actually given type `Union{T,Void}` and a default value of `nothing`. However, if `noBlank` is present the type remains `T` and no default value is provided.
- `strict`: always used in conjunction with a `string` `valType`. TODO: Still don't know what it does. Use in source code [here](https://github.com/plotly/plotly.js/blob/734f75fdb9ccd6ca362c0b01b632f01eb2c0066e/src/lib/coerce.js#L101)
- `values`: always used in conjunction with an `enumerated` `valType`. It describes the set of feasible values.
- `extras`: always used in conjunction with an `flaglist` `valType`. This specifies additional possibilities for the value, but these cannot be arbitrarily combined with the items in the `flags` field. Triggers additional constraint checks in the inner constructor
- `coerceNumber`: the field must be a number. All this does is trigger a `::Number` type constraint on the field

## Generation

We now understand how the parsing happens. Next we turn to how the types are generated.

We perform type generation using "factory" functions. These are functions that take a description of the type to be generated (more on this later) and return an `Expr` containing the type definition and other auxiliary functions.

The behavior of a factory is driven by the combination of the attribute name, the role, the `valType`, and the collection of `opts`:

- Name determines the name of the type. We will use `ucfirst(name)` to get the name of the Julia type
- `role` determines the type parameter of `AbstractAttribute`. Specifically, we have

```julia
abstract AbstractAttributeRole
abstract AbstractValRole <: AbstractAttributeRole
immutable DataRole <: AbstractValRole end
immutable InfoRole <: AbstractValRole end
immutable StyleRole <: AbstractValRole end
immutable ObjectRole <: AbstractAttributeRole end

abstract AbstractAttribute{Role} <: AbstractPlotlyElement
```

which map in a rather obvious way to the roles `data`, `info`, `style`, `object`

- `valType` determines the type of the field for `data`, `info`, or `style` attributes and will be empty/ignored for `object` attributes
- The `opts` will drive the behavior of the body of constructors and may also impact the field type. For example, the constructor body will be adjusted to enforce constraints on the fields as specified by the opts `max`, `min`, `values`, and `extras`.

### Comments

#### Duplication

Many traces have attributes with the same name. For example, notice that scatter has both `line` and `marker.line`. We could generate different types for every occurrence of `line`, but this would have at least 2 problems: (1) there would probably be duplicate type definitions (2) there is a naming issue where users would have to think about types `ScatterLine` and `ScatterMarkerLine`.

Below we summarize our strategy for minimizing duplication, yet making the API natural and easy to understand:

- We will parse the entire `traces` section of the schema and collect all attribute names and descriptions
- We will then go through that list and for every attribute name, we will keep only unique descriptions of that attribute
- We can then generate only these "unique" descriptions using a numbering system for naming. For example, if we ended up with 3 distinct descriptions of a `line` attribute, we would generate `Line1`, `Line2`, and `Line3`. Part of this step is making sure that the type constraint on the fields of the trace line up with the properly numbered attribute type
- Then we create one "superset" type for each attributes that has the same name as the attribute, but its fields are the union of all fields in the list of unique descriptions.
- Finally we define a method `convert(::Type{AttributeNameN}, x::AttributeName)` that converts from our superset type to the numbered types automatically whenever the numbered type is required. A simple example of how this works is in `temp/convert_magic.jl`.

This has 3 desirable properties:

1. We always have the proper context dependent fields for all trace attributes
2. The user doesn't have to think about which `AttributeNameN` to use -- they will only be using the superset type `AttributeName`.
3. The generated JSON for an instance of the trace type will never have redundant or un-used fields.

#### Convert

Notice that for each subtype `ST` of `AbstractValueAttribute`, where the `value` field has type `T` we defined a method:

```julia
convert(::Type{ST}, x::T) = ST(x)
```

The reason we need this method is that we would like users to be able to change the value directly with "dot-notaion" without having to worry about whether the value sits in a custom or native Julia type.

For example, suppose we have a `Scatter` trace named `s`. If we wanted to change the opacity to `0.5`. If we didn't have this method we would need to call

```julia
s.opacity.value = 0.5
```

This is bad for at least two reasons:

1. Sometimes we won't have custom types, in which case we will not have a `.value` field to set. We don't want users to have to think about whether or not they need to append a `.value` before changing an attribute.
2. We completely bypass the constraint checks imposed in the inner constructors -- often the only reason we make custom types to begin with.

Instead what happens when we do have this method and call `s.opacity = 0.5` is roughly equivalent to `s.opacity = Opacity(0.5)`. This solves both the problems above: the user doesn't have to think about `.value` and we have to go through our inner constructor when changing the value of the field.

<!-- TODO: describe how we generate type definitions -->


<!-- TODO: Need to handle `arrayOk` as Union{T,Vector{T}} -->
