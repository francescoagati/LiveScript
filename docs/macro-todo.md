# Macro System TODO

This file tracks the implementation progress for the planned Lisp-style macro system.

- [x] Prototype expansion engine (quasiquote, pattern matching, `expand`)
- [x] Hygienic identifier generation with `gensym`
- [x] Internal interpreter for recursive macro evaluation
 - [x] Compiler hooks for detecting and expanding macros
- [x] Comprehensive test suite for macros
- [x] Additional documentation and usage examples
- [x] Support macro libraries that can be loaded from external files via `loadFile`
- [x] Automatic macro expansion during compilation via `macros.compile`
- [x] Integrate macro definitions into standard library
- [x] Add error messages for failed pattern matches
- [x] Macro utilities are accessible via `require('livescript').macros`
- [x] Explore advanced hygiene mechanisms such as lexical scoping for macro-generated identifiers
- [x] Investigate performance implications of recursive expansion

- [x] Provide ten complex macro examples under `examples/macros`
- [x] Port macro examples from Paul Graham's *On Lisp*

- [x] Integrate macro expansion with the `lsc` command and Node API
- [ ] Provide a standard library of macros distributed with LiveScript
- [ ] Enable cross-module expansion so macros can transform code in other files
- [x] Add `--show-expanded` flag to output expanded code for debugging
- [ ] Cache macro expansions for faster recompiles
- [ ] Document advanced macro debugging techniques
- [ ] Automatic macro expansion during compilation
- [ ] Integrate macro definitions into standard library
- [ ] Add error messages for failed pattern matches
