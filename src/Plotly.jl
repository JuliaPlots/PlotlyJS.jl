module Plotly

using JSON

plotly_js() = Pkg.dir("Plotly", "deps", "plotly-latest.min.js")

abstract AbstractPlotlyElement
abstract AbstractTrace <: AbstractPlotlyElement
abstract AbstractLayout <: AbstractPlotlyElement

type Plot
    data::Vector{AbstractTrace}
    layout::Vector{AbstractLayout}
    divid::Base.Random.UUID
end

Plot() = Plot([], [], Base.Random.uuid4())

function Base.writemime(io::IO, ::MIME"text/html", p::Plot)
    print(io, """
    <head>
       <script src="$(plotly_js())"></script>

       <div id="$(p.divid)" style="width:600px;height:250px;"></div>

       <script>
    	thediv = document.getElementById('$(p.divid)');
        var data = [{x: [1, 2, 3, 4, 5],
    	             y: [1, 2, 4, 8, 16] }];

        var layouts = { margin: { t: 0 } };

    	Plotly.plot(thediv, data,  layouts, {showLink: false});
    </script>
    </head>
    """)
end

p = Plot()

end # module
