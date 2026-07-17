# Combine levels across several LinkMaps in a MultiFactor

Generates a new `LinkMap` object by merging levels by name, separated by
the plus (`+`) sign. See examples.

## Arguments

- x:

  a `MultiFactor`

- .path:

  a `formula` of length 2 with with levels to be merged separated by the
  plus (`+`) sign. Optionally, a list with two character vectors,
  signifying the variables to be combined at the left and right hand
  side, respectively.

- ...:

  Additional arguments (unused.)

- out.format:

  `Character scalar`. One of `'LinkMap'`, `'matrix'`.

## Value

a `LinkMap` or `sparse Matrix`.

## Examples

``` r
# Only necessary in example code
require(utils)

x <- randomMultiFactor()
# Merge variables with "+" operator, new names get concatenated with ".":
stack(x, b ~ c + d)
#> A MultiFactor::LinkMap data.frame S7_object: 81 rows.
#>        b   c.d
#> 1  b_003 c_001
#> 2  b_009 c_001
#> 3  b_003 c_002
#> 4  b_004 c_002
#> 5  b_006 c_002
#> 6  b_010 c_002
#> 7  b_007 c_004
#> 8  b_001 c_005
#> 9  b_003 c_005
#> 10 b_005 c_005
#>  + 71 more rows. Use `print(n = ...)` to see more rows.
#> 
#> @ levels:   2 variables: 
#>  $ b   : 10 Levels: b_001 b_002 ... b_010 
#>  $ c.d : 19 Levels: c_001 c_002 ... d_010 
```
