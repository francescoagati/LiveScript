macros = require '../../lib/macros'
macros.define-syntax 'unless', [[['unless', '@t', '@b...'], ['if', ['not', '@t'], '@b...']]]
