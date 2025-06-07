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
  macros.qq ['if', ['unquote', test], ['splice', body]]

exp2 = macros.expand ['when', false, ['console.log', 'hi']]

# check expansion of when macro
ok Array.isArray exp2

eq exp2[0], 'if'
eq exp2[1], false

macros.defineLS 'when2', '(test, ...body) -> macros.qq [\'if\', [\'unquote\', test], [\'splice\', body]]'
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
  macros.qq ['do',
    ['var', ['unquote', t], ['unquote', a]],
    ['set', ['unquote', a], ['unquote', b]],
    ['set', ['unquote', b], ['unquote', t]]
  ]

exp4 = macros.expand ['swap', 'x', 'y']
exp5 = macros.expand ['swap', 'a', 'b']
ok exp4[1][1] isnt exp5[1][1]
eq exp4[2][1], 'x'
eq exp4[2][2], 'y'
eq exp5[2][1], 'a'
eq exp5[2][2], 'b'
