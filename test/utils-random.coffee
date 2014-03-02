random = require '../server/util/random.coffee'
expect = require('chai').expect

describe "Util/Random", ->
  describe 'random(Array<any> array, Integer pick)', ->

    array = [1,2,3,4,5,6,7,8,9,10]

    testCases = [
      {pick: 1, repeat: 1000, range: .3}
      {pick: 1, repeat: 10000, range: .1}
      {pick: 4, repeat: 1000, range: .1}
      {pick: 10, repeat: 10000, range: .1}
      {pick: 15, repeat: 10000, range: .1}
    ]

    for testCase in testCases
      ## should be almost equally distributed
      pick = testCase.pick
      repeat = testCase.repeat
      idealEach = repeat / array.length * pick
      min = idealEach * (1 - testCase.range)
      max = idealEach * (1 + testCase.range)

      #console.log 'ideal each', idealEach

      it "(pick=#{testCase.pick}, repeat=#{testCase.repeat}, range=#{testCase.range * 100}%)", ->
        results = {}

        for i in [1..repeat]
          picked = random array, pick
#          console.log "picked", picked
          picked.forEach (result)->
            results[result] = results[result] ? 0
            results[result]++

#        console.log 'results', results

        for number, result of results
          #console.log "#{min} < #{result} < #{max}"
          expect(min < result < max).to.be.true
