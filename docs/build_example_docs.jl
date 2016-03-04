#=
This file takes the code from each file in the examples folder and
creates a markdown file of the same name as the julia file then
puts each example from the julia file into a code block and adds
a short html div below with the interactive output.

Notes:

  * Assumes that the plot to be placed in html file is named `p`
  *
=#
using CodeTools
using PlotlyJS

# Read all file names in
all_file_names = readdir("../examples")
nfiles = length(all_file_names)

# Check whether files are julia files and select julia files
cft(x) = x[end-2:end]==".jl" ? true : false
am_i_julia_file = map(cft, all_file_names)
all_julia_files = all_file_names[am_i_julia_file]
for i in all_julia_files
    println(i)
    include("../examples/$i")
end

# Walk through each example in a file and get the markdown from `single_example`
function single_file(filename::AbstractString)
    # Open a file to write to
    outfile = open(joinpath("examples", filename[1:end-3]*".md"), "w")

    # Read lines from a files
    fulltext = open(readall, "../examples/$filename", "r")
    all_lines = split(fulltext, "\n")
    l = 1

    while true
        # Find next function nam (break if none)
        l = findnext(x -> startswith(x, "function ex"), all_lines, l+1)
        if l == 0
            break
        end

        # Pull out function text
        func_block = CodeTools.getblock(fulltext, l)[1]
        fun_name = match(r"^function (.+?)\(", func_block)[1]

        println("adding $fun_name")

        # Get html block
        html_block = PlotlyJS.html_body(eval(Expr(:call, symbol(fun_name))).plot)

        println(outfile, "```julia\n$func_block\n$(fun_name)()\n```\n\n\n$html_block\n\n")
    end
    close(outfile)

    return nothing
end

map(single_file, all_julia_files)
