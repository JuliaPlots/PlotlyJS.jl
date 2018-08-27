using Blink, WebIO

t() = scatter(y=rand(10))
p = plot([t(), t(), t(), t()])
w = Blink.Window()
body!(w, p.scope)
sleep(3.0)  # make sure we give time for svg to render

# test that plotly loads
@test length(p["svg"].val) > 0

# test that we get back reasonable svg
svg = p["svg"].val
@test svg[1:4] == "<svg"
@test svg[end-5:end] == "</svg>"

# hook up testing observables
on(p.scope["__gd_contents"]) do x end

function update_data!()
    p.scope["__get_gd_contents"][] = "data"
    sleep(1)
end

function update_layout!()
    p.scope["__get_gd_contents"][] = "layout"
    sleep(1)
end

@testset "api methods" begin

    @testset "to_image" begin
        @test to_image(p)[1:21] == "data:image/png;base64"
        @test to_image(p, format="svg")[1:18] == "data:image/svg+xml"
        @test to_image(p, format="jpeg")[1:22] =="data:image/jpeg;base64"
        @test to_image(p, format="webp")[1:22] =="data:image/webp;base64"
        @test_throws ErrorException to_image(p, format="pdf")
        @test to_image(p, imageDataOnly=true, format="svg")[1:4] == "<svg"
    end

    @testset "restyle" begin
        p.scope["__gd_contents"][] = Dict() # reset
        restyle!(p, marker_color="pink", 1)
        update_data!()

        restyle!(p, marker_symbol="star")
        update_data!()
        for i in 1:4
            @test p.scope["__gd_contents"][][i]["marker"]["symbol"] == "star"
        end
    end

    @testset "relayout" begin
        relayout!(p, title="This is a title")
        update_layout!()
        @test p.scope["__gd_contents"][]["title"] == "This is a title"
    end

    @testset "update" begin
        update!(p, marker_size=10, layout=Layout(xaxis_title="This is x"))
        update_layout!()
        @test p.scope["__gd_contents"][]["xaxis"]["title"] == "This is x"

        update_data!()
        for i in 1:4
            @test p.scope["__gd_contents"][][i]["marker"]["size"] == 10
        end
    end

    @testset "addtraces" begin
        update_data!()
        @test length(p.scope["__gd_contents"][]) == 4

        new_trace = scatter(x=1:10, y=(1:10.0).^2, name="New trace")
        addtraces!(p, new_trace)
        update_data!()

        @test length(p.scope["__gd_contents"][]) == 5
        @test all(p.scope["__gd_contents"][][5]["x"] .== 1:10)
        @test all(p.scope["__gd_contents"][][5]["y"] .== (1:10).^2)
        @test p.scope["__gd_contents"][][5]["name"] == "New trace"
    end

    @testset "movetraces" begin
        update_data!()
        @test p.scope["__gd_contents"][][5]["name"] == "New trace"

        movetraces!(p, [5, 4], [4, 5])
        update_data!()
        @test p.scope["__gd_contents"][][4]["name"]  == "New trace"
    end

    @testset "deletetraces" begin
        update_data!()
        @test length(p.scope["__gd_contents"][]) == 5
        deletetraces!(p, 4)

        update_data!()
        @test length(p.scope["__gd_contents"][]) == 4
        @test !haskey(p.scope["__gd_contents"][][4], "name")
    end

    @testset "extendtraces" begin
        extendtraces!(p, 1, -1; y=[2, 2.5, 3.0])
        update_data!()
        @test length(p.scope["__gd_contents"][][1]["y"]) == 13
        @test all(p.scope["__gd_contents"][][1]["y"][end-2:end] .== [2, 2.5, 3.0])
    end

    @testset "prependtraces" begin
        prependtraces!(p, 1, -1; y=[3, 4, 5])
        update_data!()
        @test length(p.scope["__gd_contents"][][1]["y"]) == 16
        @test all(p.scope["__gd_contents"][][1]["y"][1:3] .== [3, 4, 5])
    end
end

# using Rsvg
#
# @testset "savefig" begin
#     my_dir = tempdir()
#     p = plot(rand(10, 4))
#     display(p)
#     sleep(4)  # give it _plently_ of time to render
#     for extension in [".plotly.json", "json", "html", "svg", "pdf", "png", "eps"]
#         fn = joinpath(my_dir, "out.$(extension)")
#         @test begin
#             savefig(p, fn)
#             isfile(fn)
#         end
#     end
#
#     # also try method where we open non-visible window
#     p = plot(rand(10, 4))
#     for extension in [".plotly.json", "json", "html", "svg", "pdf", "png", "eps"]
#         fn = joinpath(my_dir, "out.$(extension)")
#         savefig(p, fn)
#         @test isfile(fn)
#     end
# end
