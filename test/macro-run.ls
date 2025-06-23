ls = require '../'
macros = require '../lib/macros'

# compile code that defines and uses a macro, then execute the result
code = [
  "macros = require '../lib/macros'",
  "macros.define-syntax 'unless', [[['unless', '@test', '@body...'], ['if', ['not', '@test'], '@body...']]]",
  "result = 0",
  "unless false",
  "  result = 1",
  "module.exports = result"
].join '\n'

js = ls.compile code, {+bare, -header}

moduleObj = {exports: null}
Function('require', 'module', js)(require, moduleObj)

eq moduleObj.exports, 1
