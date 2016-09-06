ps1 = M.Style(name=:ps1, layout=M.Layout(font_size=10))
ps2 = M.Style(name=:ps2, layout=M.Layout(font_family="Helvetica"))

@testset "Style(::Style, ::Style)" begin
    ps3 = M.Style(ps1, ps2)
    @test ps3.name == Symbol("ps1+ps2")
    @test isempty(ps3.color_cycle)
    @test ps3.layout[:font] == Dict(:family=>"Helvetica", :size=>10)
    @test isempty(ps3.global_trace)
    @test isempty(ps3.trace)

    gg = M.ggplot_style()
    new_font = M.Style(name=:new_font,
                           layout=M.Layout(font_family="Source Code Pro"))
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
