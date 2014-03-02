config = require 'config'
_ = require 'lodash'
Question = require './models/question.coffee'
random = require './util/random.coffee'

## create an express app
express = require 'express'
app = express()
app.use(express.bodyParser())

app.set 'env', process.env.NODE_ENV || 'development'

## binding routes
app.get '/question/random/:count', (req, res)->
  count = req.params['count']
  allQuestions = Object.keys Question.cache
  pickedIdArray = random allQuestions, count
  pickedQuestions = pickedIdArray.map (id)-> Question.cache[id]

  res.json pickedQuestions

app.post '/question/:id/isCorrect', (req, res)->
  answer = req.body['answer']
  id = req.paramsp['id']
  question = Question.cache[id]

  unless question
    res.send(404)
    return

  res.json {
    answer,
    correct: answer is question.options[0]
  }

module.exports = app

noop = ->

app.start = (cb=noop)->
  Question.updateAll (err)->
    return cb err if err?

    app.listen config['port']
    console.log "app is listening on port: #{config['port']} - mode: #{app.get 'env'}"
    cb null