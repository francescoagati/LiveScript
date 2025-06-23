macros = require '../lib/macros'

# define a macro using evalLS from a string
macros.evalLS "macros.define 'inc', (x) -> macros.qq ['`', ['+', [',', x], 1]]"

exp = macros.expand ['inc', 2]

# check expansion result
ok Array.isArray exp

eq exp[0], '+'
eq exp[1], 2
eq exp[2], 1

