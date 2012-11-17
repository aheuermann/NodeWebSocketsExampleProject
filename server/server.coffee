handler = (request, response) ->
  request.addListener "end", ->
    fileServer.serve request, response

app = require("http").createServer(handler)
io = require("socket.io").listen(app)

static_ = require("node-static")

fileServer = new static_.Server("../public")

app.listen 3000

io.set "log level", 1

data = {}
clients = []

# Listen for incoming connections from clients
io.sockets.on "connection", (client) ->
  clients.push client
  client.emit 'update', data
  client.on "save", (msg) ->
    for char, index in msg.message.split ''
      data[char] = if data[char] then data[char] + 1 else 1
    client.emit 'update', data
    client.broadcast.emit 'update', data
  client.on 'disconnect', () ->
    clients.splice(clients.indexOf client, 1)