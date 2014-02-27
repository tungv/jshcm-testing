config = require 'config'
_ = require 'lodash'
Question = require './models/question.coffee'
random = require './util/random.coffee'

## create an express app
express = require 'express'
app = express()

Question.updateAll ()->
  app.listen config['port']
  console.log "app is listening on port: #{config['port']}"

## binding routes
app.get '/question/random/:count', (req, res)->
  count = req.params['count']
  allQuestions = Object.keys Question.cache
  pickedIdArray = random allQuestions, count
  pickedQuestions = pickedIdArray.map (id)-> Question.cache[id]

  res.json pickedQuestions