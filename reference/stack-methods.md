# Combine levels across several linkmaps in a multifactor

Generates a new `linkmap` object by merging levels by name, separated by
the plus (`+`) sign. See examples.

## Arguments

- x:

  a `multifactor`

- .path:

  a `formula` of length 2 with with levels to be merged separated by the
  plus (`+`) sign. Optionally, a list with two character vectors,
  signifying the variables to be combined at the left and right hand
  side, respectively.

- ...:

  Additional arguments (unused.)

- out.format:

  `Character scalar`. One of `'linkmap'`, `'matrix'`.

## Value

a `linkmap` or `sparse Matrix`.

## Examples

``` r
# Only necessary in example code
require(utils)

x <- random_multifactor()
# Merge variables with "+" operator, new names get concatenated with ".":
stack(x, b ~ c + d)
#> Error in as_igraph_vs(graph, to): Invalid vertex names
```
