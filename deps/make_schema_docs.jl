module PlotlyJSSchemaDocsGenerator

import Markdown
using Markdown: MD
using JSON

# methods to re-construct a plot from JSON
_symbol_dict(x) = x
_symbol_dict(d::AbstractDict) =
    Dict{Symbol,Any}([(Symbol(k), _symbol_dict(v)) for (k, v) in d])

struct SchemaAttribute
    description::Union{MD, Nothing}
    valtype::Union{String, Nothing}
    flags::Union{Vector{Any}, Nothing}
    vals::Union{Vector{Any}, Nothing}
    children::Union{Dict{Symbol,SchemaAttribute}, Nothing}
end

function SchemaAttribute(d::AbstractDict)
    role = pop!(d, :role, "")

    if role == "object" || any(_x->isa(_x, AbstractDict), values(d))
        # description and valtype ire empty, but children is not
        _desc = pop!(d, :description, "")
        desc = isempty(_desc) ? nothing : MD(_desc)
        valtype = nothing
        filter!(d) do p
            !(p[1] in (:_deprecated, :tracerefminus)) && !(startswith(string(p[1]), "_"))
        end
        kids = Dict{Symbol,SchemaAttribute}()
        for (a_k, v) in d
            isa(v, AbstractDict) || continue
            kids[a_k] = SchemaAttribute(v)
        end
        children = Dict{Symbol,SchemaAttribute}(kids)
    else
        valtype = get(d, :valType, nothing)
        desc = Markdown.parse(get(d, :description, ""))

        # children is none
        children = nothing
    end

    flags = valtype == "flaglist" ? d[:flags] : nothing
    vals = valtype == "enumerated" ? d[:values] : nothing

    SchemaAttribute(desc, valtype, flags, vals, children)
end

struct TraceSchema
    name::Symbol
    description::Union{MD, Nothing}
    attributes::Dict{Symbol,SchemaAttribute}
end

function TraceSchema(nm::Symbol, d::AbstractDict, attrs_key=:attributes)
    _attrs = filter!(p -> p[1] != :uid && p[1] != :type, d[attrs_key])
    attrs = Dict{Symbol,SchemaAttribute}()
    for (k, v) in _attrs
        isa(v, AbstractDict) || continue
        attrs[k] = SchemaAttribute(v)
    end
    desc = get(d, :description, "")
    description = isempty(desc) ? MD() : Markdown.parse(desc)
    TraceSchema(nm, description, attrs)
end

struct Schema
    traces::Dict{Symbol,TraceSchema}
    layout::TraceSchema

    function Schema()
        _path = joinpath(dirname(@__FILE__), "plotschema.json")
        schema = _symbol_dict(JSON.parse(read(_path, String)))

        traces = Dict{Symbol,TraceSchema}()
        for (k, v) in schema[:schema][:traces]
            traces[k] = TraceSchema(k, v)
        end

        layout = TraceSchema(:layout, schema[:schema][:layout], :layoutAttributes)
        new(traces, layout)
    end
end

doc_html(parent::Symbol, name::Symbol, x::Union{SchemaAttribute,TraceSchema}) =
    takebuf_string(doc_html!(IOBuffer(), parent, name, x))

function doc_html!(buf::IO, parent::Symbol, name::Symbol, sa::SchemaAttribute)
    data_parent = "$(parent)_attributes"
    id = "$(parent)_$(name)"
    print(buf,"<div class=\"panel")
    sa.children !== nothing && print(buf, " panel-info")
    print(buf, "\">")
    print(buf, """
     <div class="panel-heading">
       <h5 class="panel-title">
         <a data-toggle="collapse" data-parent="""
     )
     print(buf, "\"#", data_parent, "\" ")
     print(buf, "href=\"#", id, "\">")
     print(buf, name)
     print(buf, """</a>
        </h5>
      </div>
     """)
     println(buf, " <div id=\"", id, "\" class=\"panel-collapse collapse\">")

     # if we have a description or children, we need a panel-body
     has_body = sa.description !== nothing || sa.description !== nothing

     # add in description if we have one
     if has_body
         print(buf, "  <div class=\"panel-body\">")
     end

     if sa.description !== nothing
         println(buf, Markdown.html(sa.description))
     end

     if sa.children !== nothing
         new_parent = Symbol(string(parent), "_", string(name))
         # need to add panel-group
         print(buf, "<div class=\"panel-group\" id=\"")
         println(buf, new_parent, "_attributes", "\">")

         # recursively add in children, if any
         kids = sa.children
         for kid_name in sort!(collect(keys(kids)))
             doc_html!(buf, new_parent, kid_name, kids[kid_name])
         end

         # close panel group
         println(buf, "</div> <!-- panel-group -->")
     end

     # close body div
     has_body && println(buf, " </div>  <!-- panel-body -->")

     # close outer divs
     println(buf, " </div> <!-- panel-collapse -->")  #
     println(buf, " </div> <!-- panel -->")
     buf
end

function doc_html!(buf::IO, data_parent::Symbol, name::Symbol, ts::TraceSchema)
    id = "$(data_parent)_$(name)"
    print(buf, """
    <div class="panel panel-default">
     <div class="panel-heading">
      <h4 class="panel-title">
       <a data-toggle="collapse" """)
    print(buf, "data-parent=\"#", data_parent, "\" ")
    print(buf, "href=\"#", id, "\">")
    println(buf, name, "</a></h4></div>")

    println(buf, "<div id=\"", id, "\" class=\"panel-collapse collapse\">")
    println(buf, "<div class=\"panel-body\">")
    if ts.description !== nothing
        println(buf, Markdown.html(ts.description))
    end

    print(buf, "<div class=\"panel-group\" id=\"", name, "_attributes", "\">")

    # now add all attributes
    kids = sort!(collect(keys(ts.attributes)))
    for kid_name in kids
        doc_html!(buf, name, kid_name, ts.attributes[kid_name])
    end

    println(buf, "</div> <!-- panel-group -->")
    println(buf, "</div> <!-- panel-body -->")
    println(buf, "</div> <!-- panel-collapse -->")
    println(buf, "</div> <!-- panel -->")
    return buf
end

doc_html(s::Schema) = takebuf_string(doc_html!(IOBuffer(), s))

function doc_html!(buf::IO, s::Schema)
    println(buf,
    """<!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
      <script>
      window.jQuery = window.\$;
      </script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    </head>
    <body>""")

    println(buf,
    """
    <div class="container">
      <h2>Trace attributes</h2>
          <div class="panel-group" id="traces">
    """)

    # add traces
    for kid_name in sort!(collect(keys(s.traces)))
        doc_html!(buf, :traces, kid_name, s.traces[kid_name])
    end
    # doc_html!(buf, :traces, :scatter, s.traces[:scatter])

    println(buf, "</div> <!-- panel-group -->")
    println(buf, "</div> <!-- container -->")

    # now do layout
    println(buf,
    """
    <div class="container">
      <h2>Layout attributes</h2>
          <div class="panel-group" id="layout">
    """)
    doc_html!(buf, :layout, :layout, s.layout)

    println(buf, "</div> <!-- panel-group -->")
    println(buf, "</div> <!-- container -->")
    println(buf, "</body>")
    println(buf, "</html>")
    buf
end

open(joinpath(dirname(@__FILE__), "schema.html"), "w") do f
  doc_html!(f, Schema())
end

end  # module
