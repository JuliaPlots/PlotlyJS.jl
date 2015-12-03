Base.size(p::Plot, w::Int, h::Int) = size(get_window(p), w, h)
Base.size(p::Plot) = (get(p.layout.fields, :width, 800),
                      get(p.layout.fields, :height, 450))
function Base.resize!(p::Plot)
    sz = size(p)
    size(p, sz[1]+10, sz[2]+25)
end

for t in [:histogram, :scatter3d, :surface, :mesh3d, :bar, :histogram2d,
          :histogram2dcontour, :scatter, :pie, :heatmap, :contour,
          :scattergl, :box, :area, :scattergeo, :choropleth]
    str_t = string(t)
    @eval $t(;kwargs...) = GenericTrace($str_t; kwargs...)
    eval(Expr(:export, t))
end
