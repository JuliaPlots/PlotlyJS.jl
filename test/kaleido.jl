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
            # @show func, fn
            myplot(fn, func) == fn
            @test isfile(fn)
            rm(fn)
        end
    end
end

@testset "kaleido with non-finite data" begin
    # `NaN` is commonly used for gaps in trace data; it must be written as `null`
    plt = Plot(scatter(x=1:4, y=[1.0, NaN, Inf, 4.0]))
    @test startswith(String(savefig(plt; format="svg")), "<svg")
end
