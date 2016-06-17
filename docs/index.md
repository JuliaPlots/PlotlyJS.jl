# PlotlyJS

Welcome to the documentation for PloyltJS.jl, a julia interface to the
[plotly.js][_plotlyjs] visualization library.

This package does not interact with the [Plotly web API](TODO: LINK), but
rather leverages the underlying javascript library to construct plotly graphics
using all local resources. This means you do not need a Plotly account or an
internet connection to use this package.

The goals of PlotlyJS.jl are:

1. Make it convenient to construct and manipulate plotly visualizations
2. Provide infrastructure for viewing plots on multiple frontends and saving
plotly graphics to files

[_plotlyjs]: https://plot.ly/javascript
[_plotlyref]: https://plot.ly/javascript/reference

## Installation

To install PlotlyJS.jl enter the following at the Julia prompt:

```
Pkg.add("PlotlyJS")
```

This will download an install PlotlyJS and all dependencies. If you have not
previously used the Blink.jl package and would like to use the
[Electron](http://spencerlyon.com/PlotlyJS.jl/syncplots/#electronplot) display
frontent from the REPL (recommended) you will need to enter evaluate the
following code at the REPL:

```julia
using Blink
Blink.AtomShell.install()
```

If you would like to be able to save plotly graphics to png or pdf formats you
will need additional packages. Please see the documentation on [exporting
figures](http://spencerlyon.com/PlotlyJS.jl/manipulating_plots/#saving-figures)
for more information.

If you would like to have a more exhaustive set of top-level functions for
constructing plots, see the [Plots.jl](http://plots.readthedocs.io/en/latest/)
package. This package is the `plotlyjs` Plots.jl backend and is fully supported
by Plots.
