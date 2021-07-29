function myplot(fn, func)
    x = 0:0.1:2π
    plt = func(scatter(x=x, y=sin.(x)))
    savefig(plt, fn)
end

@testset "kaleido" begin
    for func in [Plot, plot]
        for ext in [PlotlyJS.ALL_FORMATS..., "html"]
            if ext === "eps"
                continue
            end
            fn = tempname() * "." * ext
            @show func, fn
            myplot(fn, func) == fn
            @test isfile(fn)
            rm(fn)
        end
    end
end
