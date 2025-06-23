macros = require '../lib/macros'
path = require 'path'

# load macros from external file
macros.load-file path.join __dirname, 'data', 'sample-macro.ls'

exp = macros.expand ['unless', true, ['console.log', 'ok']]

ok Array.isArray exp

exp[0] is 'if'
exp[1][0] is 'not'
exp[1][1] is true
