{ keys, getFirstKey, stateOf } = require './utils'

# settle takes a rule object which is generated
# by `checkrule` helper, and a data to check given
# rule on it. also _target is provided as last
# parameter which provides path of given data
# for suggestion informations if needed.
module.exports = settle = (rule, data, _target) ->

  res = do -> switch rule.func

    when '$typeof'
      if rule.val is 'array'
      then res = Array.isArray data
      else res = typeof data is rule.val
      message  = "type of #{_target} #{stateOf res} '#{rule.val}'"
      return [ res, message ]

    when '$length'
      if typeof rule.val is 'object'
        rule.func = getFirstKey rule.val
        rule.val  = rule.val[rule.func]
        return settle rule, (keys data).length, "#{_target}.length"
      data    = keys data  if typeof data is 'object'
      res     = data.length is rule.val
      data    = data.length
      message = "length of #{_target} #{stateOf res} #{rule.val}"
      return [ res, message ]

    when '$gt'
      res      = data > rule.val
      message  = "#{_target} #{stateOf res} greater than #{rule.val}"
      rule.val = "greater than #{rule.val}"
      return [ res, message ]

    when '$gte'
      res      = data >= rule.val
      message  = "#{_target} #{stateOf res} greater than equal #{rule.val}"
      rule.val = "greater than equal #{rule.val}"
      return [ res, message ]

    when '$lt'
      res      = data < rule.val
      message  = "#{_target} #{stateOf res} less than #{rule.val}"
      rule.val = "less than #{rule.val}"
      return [ res, message ]

    when '$lte'
      res      = data <= rule.val
      message  = "#{_target} #{stateOf res} less than or equal #{rule.val}"
      rule.val = "less than equal #{rule.val}"
      return [ res, message ]

    when '$keys'
      unless typeof data is 'object'
        return [ no, "key '#{key}' is not an object" ]
      for key in keys data
        if key not in rule.val
          data = key
          return [ no, "key '#{key}' of #{_target} is not allowed" ]
      return [ yes, "all keys of #{_target} are allowed" ]

    when '$eq'
      res      = data is rule.val
      message  = "#{_target} #{stateOf res} equal to #{rule.val}"
      rule.val = "#{rule.val}"
      return [ res, message ]

    when '$in'
      res      = data in rule.val
      message  = "#{_target} #{stateOf res} valid"
      rule.val = "#{rule.val}"
      return [ res, message ]

    else
      if data is rule.val
        return [ yes, "#{_target} is valid" ]
      if data in rule.val
        return [ yes, "#{_target} is described in #{rule.val}" ]
      return [ no, "#{_target} is not valid" ]

  res.push data

  return res
