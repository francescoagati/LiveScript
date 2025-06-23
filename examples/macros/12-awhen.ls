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

macros.define 'awhen', (test, ...body) ->
  macros.qq ['`', ['aif', [',', test], ['do', [',@', body]]]]

js = macros.compile ['awhen', true, ['console.log', 'done!']]
console.log js
