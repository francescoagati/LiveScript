ls = require '..'
macros = require '../lib/macros'

macros.define 'when', (test, ...body) ->
  macros.qq ['`', ['if', [',', test], [',@', body]]]

code = [
  'res = 0',
  "macros.compile ['when', true, ['set', 'res', 1]]",
  "macros.compile ['when', true, ['set', 'res', 2]]",
  'module.exports = res'
].join '\n'

js = ls.compile code, {bare: true, expandMacros: true}

# the macros.compile calls should be removed from the output
ok js.indexOf('macros.compile') is -1

moduleObj = {exports: null}
Function('module', js)(moduleObj)

# res should reflect both expansions
eq moduleObj.exports, 2
