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

  describe "load data for the first time", ->
    ## using a hook here so we can run test cases synchronously
    before (done)->
      Question.updateAll (err)->
        if err then done false else done()

    it "updateAll()", ->
      Object.keys(Question.cache).length.should.equal 4, "Four sample questions should be loaded"

      ## an example of what is not necessary
      ## since updateAll() does no more than just reading and we tested redis-adapter
      for question in sampleData
        id = question.id
        question.should.be.eql Question.cache[id]

