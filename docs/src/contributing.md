## Contributing

Contributions are welcome! For a quick list at the things on our radar, check
out the [issue list](https://github.com/JuliaPlots/PlotlyJS.jl/issues).

If submitting pull requests on GitHub is intimidating, we're happy to help you
work through getting your code polished up and included in the right places.

Other projects that are helpful are:

- Adding docstrings to function names
- Adding more examples to the documentation (see below)
- Submitting feature requests or bug reports

### Documentation

The documentation for `PlotlyJS.jl` is contained in the `docs` directory of this
repository.

Docs are build using the `Documenter.jl` package and can be built following these steps:

1. Change into the `docs` directory
2. Start julia
3. Activate the docs project by entering package mode (`]`) and then running `activate .`
4. Execute `include("make.jl")` from the Julia prompt

#### Adding Examples

tl;dr: adding examples to the docs is as easy as 1, 2, 3...

1. Add a new function that returns a SyncPlot to a Julia (`.jl`) file in the
   `examples` directory
2. Run the Julia script `docs/build_example_docs.jl` to re-generate the markdown
   source for the examples section of the docs
3. Rebuild the site using one of the instructions above

One of the most helpful things users can do to contribute to the documentation
is to add more examples. These are automatically generated from the Julia
(`.jl`) files in the `examples` directory. To add a new example, you simply need
to open one of the files in that directory and add a new 0 argument function
that constructs and returns a `SyncPlot` object (this is the output of the
`plot` function).

For example, if we wanted to add an example of a scatter plot of the sin function we could add the following function definition inside the `examples/line_scatter.jl` file:

```julia
function sin_scatter()
    x = range(0, stop=2*pi, length=50)
    y = sin(x)
    plot(scatter(x=x, y=y, marker_symbol="line-nw", mode="markers+symbols"))
end
```

The next step is to have Julia re-build the markdown (`.md`) files in
`docs/examples` to use all your new functions in the Julia files from the
`examples` folder. To do this run the script `docs/build_example_docs.jl`. If I
were in the root directory of the repository, I could do this by running `julia docs/build_example_docs.jl`.

The final step is to build the docs again using one of the commands from above.
