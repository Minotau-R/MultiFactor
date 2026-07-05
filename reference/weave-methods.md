# Weave a new LinkMap from a MultiFactor

Generates a new `LinkMap` object by cross-referencing the elements of a
given `MultiFactor`. Elements can be merged by including several names,
separated by the plus (`+`) sign. See examples.

## Arguments

- x:

  a `MultiFactor`

- .path:

  Either a `formula` or a `character vector` of length 2 with the names
  of the desired combination of feature types.

- out.format:

  `Character scalar`. One of `'LinkMap'`, `'matrix'`.

- include, exclude, exact:

  `Character vectors` Should feature types be included or excluded from
  the available paths? Exact allows for exact path definition.

## Value

a `LinkMap` or `sparse Matrix`.

## Examples

``` r
# Generate a random MultiFactor
x <- randomMultiFactor()

# Weave new b2c LinkMap
weave(x, b ~ c)
#>        b     c
#> 1  b_001 c_001
#> 2  b_006 c_001
#> 3  b_007 c_001
#> 4  b_005 c_002
#> 5  b_001 c_004
#> 6  b_002 c_004
#> 7  b_003 c_004
#> 8  b_007 c_004
#> 9  b_008 c_004
#> 10 b_009 c_004
#> 11 b_010 c_004
#> 12 b_002 c_005
#> 13 b_005 c_005
#> 14 b_008 c_005
#> 15 b_003 c_006
#> 16 b_010 c_006
#> 17 b_002 c_007
#> 18 b_008 c_007
#> 19 b_009 c_007
#> 20 b_005 c_008
#> 21 b_007 c_008
#> 22 b_009 c_008
#> 23 b_010 c_008
#> 24 b_007 c_009
#> 25 b_001 c_010
weave(x, b ~ a, out.format = "matrix")
#> 10 x 10 sparse Matrix of class "ngCMatrix"
#>   [[ suppressing 10 column names ‘a_001’, ‘a_002’, ‘a_003’ ... ]]
#>        a
#> b                          
#>   b_001 | . . . . . . . . |
#>   b_002 | . . | . . . . | .
#>   b_003 . . . . . . . . | .
#>   b_004 . . | . . . | | | .
#>   b_005 . . | | . . . . . .
#>   b_006 | . . | . | . . . .
#>   b_007 . . | . . . . . . .
#>   b_008 | | . . . . | . . .
#>   b_009 | . . . | . . . | .
#>   b_010 . . | | . . . | . .
```
