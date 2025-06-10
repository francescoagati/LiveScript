# LiveScript
is a language which compiles to JavaScript. It has a straightforward mapping to JavaScript and allows you to write expressive code devoid of repetitive boilerplate. While LiveScript adds many features to assist in functional style programming, it also has many improvements for object oriented and imperative programming.

Check out **[livescript.net](http://livescript.net)** for more information, examples, usage, and a language reference.

### Build Status
[![Build Status](https://travis-ci.org/gkz/LiveScript.svg?branch=master)](https://travis-ci.org/gkz/LiveScript)

### Install
Have Node.js installed. `sudo npm install -g livescript`

After, run `lsc -h` for more information.


### Source
[git://github.com/gkz/LiveScript.git](git://github.com/gkz/LiveScript.git)

### Using Macros
LiveScript ships with a small Lisp-style macro system located in
`lib/macros.js`. The macros module is also exported as
`require('livescript').macros`. A more extensive guide is available in `docs/macro-guide.md`. Load the module and define macros using either
`define` or `defineSyntax`:

```livescript
macros = require '../lib/macros'
macros.define-syntax 'unless', [
  [ ['unless', '@test', '@body...'], ['if', ['not', '@test'], '@body...'] ]
]

exp = macros.expand ['unless', true, ['console.log', 'ok']]
```

Another macro can be defined using template syntax with backtick and comma
markers:

```livescript
macros.define 'when', (test, ...body) ->
  macros.qq ['`', ['if', [',', test], [',@', body]]]
```

The call to `expand` returns the transformed abstract syntax tree. See
`test/macro.ls` for more examples.

When a macro expansion introduces temporary bindings, wrap the expansion in
`withScope` so each expansion gets its own lexical scope:

```livescript
macros.define 'wrap', (body) ->
  macros.with-scope ->
    t = macros.gensym 'tmp'
    macros.qq ['`', ['do', ['var', [',', t], 0], [',', body], [',', t]]]
```

Macros can also be loaded from external files using `loadFile`:

```livescript
macros.load-file 'path/to/macros.ls'
```

Macro expressions can also be compiled directly to JavaScript. The `compile`
utility expands the form and emits a JS string:

```livescript
macros.define 'when', (t, ...body) ->
  macros.qq ['`', ['if', [',', t], [',@', body]]]

js = macros.compile ['when', true, ['console.log', 42]]
```

The main compiler can process these forms automatically when passed
`expandMacros: true`:

```livescript
code = "macros.compile ['when', true, ['console.log', 1]]"
js = require('../').compile code, {bare: true, expandMacros: true}
```

### Community

If you'd like to chat, drop by [#livescript](irc://irc.freenode.net/livescript) on Freenode IRC.
If you don't have IRC client you can use Freenode [webchat](https://webchat.freenode.net/?channels=#livescript).
