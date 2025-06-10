macros = require '../../lib/macros'

macros.define 'twice', (expr) ->
  ['do', expr, expr]

macros.define 'announce', (msg) ->
  ['twice', ['console.log', msg]]

js = macros.compile ['announce', '"hello"']
console.log js
