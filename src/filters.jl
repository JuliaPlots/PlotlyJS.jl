# ------------------- #
# Pre-display filters #
# ------------------- #

const _pre_json_filters = Dict{Symbol,Function}()


function set_color_cycle!(colors::Vector)
    n = length(colors)

    function _cycle!(p::Plot)
        ix = 1
        for t in p.data
            if haskey(t["marker"], :color)
                # don't override if the user already set this
                continue
            else
                t["marker.color"] = colors[ix]
                ix = ix == n ? 1 : ix + 1
            end
        end
    end

    _pre_json_filters[:color_cycle] = _cycle!
end

function set_layout_defaults!(l::Layout)

    function _update_layout!(p::Plot)
        # list p.layout last to preserve settings the user manually applied
        p.layout.fields = merge(l, p.layout)
    end
    _pre_json_filters[:layout_defaults] = _update_layout!
end

reset_color_cycle!() =
    (pop!(_pre_json_filters, :color_cycle, nothing); nothing)

reset_layout_defaults!() =
    (pop!(_pre_json_filters, :layout_defaults, nothing); nothing)

function use_style!(sty::Symbol)
    if sty == :ggplot
        axis_attrs = attr(showgrid=true, gridcolor="white", linewidth=1.0,
                          linecolor="white", titlefont_color="#555555",
                          titlefont_size=12, ticks="outside",
                          tickcolor="#555555"
                          )
        layout = Layout(Dict{Symbol,Any}(:plot_bgcolor => "#E5E5E5",
                                         :paper_bgcolor => "white");
                        font_size=10,
                        xaxis=axis_attrs,
                        yaxis=axis_attrs,
                        titlefont_size=14)
        set_layout_defaults!(layout)
        set_color_cycle!(["#E24A33", "#348ABD", "#988ED5", "#777777",
                          "#FBC15E", "#8EBA42", "#FFB5B8"])
    elseif sty == :default
        reset_layout_defaults!()
        reset_color_cycle!()
    else
        error("Uknown style $sty")
    end

end
