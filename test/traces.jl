module TestTraces

using Base.Test
import Plotlyjs
typealias M Plotlyjs

gt = M.GenericTrace("scatter"; x=1:10, y=sin(1:10))
@test sort(collect(keys(gt.fields))) == [:x, :y]

# test setindex! methods
gt[:visible] = true
@test length(gt.fields) == 3
@test haskey(gt.fields, :visible)
@test gt.fields[:visible] == true

# now try with string. Make sure it updates inplace
gt["visible"] = false
@test length(gt.fields) == 3
@test haskey(gt.fields, :visible)
@test gt.fields[:visible] == false

# -------- #
# 2 levels #
# -------- #
gt[:line, :color] = "red"
@test length(gt.fields) == 4
@test haskey(gt.fields, :line)
@test isa(gt.fields[:line], Dict)
@test gt.fields[:line][:color] == "red"

# now try string version
gt["line", "color"] = "blue"
@test length(gt.fields) == 4
@test haskey(gt.fields, :line)
@test isa(gt.fields[:line], Dict)
@test gt.fields[:line][:color] == "blue"

# now try convenience string dot notation
gt["line.color"] = "green"
@test length(gt.fields) == 4s
@test haskey(gt.fields, :line)
@test isa(gt.fields[:line], Dict)
@test gt.fields[:line][:color] == "green"

# -------- #
# 3 levels #
# -------- #
gt[:marker, :line, :color] = "red"
@test length(gt.fields) == 5
@test haskey(gt.fields, :marker)
@test isa(gt.fields[:marker], Dict)
@test haskey(gt.fields[:marker], :line)
@test isa(gt.fields[:marker][:line], Dict)
@test haskey(gt.fields[:marker][:line], :color)
@test gt.fields[:marker][:line][:color] == "red"

# now try string version
gt["marker", "line", "color"] = "blue"
@test length(gt.fields) == 5
@test haskey(gt.fields, :marker)
@test isa(gt.fields[:marker], Dict)
@test haskey(gt.fields[:marker], :line)
@test isa(gt.fields[:marker][:line], Dict)
@test haskey(gt.fields[:marker][:line], :color)
@test gt.fields[:marker][:line][:color] == "blue"

# now try convenience string dot notation
gt["marker.line.color"] = "green"
@test length(gt.fields) == 5
@test haskey(gt.fields, :marker)
@test isa(gt.fields[:marker], Dict)
@test haskey(gt.fields[:marker], :line)
@test isa(gt.fields[:marker][:line], Dict)
@test haskey(gt.fields[:marker][:line], :color)
@test gt.fields[:marker][:line][:color] == "green"

# -------- #
# 4 levels #
# -------- #
gt[:marker, :colorbar, :tickfont, :family] = "Hasklig-ExtraLight"
@test length(gt.fields) == 5  # notice we didn't add another top level key
@test haskey(gt.fields, :marker)
@test isa(gt.fields[:marker], Dict)
@test length(gt.fields[:marker]) == 2  # but we did add a key at this level
@test haskey(gt.fields[:marker], :colorbar)
@test isa(gt.fields[:marker][:colorbar], Dict)
@test haskey(gt.fields[:marker][:colorbar], :tickfont)
@test isa(gt.fields[:marker][:colorbar][:tickfont], Dict)
@test haskey(gt.fields[:marker][:colorbar][:tickfont], :family)
@test gt.fields[:marker][:colorbar][:tickfont][:family] == "Hasklig-ExtraLight"

# now try string version
gt["marker", "colorbar", "tickfont", "family"] = "Hasklig-Light"
@test length(gt.fields) == 5
@test haskey(gt.fields, :marker)
@test isa(gt.fields[:marker], Dict)
@test length(gt.fields[:marker]) == 2
@test haskey(gt.fields[:marker], :colorbar)
@test isa(gt.fields[:marker][:colorbar], Dict)
@test haskey(gt.fields[:marker][:colorbar], :tickfont)
@test isa(gt.fields[:marker][:colorbar][:tickfont], Dict)
@test haskey(gt.fields[:marker][:colorbar][:tickfont], :family)
@test gt.fields[:marker][:colorbar][:tickfont][:family] == "Hasklig-Light"

# now try convenience string dot notation
gt["marker.colorbar.tickfont.family"] = "Hasklig-Medium"
@test length(gt.fields) == 5  # notice we didn't add another top level key
@test haskey(gt.fields, :marker)
@test isa(gt.fields[:marker], Dict)
@test length(gt.fields[:marker]) == 2  # but we did add a key at this level
@test haskey(gt.fields[:marker], :colorbar)
@test isa(gt.fields[:marker][:colorbar], Dict)
@test haskey(gt.fields[:marker][:colorbar], :tickfont)
@test isa(gt.fields[:marker][:colorbar][:tickfont], Dict)
@test haskey(gt.fields[:marker][:colorbar][:tickfont], :family)
@test gt.fields[:marker][:colorbar][:tickfont][:family] == "Hasklig-Medium"

# error on 5 levels
Test.@test_throws gt["marker.colorbar.tickfont.family.foo"] = :bar

end  # module
