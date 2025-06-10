macros = require '../lib/macros'

macros.define 'aif', (test, thenPart, elsePart=null) ->
  macros.with-scope ->
    it = macros.gensym 'it'
    if elsePart?
      macros.qq ['`',
        ['do', ['var', [',', it], [',', test]], ['if', [',', it], [',', thenPart], [',', elsePart]]]]
    else
      macros.qq ['`',
        ['do', ['var', [',', it], [',', test]], ['if', [',', it], [',', thenPart]]]]

macros.define 'awhen', (test, ...body) ->
  macros.qq ['`', ['aif', [',', test], ['do', [',@', body]]]]

macros.define-syntax 'aand', [
  [ ['aand'], true ],
  [ ['aand', '@x'], '@x' ],
  [ ['aand', '@x', '@rest...'], ['aif', '@x', ['aand', '@rest...'], '@x'] ]
]

exp1 = macros.expand ['aif', true, 'x', 'y']
# structure checks
eq exp1[0], 'do'
ok exp1[1][0] is 'var'
ok exp1[2][0] is 'if'

exp2 = macros.expand ['awhen', true, ['console.log', 'hi']]
eq exp2[0], 'do'
ok exp2[2][0] is 'if'

exp3 = macros.expand ['aand', true, true, false]
eq exp3[0], 'do'

