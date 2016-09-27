using Juno
import Juno: Tree, Row, icon, fade

media(SyncPlot, Media.Plot)

function Juno.render(::Juno.PlotPane, plot::SyncPlot)
  display_blink(plot)
end

@render Juno.Editor p::SyncPlot begin
  p.plot
end

@render Juno.Editor p::Plot begin
  Tree(icon("graph"), [p.data, p.layout])
end
