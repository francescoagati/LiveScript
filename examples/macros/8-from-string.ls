macros = require '../../lib/macros'

src = '(x) -> [\'console.log\', x]'
macros.defineLS 'logit', src

exp = macros.expand ['logit', '"hi"']
console.log JSON.stringify exp
