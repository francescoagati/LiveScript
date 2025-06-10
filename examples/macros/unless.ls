macros = require '../../lib/macros'

macros.define-syntax 'unless', [
  [ ['unless', '@cond', '@body...'], ['if', ['not', '@cond'], '@body...'] ]
]

unless false
  console.log 'ran!'
