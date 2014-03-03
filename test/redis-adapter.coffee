config = require 'config'
Redis = require '../server/util/redis-adapter.coffee'
fibrous = require 'fibrous'

should = require('chai').should()
expect = require('chai').expect


describe "Redis Adapter", ->
  redis = null

  before (done) ->
    redis = new Redis config["redis"]
    redis.clear (err)->
      if err
        done err
      else
        done()

  describe "JSON", ->
    it "should be able to write and read JS object", (done)->
      circle=
        x: 10
        y: 5
        r: 10


      ## try to write JSON to redis
      redis.writeJSON "circle", circle, (err)->
        should.not.exist err, "writing should be done without any error"

        ## and then read it back
        redis.readJSON "circle", (err, data)->
          should.not.exist err, "reading should be done without any error"

          ## finally check if the same circle is returned
          circle.should.be.deep.equal data, "input must be deeply equal to output"
          done()


    it "should be able to write and read other JSON types", (done)->
      ## in this case we can use fibrous to simplify multiple async tests
      input = {
        array: [1,2,3,4]
        number: 10
        string: "abc"
        null: null
      }

      fibrous.run ->
        for key, value of input
          redis.sync.writeJSON key, value
          data = redis.sync.readJSON key
          expect(data).eql value, "input must be deeply equal to ouput for type=#{key}"

        done()

    ## this is an edge case so we should put it to a separated case so we can have special message
    it "should handle undefined as well", (done)->
      fibrous.run ->
        redis.sync.writeJSON "undef", undefined
        data = redis.sync.readJSON "undef"

        ## we cannot use should he because data can be null or undefined
        ## which don't have any prototype for chaijs to extend
        expect(data).to.be.an 'undefined', "maybe you forget to handle undefined"
        done()