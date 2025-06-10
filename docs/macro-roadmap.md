# LiveScript Macro System Roadmap

This document outlines a proposed design for implementing a Lisp/Scheme-style macro system in LiveScript.

## Goals

- Provide powerful code generation capabilities similar to those found in Lisp and Scheme.
- Support hygienic macros using pattern matching and reification syntax.
- Allow recursive macro evaluation via an internal LiveScript interpreter.
- Maintain compatibility with existing LiveScript compilation pipeline.

## Key Features

1. **Macro Templates**
   - Use backtick and comma (`\`` and `,`) notation for quasiquotation.
   - Splicing support with `,@` inside templates.

2. **Pattern Matching Macros**
   - `define-syntax` style constructs for matching AST patterns.
   - Bindings for subexpressions using `@name` placeholders.
   - Hygiene ensured via generated symbols (e.g., `gensym`).

3. **Internal Interpreter**
   - Evaluate macro definitions and expansions in a sandboxed LiveScript runtime.
   - Recursive evaluation so macros can generate code containing further macro calls.

4. **Compiler Integration**
   - Hook into the existing parser to detect macro definitions.
   - Expand macros before normal code generation.

## Implementation Stages

1. **Prototype Expansion Engine**
   - Implement quasiquote and splice parsing utilities.
   - Create a basic pattern matcher for AST structures.
   - Provide a `expand` function that performs template substitution.

2. **Hygienic Identifier Generation**
   - Add a `gensym` helper to create unique identifiers.
   - Track bindings to prevent collisions during expansion.

3. **Interpreter for Macros**
   - Embed a lightweight LiveScript interpreter.
 - Evaluate macro bodies during the compilation pass.
 - Provide a helper to compile expanded macro forms directly to JavaScript.

4. **Compiler Hooks**
  - Detect `define` and `define-syntax` forms during parsing.
  - Recursively expand macros until no forms remain.
  - Initial preprocessing hook implemented via `macros.preprocess` and the
    `expandMacros` compiler option.

5. **Testing Infrastructure**
   - Unit tests for individual utilities (quasiquote, pattern matching, gensym).
   - Integration tests that compile small snippets and assert on generated JavaScript.

6. **Documentation and Examples**
   - Extend the README with usage instructions.
   - Provide example macros and patterns in the `test` directory.

## Future Work

- Initial lexical scoping for macro-generated identifiers implemented via `withScope` and scoped `gensym`.
- Support for macro libraries that can be loaded from external files. (implemented via `loadFile`)
- Macro utilities are accessible via `require('livescript').macros`.
- Performance of recursive expansion investigated; see `docs/macro-performance.md`.

Contributions toward any of these tasks are welcome. This roadmap should evolve as experimentation continues and more knowledge is gained about the best way to integrate macros into LiveScript.


## Toward a Full Macro Compiler

- Integrate the macro engine directly into the LiveScript compiler so that macro expansion happens automatically during `lsc` and `require` usage. A basic hook is available via the `--expand-macros` flag.
- Provide a standard library of useful macros (control flow, data structures, pattern utilities).
- Support cross-module expansion so macros defined in one file can rewrite another during compilation.
- Offer a command-line flag to output the fully expanded LiveScript or JavaScript for debugging. (`--show-expanded`)
- Investigate caching and performance optimizations for large projects.
