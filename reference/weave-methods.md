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
#> 1  b_004 c_001
#> 2  b_006 c_001
#> 3  b_001 c_002
#> 4  b_008 c_002
#> 5  b_005 c_003
#> 6  b_010 c_003
#> 7  b_003 c_004
#> 8  b_004 c_004
#> 9  b_005 c_004
#> 10 b_007 c_004
#> 11 b_005 c_005
#> 12 b_002 c_006
#> 13 b_003 c_006
#> 14 b_004 c_006
#> 15 b_008 c_006
#> 16 b_009 c_006
#> 17 b_003 c_007
#> 18 b_010 c_007
#> 19 b_001 c_008
#> 20 b_005 c_009
#> 21 b_006 c_009
#> 22 b_007 c_009
#> 23 b_004 c_010
#> 24 b_007 c_010
#> 25 b_010 c_010
weave(x, b ~ a, out.format = "matrix")
#> 10 x 10 sparse Matrix of class "ngCMatrix"
#>   [[ suppressing 10 column names ‘a_001’, ‘a_002’, ‘a_003’ ... ]]
#>        a
#> b                          
#>   b_001 . | . | . . . . . |
#>   b_002 | . . . | | | . . |
#>   b_003 . . . . . . . | . .
#>   b_004 | . | . . . | | | .
#>   b_005 | . . . . . . . . .
#>   b_006 . | | . . . . . | .
#>   b_007 . . . . . | . | . .
#>   b_008 | . . . . . . . . .
#>   b_009 | . . . | . . | . |
#>   b_010 . . . . . . . . . .

# Merge variables with "+" operator, new names get concatenated with ".":
weave(x, b ~ c + d)
#>        b   c.d
#> 1  b_004 c_001
#> 2  b_006 c_001
#> 3  b_001 c_002
#> 4  b_008 c_002
#> 5  b_005 c_003
#> 6  b_010 c_003
#> 7  b_003 c_004
#> 8  b_004 c_004
#> 9  b_005 c_004
#> 10 b_007 c_004
#> 11 b_005 c_005
#> 12 b_002 c_006
#> 13 b_003 c_006
#> 14 b_004 c_006
#> 15 b_008 c_006
#> 16 b_009 c_006
#> 17 b_003 c_007
#> 18 b_010 c_007
#> 19 b_001 c_008
#> 20 b_005 c_009
#> 21 b_006 c_009
#> 22 b_007 c_009
#> 23 b_004 c_010
#> 24 b_007 c_010
#> 25 b_010 c_010
#> 26 b_001 d_001
#> 27 b_005 d_001
#> 28 b_010 d_001
#> 29 b_002 d_002
#> 30 b_003 d_002
#> 31 b_004 d_002
#> 32 b_005 d_002
#> 33 b_006 d_002
#> 34 b_007 d_002
#> 35 b_008 d_002
#> 36 b_009 d_002
#> 37 b_003 d_003
#> 38 b_004 d_003
#> 39 b_005 d_003
#> 40 b_006 d_003
#> 41 b_007 d_003
#> 42 b_003 d_004
#> 43 b_004 d_004
#> 44 b_005 d_004
#> 45 b_007 d_004
#> 46 b_010 d_004
#> 47 b_003 d_005
#> 48 b_004 d_005
#> 49 b_006 d_005
#> 50 b_010 d_005
#> 51 b_005 d_006
#> 52 b_001 d_007
#> 53 b_003 d_007
#> 54 b_004 d_007
#> 55 b_005 d_007
#> 56 b_007 d_007
#> 57 b_008 d_007
#> 58 b_010 d_007
#> 59 b_003 d_008
#> 60 b_010 d_008
#> 61 b_002 d_009
#> 62 b_003 d_009
#> 63 b_004 d_009
#> 64 b_005 d_009
#> 65 b_006 d_009
#> 66 b_007 d_009
#> 67 b_008 d_009
#> 68 b_009 d_009
#> 69 b_010 d_009
#> 70 b_001 d_010
#> 71 b_003 d_010
#> 72 b_005 d_010
#> 73 b_008 d_010
#> 74 b_010 d_010

# Control intermediate variable types "~", returning a MultiFactor:
weave(x, a ~ c ~ e )
#> A MultiFactor::MultiFactor list S7_object,
#>     3 feature types across 2 LinkMaps.
#> 
#>      a  c  e
#> a2c 10 10  .
#> c2e  . 10 10
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> a : 10 Levels: a_001 a_002 ... a_010 
#> c : 10 Levels: c_001 c_002 ... c_010 
#> e : 10 Levels: e_001 e_002 ... e_010 

# Combine merging and intermediate stops:
weave(x, a ~ b + c ~ d + e ~ f )
#> A MultiFactor::MultiFactor list S7_object,
#>     4 feature types across 3 LinkMaps.
#> 
#>          a b.c d.e  f
#> a2b.c   10  19   .  .
#> b.c2d.e  .  20  20  .
#> d.e2f    .   .  19 10
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> a   : 10 Levels: a_001 a_002 ... a_010 
#> b.c : 20 Levels: b_001 b_002 ... c_010 
#> d.e : 20 Levels: d_001 d_002 ... e_010 
#> f   : 10 Levels: f_001 f_002 ... f_010 
```
