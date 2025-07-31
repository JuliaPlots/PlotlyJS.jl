# PlotlyJS

[_plotlyjs]: https://plotly.com/javascript/

[docs-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-url]: http://juliaplots.org/PlotlyJS.jl/stable

[![][docs-img]][docs-url]
[![Build Status](https://github.com/JuliaPlots/PlotlyJS.jl/actions/workflows/ci-master-workflow.yml/badge.svg)](https://github.com/JuliaPlots/PlotlyJS.jl/actions/workflows/ci-master-workflow.yml)
[![project chat](https://img.shields.io/badge/zulip-join_chat-brightgreen.svg)](https://julialang.zulipchat.com/#narrow/stream/227176-plotting)

Julia interface to [plotly.js][_plotlyjs] visualization library.

This package constructs plotly graphics using all local resources. To interact or save graphics to the Plotly cloud, use the  [`Plotly`](https://github.com/plotly/Plotly.jl) package.

## Installation

If you have issues building this package because of installation of the MbedTLS  package please see [this issue](https://github.com/sglyon/PlotlyJS.jl/issues/83).

### Jupyterlab

If you will be using this package from within Jupyterlab, please also install the plotly jupyterlab extension by running:


```sh
jupyter labextension install jupyterlab-plotly
```

See the [jupyterlab extension documentation](https://jupyterlab.readthedocs.io/en/stable/user/extensions.html) for more details.


