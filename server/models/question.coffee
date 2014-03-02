config = require 'config'
_ = require 'lodash'
fibrous = require 'fibrous'
Redis = require '../util/redis-adapter.coffee'
redis = new Redis config['redis']


class Question

  @cache = {}

  constructor: (question) ->
    ## extend instance with initial data
    _.extend this, question

    ## cache data to in-memory cache
    Question.cache[@id] = this

  toJSON: ()->
    id: @id
    q: @q
    options: _.shuffle @options

  checkAnwser: (ans)->
    ans is @options[0]

  ## class method (static method)
  @fromRedis = (id, cb)->
    key = "question:#{id}"
    redis.readJSON key, (err, question)->
      return cb err if err?
      cb null, new Question question

  @updateAll = (cb)->
    fibrous.run =>
      key = "questions"
      arrayId = redis.sync.readSet key

      @fromRedis.sync id for id in arrayId
    , cb

module.exports = Question