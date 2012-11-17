socket = io.connect 'http://localhost:3000/'
data_display = $("#data")
characters = $("#characters")

socket.on 'update', (data) ->
  data_display.html(JSON.stringify(data, null, 4))
  graph data
  
$("#send").click () ->
  socket.emit 'save', {message: characters.val()}
  characters.val ''


chart = null
maxWidth=800
graph = (data) ->
  total = 0
  arr = []
  for k,v of data
    arr.push {letter:k, value:v}
    total += v
  
  unless chart
    container = d3.select "#chart"
    container.append "svg"
    chart = d3.select "#chart svg"
  bars = chart.selectAll("rect").data(arr)
    .enter().append("rect")
  chart.selectAll("rect")
    .attr("x", 15)
    .attr("y", (d,i) -> 
      return i*23 
    )
    .attr("height", 20) 
    .transition().duration(2000)
    .attr("width", (d,i) -> 
      return Math.floor(d.value/total*maxWidth)
    )
    
  text = chart.selectAll('text').data(arr).enter().append('text')
  chart.selectAll('text')
    .attr("x", (d,i) ->
      return 0
    )
    .attr("y", (d,i) -> 
      return i*23 + 15
    )
    .attr("width", (d,i) -> 
      return 20
    )
    .text((d) -> return d.letter)
  return