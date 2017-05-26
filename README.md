# PlotlyJS

[![Join the chat at https://gitter.im/sglyon/PlotlyJS.jl](https://badges.gitter.im/sglyon/PlotlyJS.jl.svg)](https://gitter.im/sglyon/PlotlyJS.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/sglyon/PlotlyJS.jl.svg?branch=master)](https://travis-ci.org/sglyon/PlotlyJS.jl)

#[![AppVeyor](https://ci.appveyor.com/api/projects/status/mue0n1yhlxq4ok8d/branch/master?svg=true)](https://ci.appveyor.com/project/sglyon/plotlyjs-jl/branch/master)
#[![Coverage Status](https://img.shields.io/coveralls/sglyon/PlotlyJS.jl.svg)](https://coveralls.io/r/sglyon/PlotlyJS.jl)

[![PlotlyJS](http://pkg.julialang.org/badges/PlotlyJS_0.5.svg)](http://pkg.julialang.org/?pkg=PlotlyJS)
[![PlotlyJS](http://pkg.julialang.org/badges/PlotlyJS_0.6.svg)](http://pkg.julialang.org/?pkg=PlotlyJS)

Julia interface to [plotly.js][_plotlyjs] visualization library.

This package constructs plotly graphics using all local resources. To interact or save graphics to the Plotly cloud, use the  [`Plotly`](https://github.com/plotly/Plotly.jl) package.

Check out the [docs](http://spencerlyon.com/PlotlyJS.jl/)!



[_plotlyjs]: https://plot.ly/javascript

## Installation

If you intend to use the [Electron display](http://spencerlyon.com/PlotlyJS.jl/syncplots/#electronplot) or any of its features (recommended) you will need to enter the following at the Julia REPL:

```julia
using Blink
Blink.AtomShell.install()
```

Note that this is a one time process.

Also, if you have issues building this package because of installation of the MbedTLS  package please see [this issue](https://github.com/sglyon/PlotlyJS.jl/issues/83).


