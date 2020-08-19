```julia
function animation()
     # create the initial plot 
     traces = [scatter(;name="Slope = 1",marker_color="red",x=1:5,y=1:5), 
               scatter(;name="Slope = -1",marker_color="blue",x=1:5,y=5:-1:1)]

     # create frames
     m = 1:10
     frames = Vector{PlotlyFrame}(undef, 10)
     for i in m 
     frames[i] = frame(name="$i",
                         data=[attr(name="Slope = $i", y=i*(1:5)),      # data array must have as many attributes as there are traces for expected behavior
                              attr(name="Slope = -$i", y=i*(5:-1:1))]) # it is not necessary to update every field in each trace, but only the fields that are changing
     end

     # create layout with pause play, buttons, slider to use frames
     layout = Layout(title="Animation Example",
                    yaxis=attr(autorange=false, range=[0,51]),
                    updatemenus=[attr(x=0,
                                   y=0,
                                   xanchor="left",
                                   yanchor="top",
                                   method="animate",
                                   type="buttons",
                                   direction="left",
                                   buttons=[attr(method="animate",
                                                  label="Play",
                                                  args=[nothing, # nothing is translated into javascript NULL and in this case mean to turn on animation
                                                       attr(mode="immediate",
                                                            
                                                            fromcurrent="true",
                                                            transition=attr(duration=300),
                                                            frame=attr(duration=500, 
                                                                      redraw=true)
                                                            )
                                                       ]
                                                  ),
                                             attr(method="animate",
                                                  label="Pause",
                                                  args=[[nothing], # [nothing] is translated into javascript [NULL] and in this case mean to turn off animation
                                                            attr(mode="immediate",
                                                                 fromcurrent="true",
                                                                 transition=attr(duration=300),
                                                                 frame=attr(duration=500, 
                                                                           redraw=true)
                                                                 )
                                                       ]
                                                  )
                                             ]
                                   )
                              ],
                    sliders=[attr(active=0, 
                                   pad=attr(l=200, t=55), 
                                   currentvalue=attr(visible=true, 
                                                  xanchor="right", 
                                                  prefix="slope: "),
                                   steps=[attr(label=i,
                                             method="animate",
                                             args=[["$i"], # match the frame[:name] with the first element of this array
                                                  attr(mode="immediate",
                                                       transition=attr(duration=300),
                                                       frame=attr(duration=500, 
                                                                 redraw=true)
                                                       )
                                                  ]
                                             ) 
                                        for i in m ]
                                   )
                              ]
                    )

     plot(traces, layout, frames)
end
animation()
```


<script>
    gd = (function() {
  var WIDTH_IN_PERCENT_OF_PARENT = 100;
  var HEIGHT_IN_PERCENT_OF_PARENT = 100;
  var gd = Plotly.d3.select('body')
    .append('div').attr("id", "6dbb2463-40c0-4589-b851-fa255550e3c1")
    .style({
      width: WIDTH_IN_PERCENT_OF_PARENT + '%',
      'margin-left': (100 - WIDTH_IN_PERCENT_OF_PARENT) / 2 + '%',
      height: HEIGHT_IN_PERCENT_OF_PARENT + 'vh',
      'margin-top': (100 - HEIGHT_IN_PERCENT_OF_PARENT) / 2 + 'vh'
    })
    .node();
  var plot_json = {"layout":{"margin":{"l":50,"b":60,"r":50,"t":60},"title":"Animation Example","yaxis":{"range":[0,51],"autorange":false},"sliders":[{"pad":{"l":200,"t":55},"active":0,"currentvalue":{"xanchor":"right","prefix":"slope: ","visible":true},"steps":[{"method":"animate","label":1,"args":[["1"],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500}}]},{"method":"animate","label":2,"args":[["2"],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500}}]},{"method":"animate","label":3,"args":[["3"],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500}}]},{"method":"animate","label":4,"args":[["4"],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500}}]},{"method":"animate","label":5,"args":[["5"],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500}}]},{"method":"animate","label":6,"args":[["6"],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500}}]},{"method":"animate","label":7,"args":[["7"],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500}}]},{"method":"animate","label":8,"args":[["8"],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500}}]},{"method":"animate","label":9,"args":[["9"],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500}}]},{"method":"animate","label":10,"args":[["10"],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500}}]}]}],"updatemenus":[{"yanchor":"top","xanchor":"left","method":"animate","y":0,"type":"buttons","buttons":[{"method":"animate","label":"Play","args":[null,{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500},"fromcurrent":"true"}]},{"method":"animate","label":"Pause","args":[[null],{"mode":"immediate","transition":{"duration":300},"frame":{"redraw":true,"duration":500},"fromcurrent":"true"}]}],"direction":"left","x":0}]},"frames":[{"name":"1","data":[{"y":[1,2,3,4,5],"name":"Slope = 1"},{"y":[5,4,3,2,1],"name":"Slope = -1"}]},{"name":"2","data":[{"y":[2,4,6,8,10],"name":"Slope = 2"},{"y":[10,8,6,4,2],"name":"Slope = -2"}]},{"name":"3","data":[{"y":[3,6,9,12,15],"name":"Slope = 3"},{"y":[15,12,9,6,3],"name":"Slope = -3"}]},{"name":"4","data":[{"y":[4,8,12,16,20],"name":"Slope = 4"},{"y":[20,16,12,8,4],"name":"Slope = -4"}]},{"name":"5","data":[{"y":[5,10,15,20,25],"name":"Slope = 5"},{"y":[25,20,15,10,5],"name":"Slope = -5"}]},{"name":"6","data":[{"y":[6,12,18,24,30],"name":"Slope = 6"},{"y":[30,24,18,12,6],"name":"Slope = -6"}]},{"name":"7","data":[{"y":[7,14,21,28,35],"name":"Slope = 7"},{"y":[35,28,21,14,7],"name":"Slope = -7"}]},{"name":"8","data":[{"y":[8,16,24,32,40],"name":"Slope = 8"},{"y":[40,32,24,16,8],"name":"Slope = -8"}]},{"name":"9","data":[{"y":[9,18,27,36,45],"name":"Slope = 9"},{"y":[45,36,27,18,9],"name":"Slope = -9"}]},{"name":"10","data":[{"y":[10,20,30,40,50],"name":"Slope = 10"},{"y":[50,40,30,20,10],"name":"Slope = -10"}]}],"data":[{"x":[1,2,3,4,5],"y":[1,2,3,4,5],"type":"scatter","name":"Slope = 1","marker":{"color":"red"}},{"x":[1,2,3,4,5],"y":[5,4,3,2,1],"type":"scatter","name":"Slope = -1","marker":{"color":"blue"}}]};
  Plotly.newPlot(gd, plot_json);
  window.onresize = function() {
    Plotly.Plots.resize(gd);
  };
  return gd;
})();

 </script>



