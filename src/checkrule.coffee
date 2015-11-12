{ rtrim, getAt, keys, getFirstKey } = require './utils'
settle = require './settle'

# Single rule checker for given target
# It's allowing a third parameter for overriding
# data in it in case of recursive calls
module.exports = checkRule = (rule, target, custom) ->

  # we need a `path` to execute rule on it
  path = custom?.path ? getFirstKey rule

  # this is the function that we run on the target
  # it needs to start with $ sign
  func = custom?.func ? (/(\$\w+)/g.exec path)?[0]

  # expected value which is coming from the rule
  # - this is only for recursive calls
  val = custom?.val

  # we need to iterate more to get the requested
  # function for given path
  unless func

    # internal rule set from the current path
    $rule = rule[path]

    # if there are multiple rules for a given path
    # we need to execute all of them individually
    # and return the whole result at once ...
    if Array.isArray $rule
      res = []

      # .. to be able to do that we are checking all
      # rules by calling this function recursively ...
      for r in $rule
        rkey = getFirstKey r

        # following check allows us to check one more
        # depth if it's defined in the ruleset.
        if rkey[0] is '$'
          res.push checkRule r, target, {
            path: "#{path}.#{rkey}", val: r[rkey]
          }

        else
          _rkey = getFirstKey r[rkey]
          res.push checkRule r, target, {
            path: "#{path}.#{rkey}.#{_rkey}",
            val: r[rkey][_rkey]
          }

      # ... and returning the result when all is done.
      return res

    # if there is only one rule then we are taking
    # into account that one only
    else if typeof $rule is 'object'
      func = getFirstKey $rule
      val  = $rule[func]

  # if we do have a func to run then we need to
  # have a value to compare
  else
    val  = custom?.val ? rule[path]
    # we need to remove inline function from the path
    path = rtrim (path.replace func, ''), '.'

  # we now have a rule object to go on
  rule = { path, val, func }

  # if path is defined correctly we can extract the
  # data from target with rule.path
  if rule.path

    # if we have a * request in path, we need to
    # execute all the rules underneath
    if (rule.path.indexOf '*') > -1

      # get the base and rest path for suggestions
      [ base, rest ] = (rule.path.split '*').map (x) -> rtrim x, '.'

      # get the data of first part before * definition
      # TODO: add ability to allow multiple * usages
      data = getAt target, base
      res  = []

      # after fetching items under * definition
      # recursively calling same rule on each data
      for key of data
        cpath = "#{base}.#{key}#{rest}"
        res.push checkRule rule, target, {
          path: cpath, val: rule.val, func: rule.func
        }

      # if there is a result to return
      return res  if res.length > 0

    # get the data for given rule.path
    # this only valid for arrays and objects
    data = getAt target, rule.path

    # based on the rule data might not be there
    # which is also counting as an error
    unless data?
      res = [[ no, "no data found at #{rule.path}", { rule, data, target } ]]
      return if custom? then res[0] else res

    # and if we have a data from that path
    # we can use this path as _target identifier
    _target = rule.path

  # otherwise we need to use target itself as
  # target data, this happens if you want to run
  # a rule on the given target itself
  else
    data    = target
    _target = 'given object'

  # we now have a function, rule value and a target
  # to check provided rule on it, `settle` will return
  # status, message and a new copy of used data
  [ res, message, data ] = settle rule, data, _target

  # each response consists of an array in an array
  _res = [ [ res, message, { rule, data, target } ] ]

  # but we need to have a flatten arrays for recursive
  # calls which can be checked from custom argument existence
  _res = _res[0]  if custom?

  return _res
