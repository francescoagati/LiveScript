ls = require '../'
macros = require '../lib/macros'

# compile LiveScript code that defines and uses a macro
code = [
  "macros = require('..').macros",
  "macros.define-syntax 'unless', [[['unless', '@test', '@body...'], ['if', ['not', '@test'], '@body...']]]",
  "expanded = macros.expand ['unless', false, ['console.log', 'hi']]"
].join '\n'

js = ls.compile code, {+bare, -header}

result = Function('require', js + '; return expanded;')(require)

deep-equal result, ['if', ['not', false], ['console.log', 'hi']]
