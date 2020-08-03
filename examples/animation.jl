using PlotlyJS

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