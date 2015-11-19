## Parsing

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
type Opacity <: AbstractValueAttribute
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
type Visible <: AbstractValueAttribute
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
abstract TextElement <: AbstractAttribute

type FontSize <: TextElement
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

type TextFont <: AbstractObjectAttribute
    family::ASCIIString
    size::FontSize
    color::Colors.Colorant
end
```

So we created a new `abstract` subtype of `AbstractAttribute` to represent all our `TextElements`. Then we needed a custom type for the `fontsize` to enforce the minimum constraint.

## Generation

We now understand how the parsing happens. Next we turn to how the types are generated.

### Comments

Notice that for each subtype `ST` of `AbstractValueAttribute`, where the `value` field has type `T` we defined a method:

```julia
convert(::Type{ST}, x::T) = ST(x)
```

The reason we need this method is that we would like users to be able to change the value directly with "dot-notaion" without having to worry about whether the value sits in a custom or native Julia type.

For example, suppose we have a `Scatter` trace named `s`. If we wanted to change the opacity to `0.5` and didn't have this method, we would need to call

```julia
s.opacity.value = 0.5
```

This is bad for at least two reasons:

1. Sometimes we won't have custom types, in which case we will not have a `.value` field to set. We don't want users to have to think about whether or not they need to append a `.value` before changing an attribute.
2. We completely bypass the constraint checks imposed in the inner constructors -- often the only reason we make custom types to begin with.

Instead what happens when we do have this method and call `s.opacity = 0.5` is roughly equivalent to `s.opacity = Opacity(0.5)`. This solves both the problems above: the user doesn't have to think about `.value` and we have to go through our inner constructor when changing the value of the field.

<!-- TODO: describe how we generate type definitions -->


<!-- TODO: Need to handle `arrayOk` as Union{T,Vector{T}} -->
