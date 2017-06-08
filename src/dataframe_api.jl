function GenericTrace{T<:AbstractString,T2<:Number}(x::AbstractArray{T},
                                                    y::AbstractArray{T2};
                                                    kind="scatter",
                                                    kwargs...)
    GenericTrace(kind; x=x, y=y, kwargs...)
end


"""
$(SIGNATURES)
Building a plot of one trace of type `scatter` setting `x` to x and `y` to y.
All keyword arguments are passed directly.

Method built specifically for time series, with x being an array of strings containing
datetime information, and y containing numerical data.
"""
function plot{T<:String,T2<:Number}(x::AbstractArray{T},
                                    y::AbstractArray{T2},
                                    l::Layout=Layout();
                                    style::Style=DEFAULT_STYLE[1],
                                    kwargs...)
    plot(GenericTrace(x, y; kwargs...), l, style=style)
end
#=
Note: This method is for a generic one dimensional line plot that can also handle the x argument being an array of datetimes.
Can also use this to "add a series from another dataframe
indexing out the rows I want" as per Erica's request via
ex. plot(df1[:date], df2[:obs_gdp][1:size(df1,1)])
=#

#=
Note: This method is for plotting input with a dataframe and symbol inputs, i.e.
    plot(df,x=:date,y=:gdp,marker_color=:blue)
Where the plot function automatically parses the statement to see whether the symbols
correspond with column names or generic arguments.
=#
function plot(df::AbstractDataFrame,
              l::Layout=Layout();
              style::Style=DEFAULT_STYLE[1],
              kwargs...)
    arg = []
    for i in kwargs
        if any(x->x==i[2], names(df))
            push!(arg,string(i[1],"=df[:",i[2],"], "))
        else
            push!(arg,string(i[1],"=:",i[2],", "))
        end
    end

    newarg = []
    argx = []
    argy = []
    for (i,item) in enumerate(arg)
        if item[1:2] == "x="
            argx = item[3:end]
        elseif item[1:2] == "y="
            argy = item[3:end]
        else
            push!(newarg,item)
        end
    end

    fin_arg = string("plot(",join([argx,argy,newarg[1]])[1:end-2],")")
    eval(parse(fin_arg))
end

#=
Note: This function is for plotting multiple columns of a dataframe on the same x axis variable, i.e. date.
Example:
list = [:gdp, :inflation, :unemployment]
plot(df, df[:date], list)
=#
function plot{T<:String}(df::AbstractDataFrame,
                         x::AbstractArray{T},
                         y::AbstractArray{Symbol},
                         l::Layout=Layout();
                         style::Style=DEFAULT_STYLE[1],
                         kwargs...)
    traces = GenericTrace[GenericTrace(x, df[y[i]]; kwargs...)
                          for i in 1:length(y)]
    plot(traces, l, style=style)
end

#=
FURTHER EXAMPLES:

Multidimensional Arrays
Example:
i = [1,2,3,4]
A = rand(4,4,4)
plot(i[1:3],A[[1,2,4],1,:])
Works already with the given implementation
=#

#=
Layering bar and scatter plots
Example:
b = bar(x=i, y=A[1,1,:])
s = scatter(x=i, y=A[2,1,:])
traces = [b,s]
plot(traces)
=#

#=
Making subplots
Example:
Horizontal: p = [plot(b), plot(s)]
Vertical: p = [plot(b) plot(s)]
=#
