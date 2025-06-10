macros = require '../../lib/macros'

macros.define 'swap', (a, b) ->
  macros.with-scope ->
    t = macros.gensym 't'
    macros.qq ['`',
      ['do',
        ['var', [',', t], [',', a]],
        ['set', [',', a], [',', b]],
        ['set', [',', b], [',', t]]
      ]
    ]

js = macros.compile ['swap', 'x', 'y']
console.log js
