macros = require '../lib/macros'

macros.define 'when', (test, ...body) ->
  macros.qq ['`', ['if', [',', test], [',@', body]]]

code = "macros.compile ['when', true, ['console.log', 99]]"
js = require('..').compile code, {bare: true, expandMacros: true}

box = {}
Function('console', 'box', js)( {log: (x) -> box.val = x}, box )

eq box.val, 99
