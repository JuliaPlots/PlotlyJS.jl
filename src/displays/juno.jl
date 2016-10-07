using Juno
import Juno: Tree, icon

media(SyncPlot, Media.Plot)
media(Plot, Media.Plot)

Media.render(::Juno.PlotPane, plot::SyncPlot) = display_blink(plot)

@render Juno.PlotPane plot::Plot SyncPlot(plot)

@render Juno.Editor p::SyncPlot p.plot

@render Juno.Editor p::Plot begin
  Tree(icon("graph"), [p.data, p.layout])
end
