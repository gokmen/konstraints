konstraints = require '../src/konstraints.coffee'
should      = require 'should'

options = log: yes, logDefaults: yes, checkAll: yes

describe "Initial requirements", ->

  it "konstraints loaded", ->
    konstraints.should.exists

  it "should pass if given rules fits with the number", ->

    target = 42
    rules  = [
      { $typeof: 'number' }
      { $lte: 42 }
      { $gte: 42 }
      { $eq: 42 }
      { $lt: 43 }
      { $gt: 41 }
    ]

    result = konstraints target, rules, options
    result.passed.should.be.true()

  it "should pass if given rules fits for strings", ->

    target = 'foo'
    rules  = [
      { $typeof: 'string' }
      { $length: 3 }
      { $in: ['foo', 'bar'] }
    ]

    result = konstraints target, rules, options
    result.passed.should.be.true()

  it "should pass if given rules fits for arrays", ->

    target = ['foo', 'bar', 'baz', 42]
    rules  = [
      { $typeof: 'array' }
      { $length: 4 }
      { 1: { $in: [ 'bar', 'boo' ] } }
      { 3: { $lte: 42 } }
    ]

    result = konstraints target, rules, options
    result.passed.should.be.true()

  it "should pass if given object is valid", ->

    target  =
      foo   :
        bar : 42
      baz   :
        one : 1
        two : 2
        pi  : 3.14

    rules   = [
      { $typeof: 'object' }
      { $keys: [ 'foo', 'baz' ] }
      { 'foo': { $keys: [ 'bar' ] } }
      {
        'foo.bar': [
          { $eq: 42 }
          { $lt: 44 }
        ]
      }
      { 'baz': { $length: 3 } }
      { 'baz.*': { $gt: 0 } }
      { 'baz.pi': { $eq: 3.14 } }
    ]

    result = konstraints target, rules, options
    result.passed.should.be.true()


describe 'Check optional rules', ->

  target     =
    foo      :
      bar    : 42
    baz      :
      one    : 1
      two    : 2
      pi     : 3.14

  rules   = [
    { 'baz': { $length: { $lte: 4 } } }
    { 'baz.fourth?': { $gt: 0 } }
    { 'baz.pi': { $eq: 3.14 } }
  ]


  it "should pass if an optional rule data is not provided", ->

    result = konstraints target, rules, options
    result.passed.should.be.true()


  it "should pass if an optional rule data is provided", ->

    target.baz.fourth = 1

    result = konstraints target, rules, options
    result.passed.should.be.true()

