// This example is created to test Konstraints on tonicdev.com
konstraints = require('konstraints');

var target, rules;

target = {
  foo: {
    bar: 42
  },
  baz: {
    one: 1,
    two: 2
  }
};

rules = [
  { $typeof: 'object' },
  { $keys: [ 'foo', 'baz' ] },
  { 'foo': { $keys: [ 'bar' ] } },
  {
    'foo.bar': [
      { $eq: 42 },
      { $lt: 44 }
    ]
  },
  { 'baz': { $length: 2 } },
  { 'baz.*': { $gt: 0 } }
];

konstraints(target, rules).results;
