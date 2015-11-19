Base.size(p::Plot, w::Int, h::Int) = size(get_window(p), w, h)
Base.size(p::Plot) = (p.layout.width, p.layout.height)
Base.resize!(p::Plot) = size(p, map(x->x+25, size(p))...)
