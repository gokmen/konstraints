# konstraints takes a target object and rules object
# to check if target object fits with the given rules
#
# for given example;
# ------------------------------------
# target  =
#   foo   :
#     bar : 42
#   baz   :
#     one : 1
#     two : 2
#
# rules   = [
#   { $typeof: 'object' }
#   { $keys: [ 'foo', 'baz' ] }
#   { 'foo': { $keys: [ 'bar' ] } }
#   {
#     'foo.bar': [
#       { $eq: 42 }
#       { $lt: 44 }
#     ]
#   }
#   { 'baz': { $length: 2 } }
#   { 'baz.*': { $gt: 0 } }
# ]
#
# konstraints = require 'konstraints'
# res = konstraints target, rules, log: yes
# ------------------------------------
#
# it will generate following output;
#
#   ✓ type of given object is 'object'
#   ✓ all keys of given object are allowed
#   ✓ all keys of foo are allowed
#   ✓ foo.bar is equal to 42
#   ✓ foo.bar is less than 44
#   ✓ length of baz is 2
#   ✓ baz.one is greater than 0
#   ✓ baz.two is greater than 0
#
#   ✓ ALL PASSED!
#
# and variable res will become;
#
# [
#   [ true,
#     'type of given object is \'object\'',
#     { rule: [Object], data: [Object], target: [Object] } ],
#   [ true,
#     'all keys of given object are allowed',
#     { rule: [Object], data: [Object], target: [Object] } ],
#   [ true,
#     'all keys of foo are allowed',
#     { rule: [Object], data: [Object], target: [Object] } ],
#   [ true,
#     'foo.bar is equal to 42',
#     { rule: [Object], data: 42, target: [Object] } ],
#   [ true,
#     'foo.bar is less than 44',
#     { rule: [Object], data: 42, target: [Object] } ],
#   [ true,
#     'length of baz is 2',
#     { rule: [Object], data: 2, target: [Object] } ],
#   [ true,
#     'baz.one is greater than 0',
#     { rule: [Object], data: 1, target: [Object] } ],
#   [ true,
#     'baz.two is greater than 0',
#     { rule: [Object], data: 2, target: [Object] } ]
# ]

{ flatten, resultsLogger } = require './utils'
checkRule = require './checkrule'

module.exports = konstraints = (target, rules, options) ->

  passed  = yes
  results = []

  options             ?= {}
  options.log         ?= no
  options.logDefaults ?= no
  options.checkAll    ?= no

  for rule in rules

    ruleResults = checkRule rule, target

    if Array.isArray ruleResults[0][0]
      ruleResults = flatten ruleResults

    for result in ruleResults
      results.push result
      unless result[0]
        passed = no
        break  unless options.checkAll

    break  if not passed and not options.checkAll

  if options.log
    resultsLogger { passed, results }, options

  return { passed, results }
