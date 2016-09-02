using Juno, Juno.Media, Juno.Hiccup

function mediatypes()
  media(SyncPlot, Media.Plot)
end

function Juno.render(::Juno.PlotPane, plot::SyncPlot)
  display_blink(plot)
end

@render Juno.Editor p::SyncPlot begin
  p.plot
end

@render Juno.Editor p::Plot begin
  Juno.Tree(span([Juno.Atom.fade("Plotly "), Juno.Atom.icon("graph")]),
            [p.data, p.layout])
end
