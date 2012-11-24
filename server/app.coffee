DataManager = require ('./data-manager')

handler = (request, response) ->
  request.addListener "end", ->
    fileServer.serve request, response

app = require("http").createServer(handler)
io = require("socket.io").listen(app)

static_ = require("node-static")

fileServer = new static_.Server(__dirname + "/../public")

app.listen 3000

io.set "log level", 1

dataManager = new DataManager
clients = []

# Listen for incoming connections from clients
io.sockets.on "connection", (client) ->
  clients.push client
  client.emit 'update', dataManager.get
  client.on "save", (msg) ->
    data = dataManager.add msg.message
    client.emit 'update', data
    client.broadcast.emit 'update', data
  client.on 'disconnect', () ->
    clients.splice(clients.indexOf client, 1)