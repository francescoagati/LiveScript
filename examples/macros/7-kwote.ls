macros = require '../../lib/macros'

macros.define-syntax 'kwote', [
  [ ['kwote', '@exp'], ['quote', '@exp'] ]
]

exp = macros.expand ['kwote', ['foo', '.', 'bar']]
console.log JSON.stringify exp
