# Macro Expansion Performance

A simple benchmark is included at `scripts/bench-macro` to measure the cost of recursive macro expansion. It defines a `repeat` macro which expands to nested `do` forms.

Run the benchmark with a desired depth:

```bash
node scripts/bench-macro 1000
```

On the test environment this expands a depth of 1000 in around 5ms. The expansion result contains about 16k characters. These results suggest that recursive expansion is reasonably fast for typical macro usage, though extremely deep expansions may still allocate large arrays.
