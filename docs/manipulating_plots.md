<!-- TODO: create API docs from docstrings and add link below -->

There are various methods defined on the `Plot` type. We will cover a few of
them here, but consult the (forthcoming) API docs for more exhaustive coverage.

## Julia functions

`Plot` and `SyncPlot` both have implementations of common Julia methods:

- `size`: returns the `width` and `layout` attributes in the plot's layout
- `copy`: create a shallow copy of all traces in the plot and the layout, but
create a new `divid`

## API functions

All exported functions from the plotly.js
[API](https://plot.ly/javascript/plotlyjs-function-reference/) have been
exposed to Julia and operate on both `Plot` and `SyncPlot` instances. Each of
these functions has semantics that match the semantics of plotly.js

In PlotlyJS.jl these functions are spelled:

- [`restyle!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlyrestyle): edit attributes on one or more traces
- [`relayout!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlyrelayout): edit attributes on the layout
- [`update!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlyupdate): combination of `restyle!` and `relayout!`
- [`react!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlyreact): In place updating of all traces and layout in plot. More efficient than constructing an entirely new plot from scratch, but has the same effect.
- [`addtraces!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlyaddtraces): add traces to a plot at specified indices
- [`deletetraces!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlydeletetraces): delete specific traces from a plot
- [`movetraces!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlymovetraces): reorder traces in a plot
- [`redraw!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlyredraw): for a redraw of an entire plot
- [`purge!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlypurge): completely remove all data and layout from the chart
- [`extendtraces!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlyextendtraces): Extend specific attributes of one or more traces with more data by appending to the end of the attribute
- [`prependtraces!`](https://plot.ly/javascript/plotlyjs-function-reference/#plotlyprependtraces): Prepend additional data to specific attributes on one or more traces


When any of these routines is called on a `SyncPlot` the underlying `Plot`
object (in the `plot` field on the `SyncPlot`) is updated and the plotly.js
function is called. This is where `SyncPlot` gets its name: when modifying a
plot, it keeps the Julia object and the display in sync.

<!-- TODO: create API docs from docstrings and add link below -->

For more details on which methods are available for each of the above functions
consult the docstrings or (forthcoming) API documentation.

!!! note
    Be especially careful when trying to use `restyle!`, `extendtraces!`, and
    `prependtraces!` to set attributes that are arrays. The semantics are a bit
    subtle. Check the docstring for details and examples

## Subplots

A common task is to construct subpots, or plots with more than one set of axes.
This is possible using the declarative plotly.js syntax, but can be tedious at
best.

PlotlyJS.jl provides a conveient syntax for constructing what we will
call regular grids of subplots. By regular we mean a square grid of plots.

To do this we will make a pun of the `vcat`, `hcat`, and `hvcat` functions from
`Base` and leverage the array construction syntax to build up our subplots.

Suppose we are working with the following plots:

```julia
p1 = Plot(scatter(;y=randn(3)))
p2 = Plot(histogram(;x=randn(50), nbinsx=4))
p3 = Plot(scatter(;y=cumsum(randn(12)), name="Random Walk"))
p4 = Plot([scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy"),
           scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")])
```

If we wanted to combine `p1` and `p2` as subplots side-by-side, we would do

```julia
[p1 p2]
```

which would be displayed as

<div id="9b211b11-90ba-4ed1-8a8e-922874e38327"></div>

<script>
   thediv = document.getElementById('9b211b11-90ba-4ed1-8a8e-922874e38327');
var data = [{"type":"scatter","yaxis":"y1","y":[0.5866244446671521,-1.9383492773474906,1.5755145234613384],"xaxis":"x1"},{"type":"histogram","yaxis":"y2","nbinsx":4,"xaxis":"x2","x":[0.02874721818368543,0.3591555676689275,1.11127022977901,0.334122911382547,0.9732575270950886,-1.82561414154534,-0.5947229804546266,1.1956059287597995,-0.370911402072595,0.06506468964194402,-0.3917477253349423,-0.5177800509470399,0.6690381772206448,0.8506312798188942,-0.4661996650376157,-0.08925203756626206,-0.2720106005346297,1.0095318669374804,-0.3429367632640522,1.494593406085796,-0.7021001204975328,2.485160558272339,1.2042841766161603,-0.8179889425824214,0.9976808279235531,0.8487941945727004,-0.13238916888817898,-0.6076727142119374,-0.08957049673870185,-0.7228619615214743,-0.767689315513464,0.010505735738696221,-0.2664477321938591,-0.38965938770679176,-1.1379871323364503,-0.9323045907088239,1.1409535571170606,0.3823735429884236,-0.24363572900382519,-0.4932551604604664,0.10647049887188982,0.569918962367392,0.1386005823334299,0.6768770552472566,-2.541071033107882,-0.6298953799242188,-0.24777182837411657,-0.4598333903988536,-1.4974831175797392,-0.7500193945928398]}]
var layout = {"yaxis2":{"domain":[0.0,1.0],"anchor":"x2"},"yaxis1":{"domain":[0.0,1.0],"anchor":"x1"},"xaxis1":{"domain":[0.0,0.45],"anchor":"y1"},"margin":{"r":50,"l":50,"b":50,"t":60},"xaxis2":{"domain":[0.55,1.0],"anchor":"y2"}}

Plotly.plot(thediv, data,  layout, {showLink: false});

 </script>


If instead we wanted two rows and one column we could

```julia
[p3, p4]
```

<div id="5f7a7d9a-7e61-4ddd-9fe2-738e192ff6da"></div>

<script>
   thediv = document.getElementById('5f7a7d9a-7e61-4ddd-9fe2-738e192ff6da');
var data = [{"type":"scatter","yaxis":"y1","y":[2.309908323313182,4.133375142194304,2.5758077544798774,2.4898933716911578,0.9324775281108626,0.7008738444090501,2.0447231431131767,1.7077489543681752,1.577316978086749,1.8339202074093615,2.2885533332596335,3.2964418594324254],"name":"Random Walk","xaxis":"x1"},{"type":"scatter","yaxis":"y2","y":[0,2,3,5],"xaxis":"x2","x":[1,2,3,4],"fill":"tozeroy"},{"type":"scatter","yaxis":"y2","y":[3,5,1,7],"xaxis":"x2","x":[1,2,3,4],"fill":"tonexty"}]
var layout = {"yaxis2":{"domain":[5.551115123125783e-17,0.42500000000000004],"anchor":"x2"},"yaxis1":{"domain":[0.575,1.0],"anchor":"x1"},"xaxis1":{"domain":[0.0,1.0],"anchor":"y1"},"margin":{"r":50,"l":50,"b":50,"t":60},"xaxis2":{"domain":[0.0,1.0],"anchor":"y2"}}

Plotly.plot(thediv, data,  layout, {showLink: false});

</script>

Finally, we can make a 2x2 grid of subplots:

```julia
[p1 p2
 p3 p4]
```

<div id="bd979d53-9a3d-4594-a03e-c0674720f5c4"></div>

<script>
   thediv = document.getElementById('bd979d53-9a3d-4594-a03e-c0674720f5c4');
var data = [{"type":"scatter","yaxis":"y1","y":[0.5866244446671521,-1.9383492773474906,1.5755145234613384],"xaxis":"x1"},{"type":"histogram","yaxis":"y2","nbinsx":4,"xaxis":"x2","x":[0.02874721818368543,0.3591555676689275,1.11127022977901,0.334122911382547,0.9732575270950886,-1.82561414154534,-0.5947229804546266,1.1956059287597995,-0.370911402072595,0.06506468964194402,-0.3917477253349423,-0.5177800509470399,0.6690381772206448,0.8506312798188942,-0.4661996650376157,-0.08925203756626206,-0.2720106005346297,1.0095318669374804,-0.3429367632640522,1.494593406085796,-0.7021001204975328,2.485160558272339,1.2042841766161603,-0.8179889425824214,0.9976808279235531,0.8487941945727004,-0.13238916888817898,-0.6076727142119374,-0.08957049673870185,-0.7228619615214743,-0.767689315513464,0.010505735738696221,-0.2664477321938591,-0.38965938770679176,-1.1379871323364503,-0.9323045907088239,1.1409535571170606,0.3823735429884236,-0.24363572900382519,-0.4932551604604664,0.10647049887188982,0.569918962367392,0.1386005823334299,0.6768770552472566,-2.541071033107882,-0.6298953799242188,-0.24777182837411657,-0.4598333903988536,-1.4974831175797392,-0.7500193945928398]},{"type":"scatter","yaxis":"y3","y":[2.309908323313182,4.133375142194304,2.5758077544798774,2.4898933716911578,0.9324775281108626,0.7008738444090501,2.0447231431131767,1.7077489543681752,1.577316978086749,1.8339202074093615,2.2885533332596335,3.2964418594324254],"name":"Random Walk","xaxis":"x3"},{"type":"scatter","yaxis":"y4","y":[0,2,3,5],"xaxis":"x4","x":[1,2,3,4],"fill":"tozeroy"},{"type":"scatter","yaxis":"y4","y":[3,5,1,7],"xaxis":"x4","x":[1,2,3,4],"fill":"tonexty"}]
var layout = {"yaxis4":{"domain":[5.551115123125783e-17,0.42500000000000004],"anchor":"x4"},"xaxis3":{"domain":[0.0,0.45],"anchor":"y3"},"yaxis2":{"domain":[0.575,1.0],"anchor":"x2"},"yaxis1":{"domain":[0.575,1.0],"anchor":"x1"},"xaxis1":{"domain":[0.0,0.45],"anchor":"y1"},"margin":{"r":50,"l":50,"b":50,"t":60},"yaxis3":{"domain":[5.551115123125783e-17,0.42500000000000004],"anchor":"x3"},"xaxis2":{"domain":[0.55,1.0],"anchor":"y2"},"xaxis4":{"domain":[0.55,1.0],"anchor":"y4"}}

Plotly.plot(thediv, data,  layout, {showLink: false});

</script>

## Saving figures

In order to save figures in other formats you must you need to have the
[ORCA.jl](https://github.com/sglyon/ORCA.jl) package installed and loaded. To
install this, call `add ORCA` from the Julia package manager REPL mode (which
you can enter by pressing `]` at the REPL). To load, call `using ORCA`.

After loading you can also save figures in a variety of formats:


```julia
savefig(p::Union{Plot,SyncPlot}, "output_filename.pdf")
savefig(p::Union{Plot,SyncPlot}, "output_filename.html")
savefig(p::Union{Plot,SyncPlot}, "output_filename.json")
savefig(p::Union{Plot,SyncPlot}, "output_filename.png")
savefig(p::Union{Plot,SyncPlot}, "output_filename.eps")
savefig(p::Union{Plot,SyncPlot}, "output_filename.svg")
savefig(p::Union{Plot,SyncPlot}, "output_filename.jpeg")
savefig(p::Union{Plot,SyncPlot}, "output_filename.webp")
```

!!! note
    You can also save the json for a figure by calling
    `savejson(p::Union{Plot,SyncPlot}, filename::String)`. This does not
    require the ORCA.jl package.
