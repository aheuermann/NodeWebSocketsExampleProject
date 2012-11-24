class DataManager
  data: {}
  add: (msg) ->
    chars = msg.replace(/\W/g, '')
    for char, index in chars.split ''
      @data[char] = if @data[char] then @data[char] + 1 else 1
    @data
  get: ()->
    @data

module.exports=DataManager