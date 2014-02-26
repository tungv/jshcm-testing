config = require 'config'
Redis = require '../server/util/redis-adapter.coffee'
redis = new Redis config['redis']

questions = [
  {
    id: 1
    q: "What is the ouput of the following command: [] + []"
    options: [
      "empty string"
      "[][]"
      "NaN"
      "will throw error"
    ]
  }

  {
    id: 2
    q: "What is the ouput of the following command: [] + {}"
    options: [
      "[object Object]"
      "empty string"
      "[object Array]"
      "will throw error"
    ]
  }

  {
    id: 3
    q: "What is the ouput of the following command: {} + []"
    options: [
      "0"
      "NaN"
      "[object Array]"
      "will throw error"
    ]
  }

  {
    id: 4
    q: "What is the ouput of the following command: {} + {}"
    options: [
      "NaN"
      "0"
      "[object Object]"
      "will throw error"
    ]
  }
]

module.exports = (cb)->
  require('fibrous').run ->
    redis.clear() ## no .sync here because clear() doesn't take a callback
    for question in questions
      id = question.id
      redis.sync.writeJSON "question:#{id}", question
      redis.sync.pushSet "questions", id

    return questions
  , cb