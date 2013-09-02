class Dashing.Earthquake extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points')
    if points
      points[points.length - 1].y

  @accessor 'location', ->
    @get('place')
  
  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @earthquake = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      max: 10.3
      min: 0
      series: [
        {
        color: "#fff",
        data: [{x:0, y:0}]
        }
      ]
    )

    @earthquake.series[0].data = @get('points') if @get('points')
    
    format = (n) -> 
      map = {
        n: getTime(n).toString() 
        }
    
    x_axis = new Rickshaw.Graph.Axis.Time(graph: @earthquake, tickFormat: format)
    
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @earthquake, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    
    @earthquake.render()

  onData: (data) ->
    if @earthquake
      @earthquake.series[0].data = data.points
      @earthquake.render()
