Question = require '../server/models/question.coffee'
setup = require './setup.coffee'
config = require 'config'

describe "Models/Question", ->
  sampleData = []

  ## setup environment with sample data
  before (done)->
    setup (err, data)->
      if err
        done false
      else
        done()
        sampleData = data

  describe "updateAll()", ->
    ## using a hook here so we can run test cases synchronously
    before (done)->
      Question.updateAll (err)->
        if err then done false else done()

    it "should cache 4 questions from redis", ->
      Object.keys(Question.cache).length.should.equal 4, "Four sample questions should be loaded"

      for question in sampleData
        id = question.id
        cached = Question.cache[id]
        'id options q'.split(' ').forEach (prop)->
          question[prop].should.be.eql cached[prop], "#{prop} should be the same"

