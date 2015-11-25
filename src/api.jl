Base.size(p::Plot, w::Int, h::Int) = size(get_window(p), w, h)
Base.size(p::Plot) = (get(p.layout.fields, :width, 800),
                      get(p.layout.fields, :height, 450))
function Base.resize!(p::Plot)
    sz = size(p)
    size(p, sz[1]+10, sz[2]+25)
end
