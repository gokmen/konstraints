// Generated by CoffeeScript 1.10.0
(function() {
  var checkRule, getAt, getFirstKey, keys, ref, rtrim, settle;

  ref = require('./utils'), rtrim = ref.rtrim, getAt = ref.getAt, keys = ref.keys, getFirstKey = ref.getFirstKey;

  settle = require('./settle');

  module.exports = checkRule = function(rule, target, custom) {
    var $rule, _res, _rkey, _target, base, cpath, data, func, i, key, len, message, path, r, ref1, ref2, ref3, ref4, ref5, ref6, res, rest, rkey, val;
    path = (ref1 = custom != null ? custom.path : void 0) != null ? ref1 : getFirstKey(rule);
    func = (ref2 = custom != null ? custom.func : void 0) != null ? ref2 : (ref3 = /(\$\w+)/g.exec(path)) != null ? ref3[0] : void 0;
    val = custom != null ? custom.val : void 0;
    if (!func) {
      $rule = rule[path];
      if (Array.isArray($rule)) {
        res = [];
        for (i = 0, len = $rule.length; i < len; i++) {
          r = $rule[i];
          rkey = getFirstKey(r);
          if (rkey[0] === '$') {
            res.push(checkRule(r, target, {
              path: path + "." + rkey,
              val: r[rkey]
            }));
          } else {
            _rkey = getFirstKey(r[rkey]);
            res.push(checkRule(r, target, {
              path: path + "." + rkey + "." + _rkey,
              val: r[rkey][_rkey]
            }));
          }
        }
        return res;
      } else if (typeof $rule === 'object') {
        func = getFirstKey($rule);
        val = $rule[func];
      }
    } else {
      val = (ref4 = custom != null ? custom.val : void 0) != null ? ref4 : rule[path];
      path = rtrim(path.replace(func, ''), '.');
    }
    rule = {
      path: path,
      val: val,
      func: func
    };
    if (rule.path) {
      if ((rule.path.indexOf('*')) > -1) {
        ref5 = (rule.path.split('*')).map(function(x) {
          return rtrim(x, '.');
        }), base = ref5[0], rest = ref5[1];
        data = getAt(target, base);
        res = [];
        for (key in data) {
          cpath = base + "." + key + rest;
          res.push(checkRule(rule, target, {
            path: cpath,
            val: rule.val,
            func: rule.func
          }));
        }
        if (res.length > 0) {
          return res;
        }
      }
      data = getAt(target, rule.path);
      if (data == null) {
        res = [
          [
            false, "no data found at " + rule.path, {
              rule: rule,
              data: data,
              target: target
            }
          ]
        ];
        if (custom != null) {
          return res[0];
        } else {
          return res;
        }
      }
      _target = rule.path;
    } else {
      data = target;
      _target = 'given object';
    }
    ref6 = settle(rule, data, _target), res = ref6[0], message = ref6[1], data = ref6[2];
    _res = [
      [
        res, message, {
          rule: rule,
          data: data,
          target: target
        }
      ]
    ];
    if (custom != null) {
      _res = _res[0];
    }
    return _res;
  };

}).call(this);
