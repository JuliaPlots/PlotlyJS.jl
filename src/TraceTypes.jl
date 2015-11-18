#
# Plotly Enumerated Types
#

type PlotlyVisible
    myvalue

    function PlotlyVisible(x)
        validvalues = [true, false, "LegendOnly"]
        if !(x ∈ validvalues)
            morestr = join(validvalues, "\n\t-")
            msg = "This object must take one of the values from \n\t-$(morestr)"
            error(msg)
        end
        new(x)
    end
end
