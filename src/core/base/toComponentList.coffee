toComponent = require './toComponent'

module.exports = toComponentList = (item) ->
  if !item then []

  else if item instanceof Array
    for e in item then toComponent(e)

  else [toComponent(item)]