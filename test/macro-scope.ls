macros = require '../lib/macros'

macros.define 'swap', (a, b) ->
  t = macros.gensym 't'
  macros.qq ['`',
    ['do',
      ['var', [',', t], [',', a]],
      ['set', [',', a], [',', b]],
      ['set', [',', b], [',', t]]
    ]
  ]

macros.define 'wrap', (body) ->
  macros.with-scope ->
    t = macros.gensym 'tmp'
    macros.qq ['`', ['do', ['var', [',', t], 0], [',', body], [',', t]]]

exp1 = macros.expand ['wrap', ['swap', 'a', 'b']]
exp2 = macros.expand ['wrap', ['swap', 'x', 'y']]

ok exp1[1][1] isnt exp2[1][1]
