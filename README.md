Konstraints 
-----------

[![Build Status](https://travis-ci.org/gokmen/konstraints.svg?branch=master)](https://travis-ci.org/gokmen/konstraints)
[![NPM version](https://img.shields.io/npm/v/konstraints.svg?style=flat-square)](https://www.npmjs.com/package/konstraints)

Constraint checker for given target by provided rules. With `konstraints` you can make sure that your objects are fits with in your requirements.

After doing `npm i konstraints`;

```coffee

konstraints = require 'konstraints'

target  =
  foo   :
    bar : 42
  baz   :
    one : 1
    two : 2

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
  { 'baz': { $length: 2 } }
  { 'baz.*': { $gt: 0 } }
]

res = konstraints target, rules, log: yes

```

will generate following output:

```

   ✓ type of given object is 'object'
   ✓ all keys of given object are allowed
   ✓ all keys of foo are allowed
   ✓ foo.bar is equal to 42
   ✓ foo.bar is less than 44
   ✓ length of baz is 2
   ✓ baz.one is greater than 0
   ✓ baz.two is greater than 0

   ✓ ALL PASSED!

```

You can also try it in your browser from https://tonicdev.com/npm/konstraints

Test
----

Run `npm test` to run tests, you can also check `test/konstraint.coffee` for more example.

