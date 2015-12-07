Base.size(p::Plot) = (get(p.layout.fields, :width, 800),
                      get(p.layout.fields, :height, 450))

Base.resize!(p::Plot, w::Int, h::Int) = size(get_window(p), w, h)
function Base.resize!(p::Plot)
    sz = size(p)
    # this padding was found by trial and error to not show vertical or
    # horizontal scroll bars
    resize!(p, sz[1]+10, sz[2]+25)
end

for t in [:histogram, :scatter3d, :surface, :mesh3d, :bar, :histogram2d,
          :histogram2dcontour, :scatter, :pie, :heatmap, :contour,
          :scattergl, :box, :area, :scattergeo, :choropleth]
    str_t = string(t)
    @eval $t(;kwargs...) = GenericTrace($str_t; kwargs...)
    eval(Expr(:export, t))
end
