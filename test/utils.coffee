utils  = require '../src/utils.coffee'
should = require 'should'


describe 'utils.getAt', ->

  it 'should return the value of given path of object', ->
    utils.getAt { foo: { bar: { baz: 42 } } }, 'foo.bar.baz'
      .should.equal 42

  it 'should support * in path definition', ->
    utils.getAt { foo: { bar: { baz: 42, cc: 12 } } }, 'foo.*.cc'
      .should.equal 12


describe 'utils.rtrim', ->

  it 'should remove one single char at the end', ->
    utils.rtrim('gokmen.', '.').should.equal 'gokmen'

  it 'should remove multiple chars at the end', ->
    utils.rtrim('gokmen.', 'men.').should.equal 'gok'


describe 'utils.flatten', ->

  it 'should flatten one depth of arrays', ->
    utils.flatten [ [ 1 ], [ 2 ] ]
      .should.be.instanceof(Array)
      .and.deepEqual [1, 2]

  it 'should flatten one depth of arrays with multiple items', ->
    utils.flatten [ [ 1, 2, 3 ], [ 4, 5 ], [ 6 ] ]
      .should.be.instanceof(Array)
      .and.deepEqual [1, 2, 3, 4, 5, 6]


describe 'utils.getFirstKey', ->

  it 'should return the first key of given object', ->
    utils.getFirstKey { foo: 'bar', baz: 42 }
      .should.equal 'foo'

  it 'should not fail if given data is not an object', ->
    should.not.exist(utils.getFirstKey 'bar')


describe 'utils.keys', ->

  it 'should return keys of given object', ->
    utils.keys({foo: 42, bar: 'baz'}).should.deepEqual ['foo', 'bar']

  it 'should not fail if given data is not an object', ->
    should.not.exist(utils.keys 'bar')


describe 'utils.stateOf', ->

  it 'should support positive', ->
    utils.stateOf(yes).should.equal 'is'

  it 'should support negative', ->
    utils.stateOf(no).should.equal 'is not'
