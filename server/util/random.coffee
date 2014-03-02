_ = require 'lodash'

module.exports = (array, pick)->
  shuffle = _.shuffle(array)[0..pick-1]
  i=0;
  while shuffle.length < pick
    shuffle.push shuffle[i++]

  return shuffle