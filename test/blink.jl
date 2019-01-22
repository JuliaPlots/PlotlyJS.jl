using Blink, WebIO

t() = scatter(y=rand(10))
p = plot([t(), t(), t(), t()])
w = Blink.Window()
body!(w, p.scope)
sleep(3.0)  # make sure we give time for svg to render

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
        relayout!(p, title_text="This is a title")
        update_layout!()
        @test p.scope["__gd_contents"][]["title"]["text"] == "This is a title"
    end

    @testset "update" begin
        update!(p, marker_size=10, layout=Layout(xaxis_title_text="This is x"))
        update_layout!()
        @test p.scope["__gd_contents"][]["xaxis"]["title"]["text"] == "This is x"

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

    @testset "react" begin
        new_trace = scatter(x=1:10, y=(1:10.0).^2, name="New trace")
        new_trace2 = t()
        new_l = Layout(yaxis_title_text="This is y")
        react!(p, [new_trace, new_trace2], new_l)

        update_data!()
        @test length(p.scope["__gd_contents"][]) == 2
        @test all(p.scope["__gd_contents"][][1]["x"] .== 1:10)
        @test all(p.scope["__gd_contents"][][1]["y"] .== (1:10).^2)
        @test p.scope["__gd_contents"][][1]["name"] == "New trace"

        update_layout!()
        @test p.scope["__gd_contents"][]["yaxis"]["title"]["text"] == "This is y"
    end

end
