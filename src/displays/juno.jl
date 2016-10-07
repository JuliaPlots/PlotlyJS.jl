using Juno
import Juno: Tree, icon

media(SyncPlot, Media.Plot)
media(Plot, Media.Plot)

function Media.render(::Juno.PlotPane, plot::SyncPlot)
  style = plot.plot.style
  style == Style() == DEFAULT_STYLE[1] && (plot.plot.style = gadfly_dark_style())
  display_blink(plot)
  plot.plot.style = style
end

@render Juno.PlotPane plot::Plot SyncPlot(plot)

@render Juno.Editor p::SyncPlot p.plot

@render Juno.Editor p::Plot begin
  Tree(icon("graph"), [p.data, p.layout])
end
