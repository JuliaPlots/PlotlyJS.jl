ps1 = M.Style(layout=M.Layout(font_size=10))
ps2 = M.Style(layout=M.Layout(font_family="Helvetica"))

@testset "Style(::Style, ::Style)" begin
    ps3 = M.Style(ps1, ps2)
    @test isempty(ps3.color_cycle)
    @test ps3.layout[:font] == Dict(:family=>"Helvetica", :size=>10)
    @test isempty(ps3.global_trace)
    @test isempty(ps3.trace)

    gg = M.ggplot_style()
    new_font = M.Style(layout=M.Layout(font_family="Source Code Pro"))
    ps4 = M.Style(gg, new_font)
    ps5 = M.Style(new_font, gg)

    # make sure things were set properly
    @test ps4.color_cycle == ps5.color_cycle == gg.color_cycle
    for (k, v) in gg.layout
        if k == :font
            want = gg.layout[:font]
            want[:family] = "Source Code Pro"
            @test ps4.layout[k] == ps5.layout[k] == want
        else
            @test ps4.layout[k] == ps5.layout[k] == gg.layout[k]
        end
    end

end

@testset "setting plot attributes" begin

    goofy = Style(global_trace=attr(marker_color="red"),
                  trace=Dict(:scatter => attr(mode="markers")))

    p1 = Plot(scatter(y=1:3, mode="lines", marker_symbol="square"), style=goofy)
    p2 = Plot(scatter(y=1:3, marker_color="green"), style=goofy)

    # now call JSON.lower to enforce style
    PlotlyJS.JSON.lower(p1)
    PlotlyJS.JSON.lower(p2)

    @test p1.data[1]["marker_color"] == "red"
    @test p2.data[1]["marker_color"] == "green"
end
