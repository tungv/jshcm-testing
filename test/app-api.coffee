app = require '../server/app.coffee'
request = require 'request'
config = require 'config'

setup = require './setup.coffee'
should = require('chai').should()

describe 'API', ->
  ## before doing anything, init mockup data in redis
  before (done)->
    setup (err)->
      if err? then done err else done()

  ## then start app
  before (done)->
    app.start (err)->
      if err? then done err else done()

  ## close port after tests done
  after -> app.close()

  ## begin to test
  describe "GET /question/random/3", ->
    resp = {}
    body = {}

    uri = "http://localhost:#{config['port']}/question/random/3"

    before (done)->
      request uri, (err, _resp, _body)->
        should.not.exist err, "should be able to connect to local server"
        resp = _resp
        body = _body
        done()

    it 'should return 200 HTTP code', -> resp.statusCode.should.equal 200
    it 'should return valid JSON string', -> body = JSON.parse body
    it 'should return 3 questions', ->
      body.length.should.equal 3
      for question in body
        ## property existence validation
        should.exist question.id, "questions must have id"
        should.exist question.q, "questions must have q"
        should.exist question.options, "questions must have options"

        ## type validation
        question.id.should.be.a 'number'
        question.q.should.be.a 'string'
        question.options.should.be.an 'array'

        ## other validation
        question.options.length.should.equal 4, 'each questions should have 4 options'
        question.options.forEach (opt)-> opt.should.be.a 'string'

