macros = require '../lib/macros'

macros.define 'when', (test, ...body) ->
  macros.qq ['`', ['if', [',', test], [',@', body]]]

js = macros.compile ['when', true, ['console.log', 42]]

box = {}
Function('console', 'box', js)(
  {log: (x) -> box.val = x},
  box
)

eq box.val, 42
