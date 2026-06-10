# Weave a new LinkMap from a MultiFactor

Generates a new `LinkMap` object by cross-referencing the elements of a
given `MultiFactor`. Elements can be merged by including several names,
separated by the plus (`+`) sign. See examples.

## Arguments

- x:

  a `MultiFactor`

- .by:

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
#> 2  b_008 c_001
#> 3  b_010 c_001
#> 4  b_005 c_002
#> 5  b_003 c_003
#> 6  b_008 c_003
#> 7  b_001 c_004
#> 8  b_004 c_004
#> 9  b_005 c_004
#> 10 b_009 c_004
#> 11 b_001 c_005
#> 12 b_003 c_005
#> 13 b_001 c_006
#> 14 b_004 c_006
#> 15 b_007 c_006
#> 16 b_008 c_007
#> 17 b_009 c_007
#> 18 b_002 c_008
#> 19 b_003 c_008
#> 20 b_004 c_008
#> 21 b_005 c_008
#> 22 b_001 c_009
#> 23 b_005 c_009
#> 24 b_003 c_010
#> 25 b_009 c_010
weave(x, b ~ a, out.format = "matrix")
#> 10 x 9 sparse Matrix of class "ngCMatrix"
#>        a
#> b       a_001 a_002 a_003 a_005 a_006 a_007 a_008 a_009 a_010
#>   b_001     |     |     |     .     .     .     .     |     .
#>   b_002     .     .     .     |     .     .     |     .     |
#>   b_003     .     .     .     |     |     .     .     .     .
#>   b_004     |     .     .     .     |     .     .     .     .
#>   b_005     |     .     .     .     .     .     .     .     |
#>   b_006     .     |     .     .     .     .     .     .     .
#>   b_007     .     .     .     .     .     |     .     .     .
#>   b_008     .     |     .     |     |     .     .     |     .
#>   b_009     .     |     |     .     .     .     .     .     |
#>   b_010     |     |     .     |     .     .     .     .     .

# Merge variables with "+" operator, new names get concatenated with ".":
weave(x, b ~ c + d)
#>        b   c.d
#> 1  b_004 c_001
#> 2  b_008 c_001
#> 3  b_010 c_001
#> 4  b_005 c_002
#> 5  b_003 c_003
#> 6  b_008 c_003
#> 7  b_001 c_004
#> 8  b_004 c_004
#> 9  b_005 c_004
#> 10 b_009 c_004
#> 11 b_001 c_005
#> 12 b_003 c_005
#> 13 b_001 c_006
#> 14 b_004 c_006
#> 15 b_007 c_006
#> 16 b_008 c_007
#> 17 b_009 c_007
#> 18 b_002 c_008
#> 19 b_003 c_008
#> 20 b_004 c_008
#> 21 b_005 c_008
#> 22 b_001 c_009
#> 23 b_005 c_009
#> 24 b_003 c_010
#> 25 b_009 c_010
#> 26 b_001 d_001
#> 27 b_003 d_001
#> 28 b_004 d_001
#> 29 b_005 d_001
#> 30 b_007 d_001
#> 31 b_008 d_001
#> 32 b_009 d_001
#> 33 b_001 d_002
#> 34 b_005 d_002
#> 35 b_001 d_003
#> 36 b_002 d_003
#> 37 b_003 d_003
#> 38 b_004 d_003
#> 39 b_005 d_003
#> 40 b_003 d_004
#> 41 b_004 d_004
#> 42 b_008 d_004
#> 43 b_010 d_004
#> 44 b_001 d_005
#> 45 b_002 d_005
#> 46 b_003 d_005
#> 47 b_004 d_005
#> 48 b_005 d_005
#> 49 b_007 d_005
#> 50 b_003 d_006
#> 51 b_008 d_006
#> 52 b_001 d_007
#> 53 b_002 d_007
#> 54 b_003 d_007
#> 55 b_004 d_007
#> 56 b_005 d_007
#> 57 b_007 d_007
#> 58 b_008 d_007
#> 59 b_009 d_007
#> 60 b_001 d_008
#> 61 b_003 d_008
#> 62 b_004 d_008
#> 63 b_005 d_008
#> 64 b_008 d_008
#> 65 b_009 d_008
#> 66 b_010 d_008
#> 67 b_001 d_009
#> 68 b_004 d_009
#> 69 b_007 d_009
#> 70 b_001 d_010
#> 71 b_004 d_010
#> 72 b_005 d_010
#> 73 b_009 d_010

# Control intermediate variable types "~", returning a MultiFactor:
weave(x, a ~ c ~ e )
#> A MultiFactor::MultiFactor list S7_object,
#>     3 feature types across 2 LinkMaps.
#> 
#>     a  c e
#> a2c 9 10 .
#> c2e .  9 9
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> a :  9 Levels: a_001 a_002 ... a_010 
#> c : 10 Levels: c_001 c_002 ... c_010 
#> e : 10 Levels: e_001 e_002 ... e_007 

# Combine merging and intermediate stops:
weave(x, a ~ b + c ~ d + e ~ f )
#> A MultiFactor::MultiFactor list S7_object,
#>     4 feature types across 3 LinkMaps.
#> 
#>         a b.c d.e  f
#> a2b.c   9  20   .  .
#> b.c2d.e .  18  19  .
#> d.e2f   .   .  20 10
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> a   :  9 Levels: a_001 a_002 ... a_010 
#> b.c : 20 Levels: b_001 b_002 ... c_010 
#> d.e : 20 Levels: d_001 d_002 ... e_007 
#> f   : 10 Levels: f_001 f_002 ... f_010 
```
