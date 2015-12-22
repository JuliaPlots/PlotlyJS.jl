# PlotlyJS

[![Build Status](https://travis-ci.org/spencerlyon2/PlotlyJS.jl.svg?branch=master)](https://travis-ci.org/spencerlyon2/PlotlyJS.jl)

Julia interface to [plotly.js](https://plot.ly/javascript) visualization library.

Key features:

- Simple types that both expose full plotly.js functionality _and_ provide a smoother Julia API for doing so
- Dedicated display window via Electron (uses [Blink.jl](https://github.com/JunoLab/Blink.jl)). Allows _efficient_ updating of portions of the plot and exposes all [plotly.js functions](https://plot.ly/javascript/plotlyjs-function-reference/) in pure Julia
- Jupyter notebook integration

For examples of usage, see the `examples` directory.

## TODO

- [ ] Docs
- [ ] Flesh out the rest of the js API methods
- [ ] Tune up display methods to use best practices
- [ ] Test
- [ ] Publish
