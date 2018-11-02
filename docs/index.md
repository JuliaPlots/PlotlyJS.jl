# PlotlyJS

Welcome to the documentation for PlotlyJS.jl, a Julia interface to the
[plotly.js][_plotlyjs] visualization library.

This package does not interact with the [Plotly web
API](https://api.plot.ly/v2/), but rather leverages the underlying javascript
library to construct plotly graphics using all local resources. This means you
do not need a Plotly account or an internet connection to use this package.

The goals of PlotlyJS.jl are:

1. Make it convenient to construct and manipulate plotly visualizations
2. Provide infrastructure for viewing plots on multiple frontends and saving
plotly graphics to files

[_plotlyjs]: https://plot.ly/javascript
[_plotlyref]: https://plot.ly/javascript/reference

## Installation

To install PlotlyJS.jl, open up a Julia REPL, press `]` to enter package mode and type:

```
(v1.0) pkg> add PlotlyJS
```

For existing users you can run `up` from the package manager REPL mode to get
the latest release. If after doing this plots do not show up in your chosen
frontend, please run `build PlotlyJS` (again from pkg REPL mode) to tell Julia
to download the latest release of the plotly.js javascript library.

### Saving figures

If you would like to save your figures to files in a format other than json and
html, you will need to install the [ORCA.jl](https://github.com/sglyon/ORCA.jl)
package. See [exporting
figures](http://spencerlyon.com/PlotlyJS.jl/manipulating_plots/#saving-figures)
for more information.

### Plots.jl

If you would like to have a more exhaustive set of top-level functions for
constructing plots, see the [Plots.jl](https://docs.juliaplots.org/latest/)
package. This package is the `plotlyjs` Plots.jl backend and is fully supported
by Plots.
