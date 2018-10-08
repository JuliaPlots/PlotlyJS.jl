## Contributing

Contributions are welcome! For a quick list at the things on our radar, check
out the [issue list](https://github.com/spencerlyon2/PlotlyJS.jl/issues).

If submitting pull requests on GitHub is intimidating, we're happy to help you
work through getting your code polished up and included in the right places.

Other projects that are helpful are:

- Adding docstrings to function names
- Adding more examples to the documentation (see below)
- Submitting feature requests or bug reports

### Documentation

The documentation for PlotlyJS.jl is contained in the `docs` directory of this
repository. It currently uses a combination of the python-based `mkdocs` and a
custom Julia script for generating examples.

For more details on how to use `mkdocs`, please see
[their documentation](http://www.mkdocs.org). For convenience, I will list the
most common commands here. All of these should be run from the root directory of
this repository:

- `mkdocs build -c`: Build the documentation and put it in the `site` folder
- `mkdocs serve`: Build the documentation and start a local web-server that can
  be used to view the docs. Note that this is required to view any plotly.js
  examples

#### Adding Examples

tl;dr: adding examples to the docs is as easy as 1, 2, 3...

1. Add a new function that returns a SyncPlot to a Julia (`.jl`) file in the
   `examples` directory
2. Run the Julia script `docs/build_example_docs.jl` to re-generate the markdown
   source for the examples section of the docs
3. Rebuild the site using one of the `mkdocs` commands from above

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

The final step is to build the docs again using one of the `mkdocs` commands
from above.
