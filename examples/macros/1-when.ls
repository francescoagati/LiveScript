macros = require '../../lib/macros'

macros.define 'whn', (test, ...body) ->
  macros.qq ['`', ['if', [',', test], [',@', body]]]

js = macros.compile ['whn', true, ['console.log', 'example 1']]
console.log js
