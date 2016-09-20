#=
This file takes the code from each file in the examples folder and
creates a markdown file of the same name as the julia file then
puts each example from the julia file into a code block and adds
a short html div below with the interactive output.

Notes:

  * Assumes that the plot to be placed in html file is named `p`
  *
=#
using PlotlyJS

# Read all file names in
this_dir = dirname(@__FILE__)
all_file_names = readdir(joinpath(this_dir, "..", "examples"))
nfiles = length(all_file_names)

# Check whether files are julia files and select julia files
cft(x) = x[end-2:end]==".jl" ? true : false
am_i_julia_file = map(cft, all_file_names)
all_julia_files = all_file_names[am_i_julia_file]
for i in all_julia_files
    println(i)
    include(joinpath(this_dir, "..", "examples", i))
end

# Walk through each example in a file and get the markdown from `single_example`
function single_file(filename::AbstractString)
    # Open a file to write to
    outfile = open(joinpath(this_dir, "examples", filename[1:end-3]*".md"), "w")

    # Read lines from a files
    fulltext = open(readstring, joinpath(this_dir, "..", "examples", filename), "r")
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
        html_block = PlotlyJS.html_body(eval(Expr(:call, Symbol(fun_name))).plot)

        println(outfile, "```julia\n$func_block\n$(fun_name)()\n```\n\n\n$html_block\n\n")
        l = end_l
    end
    close(outfile)

    return nothing
end

map(single_file, all_julia_files)
