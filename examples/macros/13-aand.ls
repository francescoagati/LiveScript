macros = require '../../lib/macros'

macros.define 'aif', (test, thenPart, elsePart=null) ->
  macros.with-scope ->
    it = macros.gensym 'it'
    if elsePart?
      macros.qq ['`', ['do', ['var', [',', it], [',', test]], ['if', [',', it], [',', thenPart], [',', elsePart]]]]
    else
      macros.qq ['`', ['do', ['var', [',', it], [',', test]], ['if', [',', it], [',', thenPart]]]]

macros.define-syntax 'aand', [
  [ ['aand'], true ],
  [ ['aand', '@x'], '@x' ],
  [ ['aand', '@x', '@rest...'], ['aif', '@x', ['aand', '@rest...'], '@x'] ]
]

js = macros.compile ['aand', true, true, false]
console.log js
