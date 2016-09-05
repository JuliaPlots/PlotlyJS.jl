ps1 = M.PlotStyle(name=:ps1, layout_attrs=M.Layout(font_size=10))
ps2 = M.PlotStyle(name=:ps2, layout_attrs=M.Layout(font_family="Helvetica"))

@testset "PlotStyle(::PlotStyle, ::PlotStyle)" begin
    ps3 = M.PlotStyle(ps1, ps2)
    @test ps3.name == Symbol("ps1+ps2")
    @test isempty(ps3.color_cycle)
    @test ps3.layout_attrs[:font] == Dict(:family=>"Helvetica", :size=>10)
    @test isempty(ps3.global_trace_attrs)
    @test isempty(ps3.trace_attrs)

    gg = M.ggplot_style()
    new_font = M.PlotStyle(name=:new_font,
                           layout_attrs=M.Layout(font_family="Source Code Pro"))
    ps4 = M.PlotStyle(gg, new_font)
    ps5 = M.PlotStyle(new_font, gg)

    # make sure things were set properly
    @test ps4.color_cycle == ps5.color_cycle == gg.color_cycle
    for (k, v) in gg.layout_attrs
        if k == :font
            want = gg.layout_attrs[:font]
            want[:family] = "Source Code Pro"
            @test ps4.layout_attrs[k] == ps5.layout_attrs[k] == want
        else
            @test ps4.layout_attrs[k] == ps5.layout_attrs[k] == gg.layout_attrs[k]
        end
    end

end
