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
