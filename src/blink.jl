Base.display(::PlotlyJSDisplay, p::SyncPlot) = display_blink(p::SyncPlot)

function display_blink(p::SyncPlot)
    p.window = Blink.Window()
    Blink.body!(p.window, p.scope)
end

function Base.close(p::SyncPlot)
    if p.window !== nothing && Blink.active(p.window)
        close(p.window)
    end
end


