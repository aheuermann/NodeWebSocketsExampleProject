socket = io.connect 'http://localhost:3000/'
data_display = $("#data")
characters = $("#characters")
chart = new ChartView "#chart"

socket.on 'update', (data) ->
    data_display.html(JSON.stringify(data, null, 4))
    dataArr = []
    for k,v of data
        dataArr.push {letter:k, value:v}
    chart.update dataArr
  
$("#send").click () ->
  socket.emit 'save', {message: characters.val()}
  characters.val ''

$("#toggleType").click () ->
  chart.toggleType()