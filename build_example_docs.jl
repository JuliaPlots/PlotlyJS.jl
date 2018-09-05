#=
This file takes the code from each file in the examples folder and
creates a markdown file of the same name as the julia file then
puts each example from the julia file into a code block and adds
a short html div below with the interactive output.
=#
using PlotlyJS
using Distributions, Quandl, RDatasets  # used in examples

doc_style = Style(layout=Layout(margin=attr(t=60, b=60, l=50, r=50)))

# Read all file names in
this_dir = dirname(@__FILE__)
if length(ARGS) == 0
    all_file_names = readdir(joinpath(this_dir, "..", "examples"))
else
    all_file_names = [endswith(i, ".jl") ? i : "$(i).jl" for i in ARGS]
end

nfiles = length(all_file_names)

# Check whether files are julia files and select julia files
cft(x) = x[end-2:end]==".jl" ? true : false
am_i_julia_file = map(cft, all_file_names)
all_julia_files = all_file_names[am_i_julia_file]
for i in all_julia_files
    println(i)
    include(joinpath(this_dir, "..", "examples", i))
end

use_style!(doc_style)

# Walk through each example in a file and get the markdown from `single_example`
function single_file(filename::String)
    # Open a file to write to
    open(joinpath(this_dir, "examples", filename[1:end-3]*".md"), "w") do outfile

    # Read lines from a files
    fulltext = open(f->read(f, String), joinpath(this_dir, "..", "examples", filename), "r")
    all_lines = split(fulltext, "\n")
    l = 1
    regex = r"^function ([^_].+?)\("
    regex_end = r"^end$"

    while true
        # Find next function name (break if none)
        l = findnext(x -> match(regex, x) != nothing, all_lines, l+1)
        if l == 0
            break
        end
        # find corresponding end for this function
        end_l = findnext(x -> match(regex_end, x) != nothing, all_lines, l+1)

        # Pull out function text
        func_block = join(all_lines[l:end_l], "\n")
        fun_name = match(regex, all_lines[l])[1]

        println("adding $fun_name")

        # Get html block
        plt = eval(Expr(:call, Symbol(fun_name))).plot
        relayout!(plt, margin=attr(t=60, b=60, l=50, r=50))
        html_block = PlotlyJS.html_body(plt)

        println(outfile, "```julia\n$func_block\n$(fun_name)()\n```\n\n\n$html_block\n\n")
        l = end_l
    end
    end  # do outfile

    return nothing
end

main() = map(single_file, all_julia_files)
