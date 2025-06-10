# LiveScript Macro Guide

This guide explains the experimental Lisp/Scheme-style macro system included in this repository. The macros module resides in `lib/macros.js` and is also exported via `require('livescript').macros`. Macros operate on simple data structures rather than raw strings. Forms are represented as nested arrays and strings similar to s-expressions.

The guide walks through the major features and provides numerous examples.

## Loading the Macro Utilities

```livescript
macros = require 'livescript'.macros
```

You can also load macros from an external file:

```livescript
macros.load-file 'macros/my-macros.ls'
```

## Defining Macros

There are two ways to define macros:

### Functional Macros

`define name, (args...) -> expr` registers a macro that receives the raw expression arguments and returns a new expression. The returned form will itself be recursively expanded.

```livescript
macros.define 'unless', (test, ...body) ->
  ['if', ['not', test], ['do', ...body]]

macros.expand ['unless', false, ['console.log', 'works']]
# => ['if', ['not', false], ['do', ['console.log', 'works']]]
```

### Pattern Macros

`defineSyntax name, [ [pattern, template], ... ]` matches the call expression against a set of patterns. When a pattern matches, the corresponding template is substituted.

Patterns and templates may contain placeholders using `@name` or `@name...` for rest arguments.

```livescript
macros.define-syntax 'when', [
  [ ['when', '@test', '@body...'], ['if', '@test', ['do', '@body...']] ]
]
```

Invoking `macros.expand` replaces the macro call:

```livescript
exp = macros.expand ['when', ['>', 1, 0], ['console.log', 'ok']]
# => ['if', ['>', 1, 0], ['do', ['console.log', 'ok']]]
```

### Hygiene with `gensym`

The system includes a `gensym` helper for generating unique identifiers. This prevents accidental collisions between temporary bindings introduced by a macro and names at the call site.

```livescript
macros.define-syntax 'swap', [
  [ ['swap', '@a', '@b'],
    ['do',
      ['var', g = macros.gensym 'tmp'],
      ['set', g, '@a'],
      ['set', '@a', '@b'],
      ['set', '@b', g] ] ]
]
```

## Quasiquote Templates

Complex macros can be easier to read using quasiquote notation. Backtick `` ` `` starts a quoted template, `,` inserts an expression and `,@` splices a list of expressions.

```livescript
macros.define 'my-or', (a, b) ->
  macros.qq ['`', ['let', [',', a], ['if', ',', a, ',', b]]]
```

The `qq` helper converts the template into an AST structure with proper splicing.

## Compiling Macro Forms

`macros.compile` expands an expression and converts it directly to JavaScript:

```livescript
js = macros.compile ['when', true, ['console.log', 42]]
console.log js
# => "if (true) {console.log(42)}"
```

The main compiler can automatically preprocess files when passed `{expandMacros: true}`.

## Recursive Expansion

Macros may expand into code that contains further macro calls. The expansion engine will continue until no macro forms remain:

```livescript
macros.define 'twice', (x) -> ['do', x, x]

macros.define 'announce', (msg) -> ['twice', ['console.log', msg]]

macros.expand ['announce', 'hi']
# => ['do', ['console.log', 'hi'], ['console.log', 'hi']]
```

## Testing Your Macros

The repository includes numerous test files under `test/`. Each file contains macros and a script demonstrating expansion. You can run the suite with:

```sh
npm test
```

### Example: Macro from String

`evalLS` evaluates a string of LiveScript and returns the resulting function. `defineLS` combines this with `define`.

```livescript
src = "(x) -> ['console.log', x]"
macros.defineLS 'log', src
macros.expand ['log', 'works']
```

---

This macro system is experimental but already powerful enough to express many compile-time abstractions. Explore the tests and documentation for further ideas.
