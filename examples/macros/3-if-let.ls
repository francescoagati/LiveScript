macros = require '../../lib/macros'

macros.define-syntax 'if-let', [
  [ ['if-let', '@name', '@val', '@body...'],
    ['do', ['var', '@name', '@val'], ['if', '@name', '@body...']] ]
]

js = macros.compile ['if-let', 'x', true, ['console.log', '"set"']]
console.log js
