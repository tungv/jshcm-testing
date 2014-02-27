_ = require 'lodash'

module.exports = (array, pick)->
  shuffle = _.shuffle(array)
  shuffle[0..pick-1]