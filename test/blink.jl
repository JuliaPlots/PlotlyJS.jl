using Blink

p = plot(rand(10, 4))
display(p)
w = PlotlyJS.get_window(p)
sleep(1.0)  # make sure we give time for svg to render

# test that plotly loads
@test isa(@js(p, Plotly), Dict)

# test that svg is defined
@test isa(@js(p, $(PlotlyJS.svg_var(p))), String)

# test that we get back reasonable svg
svg = @js(p, $(PlotlyJS.svg_var(p)))
@test svg[1:4] == "<svg"
@test svg[end-5:end] == "</svg>"

@testset "api methods" begin

    @testset "to_image" begin
        @test to_image(p)[1:21] == "data:image/png;base64"
        @test to_image(p, format="svg")[1:18] == "data:image/svg+xml"
        @test to_image(p, format="jpeg")[1:22] =="data:image/jpeg;base64"
        @test to_image(p, format="webp")[1:22] =="data:image/webp;base64"
        @test_throws Blink.JSError to_image(p, format="pdf")
        @test to_image(p, imageDataOnly=true, format="svg")[1:4] == "<svg"
    end

    @testset "restyle" begin
        restyle!(p, marker_color="pink", 1)
        @test @js(p, gd.data[0].marker.color) == "pink"

        restyle!(p, marker_symbol="star")
        @test @js(p, gd.data[0].marker.symbol) == "star"
        @test @js(p, gd.data[1].marker.symbol) == "star"
        @test @js(p, gd.data[2].marker.symbol) == "star"
        @test @js(p, gd.data[3].marker.symbol) == "star"
    end

    @testset "relayout" begin
        relayout!(p, title="This is a title")
        @test @js(p, gd.layout.title) == "This is a title"
    end

    @testset "update" begin
        update!(p, marker_size=10, layout=Layout(xaxis_title="This is x"))
        @test @js(p, gd.data[0].marker.size) == 10
        @test @js(p, gd.data[1].marker.size) == 10
        @test @js(p, gd.data[2].marker.size) == 10
        @test @js(p, gd.data[3].marker.size) == 10
        @test @js(p, gd.layout.xaxis.title) == "This is x"
    end

    @testset "addtraces" begin
        @test @js(p, gd.data.length) == 4
        new_trace = scatter(x=1:10, y=(1:10.0).^2, name="New trace")
        addtraces!(p, new_trace)
        @test @js(p, gd.data.length) == 5
        @test all(@js(p, gd.data[4].x) .== 1:10)
        @test all(@js(p, gd.data[4].y) .== (1:10).^2)
        @test @js(p, gd.data[4].name) == "New trace"
    end

    @testset "movetraces" begin
        @test @js(p, gd.data[4].name) == "New trace"
        movetraces!(p, [5, 4], [4, 5])
        @test @js(p, gd.data[3].name) == "New trace"
    end

    @testset "deletetraces" begin
        @test @js(p, gd.data.length) == 5
        deletetraces!(p, 4)
        @test @js(p, gd.data.length) == 4
        @test @js(p, gd.data[3].name) === nothing
    end

    @testset "extendtraces" begin
        extendtraces!(p.view, 1, -1; y=[2, 2.5, 3.0])
        @test @js(p, gd.data[0].y.length) == 13
        @test all(@js(p, gd.data[0].y)[end-2:end] .== [2, 2.5, 3.0])
    end

    @testset "prependtraces" begin
        prependtraces!(p.view, 1, -1; y=[3, 4, 5])
        @test @js(p, gd.data[0].y.length) == 16
        @test all(@js(p, gd.data[0].y)[1:3] .== [3, 4, 5])
    end

    @testset "purge" begin
        purge!(p)
        @test @js(p, gd.data) === nothing
    end
end

using Rsvg

@testset "savefig" begin
    my_dir = tempdir()
    p = plot(rand(10, 4))
    display(p)
    sleep(4)  # give it _plently_ of time to render
    for extension in [".plotly.json", "json", "html", "svg", "pdf", "png", "eps"]
        fn = joinpath(my_dir, "out.$(extension)")
        @test begin
            savefig(p, fn)
            isfile(fn)
        end
    end

    # also try method where we open non-visible window
    p = plot(rand(10, 4))
    for extension in [".plotly.json", "json", "html", "svg", "pdf", "png", "eps"]
        fn = joinpath(my_dir, "out.$(extension)")
        savefig(p, fn)
        @test isfile(fn)
    end
end
