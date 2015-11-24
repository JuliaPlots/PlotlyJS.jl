module TestGenerate

using Base.Test
using JSON

include(Pkg.dir("Plotlyjs", "src", "generate.jl"))

typealias M GeneratePlotly

# make sure we still understand the schema
@test M.verify_schema_knowledge()

# test cmp for AbstractOpts
@test M._Dflt(1) < M._NoBlank(true)
@test M._Dflt(1) > M._ArrayOk(true)
@test !(M._Dflt(1) < M._Dflt(1))
@test (M._Dflt(1) <= M._Dflt(1))

# test cmp for AbstractOpts
@test M._Angle() < M._Flaglist()
@test M._Angle() < M._Colorscale()
@test !(M._Angle() < M._Angle())
@test (M._Angle() <= M._Angle())

# test equality on AbstractOpt
let
    opts = subtypes(M.AbstractOpt)
    opt1 = opts[1]
    for opt in opts[2:end]
        @test !(opt1(1) == opt(1.0))
        @test opt(1) == opt(1.0)
    end
end

# test cmp on ValAttributeDescription
let
    vts = sort([i() for i in subtypes(M.AbstractValType)])
    for vt in vts[2:end]
        v1 = M.ValAttributeDescription(:a, :b, vts[1], M.AbstractOpt[], "")
        v2 = M.ValAttributeDescription(:a, :b, vt, M.AbstractOpt[], "")
        @test v1 < v2
    end
end

# test equality on ValAttributeDescription and ObjectAttributeDescription
let
    vts = sort([i() for i in subtypes(M.AbstractValType)])
    for vt in vts[2:end]
        v1 = M.ValAttributeDescription(:a, :b, vts[1], M.AbstractOpt[], "")
        v2 = M.ValAttributeDescription(:a, :b, vt, M.AbstractOpt[], "")
        @test v1 != v2
        @test v2 == v2

        o1 = M.ObjectAttributeDescription(:foo, [v1, v2], :object, "")
        o2 = M.ObjectAttributeDescription(:bar, [v1, v2], :object, "")
        o3 = M.ObjectAttributeDescription(:bar, [v1, v2], :info, "")
        o4 = M.ObjectAttributeDescription(:bar, [v1, v2], :info, "hi")
        o5 = M.ObjectAttributeDescription(:bar, [v2, v1], :info, "hi")

        @test o1 != o2
        @test o1 != o3
        @test o1 != o4
        @test o1 != o5
        @test o2 != o3
        @test o2 != o4
        @test o2 != o5
        @test o3 != o4
        @test o3 != o5
        @test o4 == o5  # test that sorting the fields works

        [@test o == o for o in (o1, o2, o3, o4, o5)]
    end
end


end  # module
