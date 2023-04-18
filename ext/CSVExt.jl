module CSVExt

using PlotlyJS
isdefined(Base, :get_extension) ? (using CSV) : (using ..CSV)

function PlotlyJS.dataset(::Type{CSV.File}, name::String)
    ds_path = PlotlyJS.check_dataset_exists(name)
    if !endswith(ds_path, "csv")
        error("Can only construct CSV.File from a csv data source")
    end
    CSV.File(ds_path)
end

end