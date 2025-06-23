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

macros.define 'wrap', (body) ->
  macros.with-scope ->
    t = macros.gensym 'tmp'
    macros.qq ['`', ['do', ['var', [',', t], 0], [',', body], [',', t]]]

js = macros.compile ['wrap', ['swap', 'x', 'y']]
console.log js
