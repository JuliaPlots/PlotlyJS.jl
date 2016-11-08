# lowered stem plot, for testing
lstem(args...; kwargs...) = stem(args...; kwargs...) |> JSON.lower

import PlotlyJS: AbstractPlotlyDisplay, SyncPlot, restyle!, prep_kwargs

# calls is a list of calls to the display backend. Each call is recorded as a
# string with the name of the function, and an Array of the arguments as they'd
# be called down to javascript
type MockPlotlyDisplay <: AbstractPlotlyDisplay
    calls::Array{Tuple{String, Array{Any}}}

    MockPlotlyDisplay() = new(Any[])
end

# TODO: this mimics what electron.jl does, it would be better to bubble this
# logic up before the various displays are called, so we can have a simpler mock
function restyle!(disp::MockPlotlyDisplay, I, update::Associative=Dict(); kwargs...)
    argdict = merge(update, prep_kwargs(kwargs))
    push!(disp.calls, ("restyle!", [argdict, I-1]))
end

function restyle!(disp::MockPlotlyDisplay, update::Associative=Dict(); kwargs...)
    argdict = merge(update, prep_kwargs(kwargs))
    push!(disp.calls, ("restyle!", [argdict]))
    println("\nrestyle!")
    println(argdict)
end

@testset "stem plot construction" begin
    st = lstem()
    @test st[:type] == "scatter"

    data = rand(5)
    st = lstem(y=data)
    @test st[:type] == "scatter"
    @test st[:mode] == "markers"
    @test st[:hoverinfo] == "text"
    @test st[:y] == data
    @test st[:text] == data
    @test st[:marker][:size] == 10
    @test st[:error_y][:type] == "data"
    @test st[:error_y][:symmetric] == false
    @test st[:error_y][:array] == -min(data, 0)
    @test st[:error_y][:arrayminus] == max(data, 0)
    @test st[:error_y][:visible] == true
    @test st[:error_y][:color] == "grey"
    @test st[:error_y][:width] == 0
    @test st[:error_y][:thickness] == 1

    st = lstem(y=data, stem_color="red", stem_thickness=5)
    @test st[:error_y][:color] == "red"
    @test st[:error_y][:thickness] == 5

    @test_throws ErrorException stem(y=rand(5), mode="lines")
    @test_throws ErrorException stem(y=rand(5), error_y=attr(value=rand(5)))
end

@testset "stem plot restyling" begin
    data = rand(5)
    p = Plot(stem(y=data))

    data = rand(5)
    restyle!(p, y=[data])
    st = JSON.lower(p.data[1])
    @test st[:y] == data
    @test st[:error_y][:array] == -min(data, 0)
    @test st[:error_y][:arrayminus] == max(data, 0)

    restyle!(p, stem_thickness=5, stem_color="red")
    @test st[:error_y][:thickness] == 5
    @test st[:error_y][:color] == "red"
end

@testset "SyncPlot restyling" begin
    data = rand(5)
    syncplot = SyncPlot(Plot(stem(y=data)), MockPlotlyDisplay())

    data = rand(5)
    restyle!(syncplot, y=[data], stem_thickness=5, marker_color="red")
    st = JSON.lower(syncplot.plot.data[1])
    # first make sure the julia-side plot got updated
    @test st[:y] == data
    @test st[:error_y][:array] == -min(data, 0)
    @test st[:error_y][:arrayminus] == max(data, 0)
    @test st[:marker][:color] == "red"

    # make sure the right display function got called
    @test length(syncplot.view.calls) == 1
    call = syncplot.view.calls[1]
    @test call[1] == "restyle!"
    # TODO: currently any kwargs that are passed in get converted to strings,
    # and anything generated in the StemPlot handler is a symbol. We should
    # normalize that at some point
    @test call[2][1] == Dict(
        "y" => [data],
        :text => [data],
        "marker.color" => "red",
        :error_y => Dict(
            :type => "data",
            :symmetric => false,
            :array => -min(data, 0),
            :arrayminus => max(data, 0),
            :visible => true,
            :color => "grey",
            :width => 0,
            :thickness => 5))
    @test call[2][2] == 0
end

# TODO: this should live with the rest of scatter stuff
@testset "SyncPlot restyling of Scatter" begin
    data = rand(5)
    syncplot = SyncPlot(Plot(scatter(y=data)), MockPlotlyDisplay())

    data = rand(5)
    restyle!(syncplot, y=[data], marker_color="red")
    st = JSON.lower(syncplot.plot.data[1])
    # first make sure the julia-side plot got updated
    @test st[:y] == data
    @test st[:marker][:color] == "red"

    # make sure the right display function got called
    @test length(syncplot.view.calls) == 1
    call = syncplot.view.calls[1]
    @test call[1] == "restyle!"
    # TODO: currently any kwargs that are passed in get converted to strings,
    # and anything generated in the StemPlot handler is a symbol. We should
    # normalize that at some point
    @test call[2][1] == Dict(
        "y" => [data],
        "marker.color" => "red")
    @test call[2][2] == 0
end
