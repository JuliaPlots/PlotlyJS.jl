# start with empty, it is easier to enumerate the true cases
to_date(x) = Nullable{Date}()

function to_date(x::AbstractString)
    # maybe it is yyyy
    if all(isdigit, x)
        return to_date(parse(Int, x))
    end

    # maybe it is yyyy-mm or yyyy-mm-dd
    parts = split(x, '-')
    nparts = length(parts)
    if nparts == 3
        try
            return Nullable{Date}(Date(x, "y-m-d"))
        catch
            return Nullable{Date}()
        end
    elseif nparts == 2
        try
            return Nullable{Date}(Date(x, "y-m"))
        catch
            return Nullable{Date}()
        end
    end

    # don't know how to handle anything else.
    return Nullable{Date}()
end

to_date(x::Union{Integer,Dates.TimeType}) = Nullable(Date(x))

function to_date{T,N}(x::AbstractArray{T,N})
    out_arr = Array{Date}(0)

    for i in x
        maybe_date = to_date(i)
        if isnull(maybe_date)
            return Nullable{Array{Date,N}}()
        else
            push!(out_arr, get(maybe_date))
        end
    end
    Nullable(reshape(out_arr, size(x)))
end

function to_date{T<:Dates.TimeType,N}(x::AbstractArray{T,N})
    Nullable(map(Date, x))
end

#=
I populated recession_dates.tsv with the following (ugly!!) code

```
rec = get_data(f, "USREC", observation_start="1776-07-04").df[[:date, :value]]
did_start = fill(false, size(rec, 1))
did_end = copy(did_start)
did_start[1] = rec[1, :value] == 1.0
continuing_recession = did_start[1]
for i in 2:length(did_start)
    if rec[i, :value] == 1.0 && !continuing_recession
        did_start[i] = true
        continuing_recession = true
    end

    if rec[i, :value] == 0.0 && continuing_recession
        did_end[i] = true
        continuing_recession = false
    end
end

start_dates = rec[did_start, :date]
end_dates = rec[did_end, :date]

out_path = Pkg.dir("PlotlyJS", "recession_dates.tsv")
writedlm(out_path, [start_dates end_dates])
```
=#
function _recession_band_shapes(p::Plot; kwargs...)
    # data is 2 column matrix, first column is start date, second column
    # is end_date
    data = map(Date, readdlm(
        joinpath(dirname(dirname(@__FILE__)), "recession_dates.tsv")
    ))::Matrix{Date}

    # need to over the x attribute of each trace and get the most extreme
    min_date = Date(500_000)
    max_date = Date(-500_000)
    dates_changed = false
    for t in p.data
        t_x = t[:x]
        if !isempty(t_x)
            maybe_dates = to_date(t_x)
            if isnull(maybe_dates)
                continue
            else
                dates = get(maybe_dates)
                if typeof(dates) <: AbstractArray
                    min_date = min(min_date, minimum(dates))
                    max_date = max(max_date, maximum(dates))
                    dates_changed = true
                end
            end
        end
    end
    if !dates_changed
        return Nullable{Vector{Shape}}()
    end
    ix1 = searchsortedfirst(data[:, 1], min_date)
    ix2 = searchsortedlast(data[:, 2], max_date)
    Nullable{Vector{Shape}}(
        rect(data[ix1:ix2, 1], data[ix1:ix2, 2], 0, 1;
             fillcolor="#E6E6E6", opacity=0.4, line_width=0, layer="below",
             xref="x", yref="paper", kwargs...)
    )
end

function add_recession_bands!(p::Plot; kwargs...)
    maybe_bands = _recession_band_shapes(p; kwargs...)
    if isnull(maybe_bands)
        return
    end
    bands = get(maybe_bands)

    # now we have some bands that we need to apply to the layout
    old_shapes = p.layout[:shapes]
    new_shapes = isempty(old_shapes) ? bands : vcat(old_shapes, bands)
    relayout!(p, shapes=new_shapes)
    new_shapes
end

function add_recession_bands!(p::SyncPlot; kwargs...)
    new_shapes = add_recession_bands!(p.plot; kwargs...)
    relayout!(p, shapes=new_shapes)
    new_shapes
end
