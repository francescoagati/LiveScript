macros = require '../lib/macros'

macros.define-syntax 'unless', [
  [ ['unless', '@test', '@body...'], ['if', ['not', '@test'], '@body...'] ]
]

exp = macros.expand ['unless', true, ['console.log', 'ok']]

# check expansion of unless macro
ok Array.isArray exp

eq exp[0], 'if'
eq exp[1][0], 'not'
eq exp[1][1], true

macros.define 'when', (test, ...body) ->
  macros.qq ['`', ['if', [',', test], [',@', body]]]

exp2 = macros.expand ['when', false, ['console.log', 'hi']]

# check expansion of when macro
ok Array.isArray exp2

eq exp2[0], 'if'
eq exp2[1], false

macros.defineLS 'when2', '(test, ...body) -> macros.qq [\'`\', [\'if\', [\',\', test], [\',@\', body]]]'
exp3 = macros.expand ['when2', true, ['console.log', 'ls']]
ok Array.isArray exp3
eq exp3[0], 'if'
eq exp3[1], true

# gensym should produce unique symbols
g1 = macros.gensym 'tmp'
g2 = macros.gensym 'tmp'
ok g1 isnt g2

macros.define 'swap', (a, b) ->
  t = macros.gensym 't'
  macros.qq ['`',
    ['do',
      ['var', [',', t], [',', a]],
      ['set', [',', a], [',', b]],
      ['set', [',', b], [',', t]]
    ]
  ]

exp4 = macros.expand ['swap', 'x', 'y']
exp5 = macros.expand ['swap', 'a', 'b']
ok exp4[1][1] isnt exp5[1][1]
eq exp4[2][1], 'x'
eq exp4[2][2], 'y'
eq exp5[2][1], 'a'
eq exp5[2][2], 'b'

macros.define 'twice', (expr) ->
  ['do', expr, expr]

exp6 = macros.expand ['twice', ['when', false, ['console.log', 'x']]]

deep-equal exp6, [
  'do',
  ['if', false, ['console.log', 'x']],
  ['if', false, ['console.log', 'x']]
]

# quasiquote supports nested unquote and splicing
qq-res = macros.qq ['`', ['list', [',', 1], [',@', [2, 3]], [',', ['+', 1, 2]]]]
deep-equal qq-res, ['list', 1, 2, 3, ['+', 1, 2]]

# unmatched pattern should throw an error
macros.define-syntax 'simple', [
  [ ['simple', '@x'], '@x' ]
]
throws 'no matching pattern for macro simple', ->
  macros.expand ['simple', 'a', 'b']
