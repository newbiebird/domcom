{extend} = dc = require('./domcom-basic')

dc.builtinDirectives = require('./directives/index')

extend(dc,
  dc.builtinDirectives
  require('./builtins/index')
  require('./core/prop-util')
)


{flow} = dc
extend(flow,
  require('lazy-flow/addon')
  require('dc-watch-list')
)

dc.bindings = flow.bindings

module.exports = dc
