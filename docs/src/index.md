# PlotlyJS

Welcome to the documentation for `PlotlyJS.jl`, a Julia interface to the
[plotly.js](https://plot.ly/javascript) visualization library.

This package does not interact with the [Plotly web
API](https://api.plot.ly/v2/), but rather leverages the underlying javascript
library to construct plotly graphics using all local resources. This means you
do not need a Plotly account or an internet connection to use this package.

The goals of `PlotlyJS.jl` are:

1. Make it convenient to construct and manipulate plotly visualizations
2. Provide infrastructure for viewing plots on multiple frontends and saving
plotly graphics to files

## Getting Help

There are three primary resources for getting help with using this library:

1. The [Julia discourse page](https://discourse.julialang.org/). This is your best option if the question you have is specific to Julia. Appropriate topics include how to integrate with other Julia packages or how to use plotly features unique to `PlotlyJS.jl`
2. The [julia channel](https://community.plotly.com/c/graphing-libraries/julia/23) on the plotly discussion page. This is your best option if you want visibility from other parts of the plotly community including python and R users.
3. [GitHub Issues](https://github.com/JuliaPlots/PlotlyJS.jl/issues). This is appropriate only for bug reports or feature requests. General usage questions should not be posted to GitHub, but rather should utilize one of the discussion forums above

## Installation

To install `PlotlyJS.jl`, open up a Julia REPL, press `]` to enter package mode and type:

```julia
(v1.0) pkg> add PlotlyJS
```

For existing users you can run `up` from the package manager REPL mode to get
the latest release. If after doing this plots do not show up in your chosen
frontend, please run `build PlotlyJS` (again from pkg REPL mode) to tell Julia
to download the latest release of the plotly.js javascript library.

### Saving figures

`PlotlyJS.jl` comes with built-in support for saving figures to files via the
integration between PlotlyBase.jl (a dependency of `PlotlyJS.jl`) and Plotly's
kaleido tool.

See [exporting figures](https://juliaplots.org/PlotlyJS.jl/stable/manipulating_plots/#Saving-figures)
for more information.

### Plots.jl

If you would like to have a more exhaustive set of top-level functions for
constructing plots, see the [Plots.jl](https://docs.juliaplots.org/latest/)
package. This package is the `plotlyjs` `Plots.jl` backend and is fully supported
by Plots.
