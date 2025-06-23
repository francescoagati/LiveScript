macros = require '../../lib/macros'

macros.define 'make-pair', (a, b) ->
  macros.with-scope ->
    t = macros.gensym 'p'
    macros.qq ['`',
      ['do',
        ['var', [',', t], [',', a]],
        ['var', [',', t + "2"], [',', b]],
        [',', t], [',', t + "2"]
      ]
    ]

exp1 = macros.expand ['make-pair', 'x', 'y']
exp2 = macros.expand ['make-pair', 'x', 'y']
console.log exp1[1][1] isnt exp2[1][1]
