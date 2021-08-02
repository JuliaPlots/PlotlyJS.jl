using Documenter
using PlotlyJS
using PlotlyBase

PlotlyJS.set_default_renderer(PlotlyJS.DOCS)

const THIS_DIR = dirname(@__FILE__)

# used in examples
using Distributions, HTTP, DataFrames, RDatasets, Colors, CSV, JSON
using Random, Dates, LinearAlgebra, DelimitedFiles

# to override display_dict below
# import Documenter.Utilities: display_dict, limitstringmime
# using Base64:stringmime

# function display_dict(p::PlotlyBase.Plot)
#     out = Dict{MIME,Any}()
#     # Always generate text/plain
#     out[MIME"text/plain"()] = limitstringmime(MIME"text/plain"(), p)
#     svg_m = MIME"image/svg+xml"()
#     out[svg_m] = stringmime(svg_m, p)
#     out
# end

# display_dict(p::PlotlyJS.SyncPlot) = display_dict(p.plot)

## handle examples
# Walk through each example in a file and get the markdown from `single_example`
function single_example_file(filename::String)
    base_fn = split(filename, ".")[1]
    start_example = "```@example $(base_fn)"
    end_example = "```"
    # Open a file to write to
    open(joinpath(THIS_DIR, "src", "examples", "$(base_fn).md"), "w") do outfile

        write_example(ex) = println(outfile, start_example, "\n", ex, "\n", end_example, "\n")

        fn_h1 = titlecase(replace(base_fn, "_" => " "))
        println(outfile, "# $(fn_h1)\n")

        # Read lines from a files
        fulltext = open(
            f -> read(f, String),
            joinpath(THIS_DIR, "..", "examples", filename),
            "r"
        )
        all_lines = split(fulltext, "\n")
        l = 1
        regex = r"^function ([^_].+?)\("
        regex_end = r"^end$"

        # find preamble
        if base_fn == "subplots"  # special case
            preamble = "using PlotlyJS, Dates\ninclude(\"../../../examples/line_scatter.jl\")"
            write_example(preamble)
        else
            first_line = findfirst(x -> match(regex, x) !== nothing, all_lines)
            if first_line !== nothing
                preamble = strip(join(all_lines[1:first_line - 1], "\n"))
                write_example(preamble)
            end
        end

        while true
            # Find next function name (break if none)
            l = findnext(x -> match(regex, x) !== nothing, all_lines, l + 1)
            if l == 0 || l === nothing
                break
            end
            # find corresponding end for this function
            end_l = findnext(x -> match(regex_end, x) !== nothing, all_lines, l + 1)

            # Pull out function text
            func_block = join(all_lines[l:end_l], "\n")
            fun_name = match(regex, all_lines[l])[1]
            # println("adding $fun_name")
            an_ex = string(func_block, "\n", fun_name, "()")
            write_example(an_ex)
            l = end_l
        end
    end  # do outfile

    return nothing
end

function handle_examples()
    @info "Updating examples!"
    # Read all file names in
    if length(ARGS) == 0
        all_file_names = readdir(joinpath(THIS_DIR, "..", "examples"))
    else
        all_file_names = [endswith(i, ".jl") ? i : "$(i).jl" for i in ARGS]
    end
    all_julia_files = filter(x -> endswith(x, ".jl"), all_file_names)

    foreach(single_example_file, all_julia_files)
end

handle_examples()

makedocs(
    sitename="PlotlyJS",
    format=Documenter.HTML(
        assets=[
           "include_plotlyjs.js"
        ]
    ),
    modules=[PlotlyJS, PlotlyBase],
    linkcheck=true,
    pages=[
        "Home" => "index.md",
        "User Guide" => [
            "Preliminaries" => "basics.md",
            "Building Blocks" => "building_traces_layouts.md",
            "Putting it together" => "syncplots.md",
            "Working with plots" => "manipulating_plots.md",
            "Contributing" => "contributing.md",
        ],
        "Examples" => [
            "3d" => "examples/3d.md",
            "Area" => "examples/area.md",
            "Bar" => "examples/bar.md",
            "Box Plots" => "examples/box_plots.md",
            "Contour" => "examples/contour.md",
            "Financial Charts" => "examples/finance.md",
            "Heatmaps" => "examples/heatmaps.md",
            "Histograms" => "examples/histograms.md",
            "Line and Scatter" => "examples/line_scatter.md",
            "Maps" => "examples/maps.md",
            "Shapes" => "examples/shapes.md",
            "Subplots" => "examples/subplots.md",
            "Tables" => "examples/tables.md",
            "Ternary" => "examples/ternary.md",
            "Time Series" => "examples/time_series.md",
            "Violin" => "examples/violin.md",
        ],
        "API Docs" => "api.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#= deploydocs(
    repo = "<repository url>"
) =#

deploydocs(
    repo="github.com/JuliaPlots/PlotlyJS.jl.git",
)
