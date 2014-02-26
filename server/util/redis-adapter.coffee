redis = require 'redis'

class RedisAdapter
  constructor: ({host, port})->
    @client = redis.createClient port, host

  destroy: ->
    @client.close()

  clear: (cb)->
    @client.flushall(cb)

  readSet: (key, cb)->
    @client.smembers key, cb

  readJSON: (key, cb)->
    @client.get key, (err, str)->
      return cb err if err?

      ## need to check undefined case
      return cb null, undefined if str is "undefined"

      try
        data = JSON.parse str
        cb null, data
      catch ex
        cb ex

  pushSet: (key, value, cb)->
    @client.sadd key, value, cb

  writeJSON: (key, value, cb)->
    ## without this line it will throw error when value=undefined
    str = if value is undefined then "undefined"  else str = JSON.stringify value

    @client.set key, str, cb


## export
module.exports = RedisAdapter


