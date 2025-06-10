macros = require '../../lib/macros'
path = require 'path'

macros.load-file path.resolve __dirname, '../../test/data/sample-macro.ls'

exp = macros.expand ['unless', false, ['console.log', '"loaded"']]
console.log JSON.stringify exp
