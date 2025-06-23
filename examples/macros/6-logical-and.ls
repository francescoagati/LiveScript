macros = require '../../lib/macros'

macros.define-syntax 'logical-and', [
  [ ['logical-and'], true ],
  [ ['logical-and', '@exp'], '@exp' ],
  [ ['logical-and', '@exp', 'and', '@rest...'],
    ['if', '@exp', ['logical-and', '@rest...'], false] ]
]

js = macros.compile ['logical-and', true, 'and', false]
console.log js
