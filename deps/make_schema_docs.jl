module PlotlyJSSchemaDocsGenerator

using Base.Markdown: MD
using JSON

# methods to re-construct a plot from JSON
_symbol_dict(x) = x
_symbol_dict(d::Associative) =
    Dict{Symbol,Any}([(Symbol(k), _symbol_dict(v)) for (k, v) in d])

immutable SchemaAttribute
    description::Nullable{MD}
    valtype::Nullable{String}
    flags::Nullable{Vector{Any}}
    vals::Nullable{Vector{Any}}
    children::Nullable{Dict{Symbol,SchemaAttribute}}
end

function SchemaAttribute(d::Associative)
    role = pop!(d, :role, "")

    if role == "object" || any(_->isa(_, Associative), values(d))
        # description and valtype ire empty, but children is not
        _desc = pop!(d, :description, "")
        desc = isempty(_desc) ? Nullable{MD}() : Nullable{MD}(MD(_desc))
        valtype = Nullable{String}()
        filter!(d) do k, v
            !(k in (:_deprecated, :tracerefminus)) && !(startswith(string(k), "_"))
        end
        kids = Dict{Symbol,SchemaAttribute}()
        for (a_k, v) in d
            isa(v, Associative) || continue
            kids[a_k] = SchemaAttribute(v)
        end
        children = Nullable{Dict{Symbol,SchemaAttribute}}(kids)
    else
        valtype = Nullable{String}(get(d, :valType, Nullable{String}()))
        desc = Nullable{MD}(
            Base.Markdown.parse(get(d, :description, ""))
        )

        # children is none
        children = Nullable{Dict{Symbol,SchemaAttribute}}()
    end

    flags = valtype == "flaglist" ? Nullable{Vector{Any}}(d["flags"]) :
                                    Nullable{Vector{Any}}()

    vals = valtype == "enumerated" ? Nullable{Vector{Any}}(d["values"]) :
                                       Nullable{Vector{Any}}()

    SchemaAttribute(desc, valtype, flags, vals, children)
end

immutable TraceSchema
    name::Symbol
    description::Nullable{MD}
    attributes::Dict{Symbol,SchemaAttribute}
end

function TraceSchema(nm::Symbol, d::Associative, attrs_key=:attributes)
    _attrs = filter!((k, v) -> k != :uid && k != :type, d[attrs_key])
    attrs = Dict{Symbol,SchemaAttribute}()
    for (k, v) in _attrs
        isa(v, Associative) || continue
        attrs[k] = SchemaAttribute(v)
    end
    desc = get(d, :description, "")
    description = isempty(desc) ? Nullable{MD}(MD()) :
                                  Nullable{MD}(Base.Markdown.parse(desc))
    TraceSchema(nm, description, attrs)
end

immutable Schema
    traces::Dict{Symbol,TraceSchema}
    layout::TraceSchema

    function Schema()
        schema = _symbol_dict(JSON.parsefile(joinpath(dirname(@__FILE__),
                                                      "plotschema.json")))
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
    !isnull(sa.children) && print(buf, " panel-info")
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
     has_body = !isnull(sa.description) || !isnull(sa.description)

     # add in description if we have one
     if has_body
         print(buf, "  <div class=\"panel-body\">")
     end

     if !isnull(sa.description)
         println(buf, Base.Markdown.html(get(sa.description)))
     end

     if !isnull(sa.children)
         new_parent = Symbol(string(parent), "_", string(name))
         # need to add panel-group
         print(buf, "<div class=\"panel-group\" id=\"")
         println(buf, new_parent, "_attributes", "\">")

         # recursively add in children, if any
         kids = get(sa.children)
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
    if !isnull(ts.description)
        println(buf, Base.Markdown.html(get(ts.description)))
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
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
      <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
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
