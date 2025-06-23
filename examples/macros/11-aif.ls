macros = require '../../lib/macros'

macros.define 'aif', (test, thenPart, elsePart=null) ->
  macros.with-scope ->
    it = macros.gensym 'it'
    if elsePart?
      macros.qq ['`',
        ['do',
          ['var', [',', it], [',', test]],
          ['if', [',', it], [',', thenPart], [',', elsePart]]]]
    else
      macros.qq ['`',
        ['do',
          ['var', [',', it], [',', test]],
          ['if', [',', it], [',', thenPart]]]]

js = macros.compile ['aif', true, ['console.log', 'yes!'], ['console.log', 'no!']]
console.log js
