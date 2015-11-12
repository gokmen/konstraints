
# colors for shell outputs
colors    =
  reset   : "\x1b[0m"
  black   : "\x1b[30m"
  red     : "\x1b[31m"
  green   : "\x1b[32m"
  yellow  : "\x1b[33m"
  blue    : "\x1b[34m"
  magenta : "\x1b[35m"
  cyan    : "\x1b[36m"

log = (rest..., color) ->
  return console.log arguments[0]  if arguments.length <= 1

  if window?
    rest[0] = "%c#{rest[0]}"
    console.log rest..., "color: #{color}"
  else
    if c = colors[color]
      rest[0] = "#{c}#{rest[0]}"
      rest.push colors.reset
    console.log rest...

keys = (o) -> Object.keys o

rtrim = (s, c) ->
  return ''  unless s or c
  if s[-(c.length)..] is c then s[...-(c.length)] else s

stateOf = (state) ->
  if state then 'is' else 'is not'

flatten = (arr) ->
  arr.reduce ((a, b) -> a.concat b), []

getFirstKey = (obj) ->
  (Object.keys obj)[0]

getAt = (ref, path) ->
  path = path.split? '.' or path.slice()
  while ref? and prop = path.shift()
    if prop is '*'
    then ref = ref[key]  for key of ref
    else ref = ref[prop]

  ref

resultsLogger = ({ passed, results }, options = {}) ->

  log ''

  for result in results
    [ res, message, { rule, data } ] = result
    if res
      log "    ✓ #{message}", 'green'
    else
      log "    ✗ #{message}", 'red'
      if options.logDefaults
        log "    ℹ value can be '#{rule.val}' got '#{data}' instead", 'blue'

  log ''

  if passed
  then log "    ✓ ALL PASSED!" , 'cyan'
  else log "    ✗ SOME FAILED!", 'red'

  log ''


module.exports = {
  rtrim, stateOf
  flatten, getFirstKey
  keys, getAt
  log, resultsLogger
}