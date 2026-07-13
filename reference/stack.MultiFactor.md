# Combine levels across several LinkMaps in a MultiFactor

Generates a new `LinkMap` object by cross-referencing the elements of a
given `MultiFactor`. Elements can be merged by including several names,
separated by the plus (`+`) sign. See examples.

## Usage

``` r
# S3 method for class '`MultiFactor::MultiFactor`'
stack(x, .path, out.format = c("LinkMap", "matrix"), ...)
```

## Arguments

- x:

  a `MultiFactor`

- .path:

  a `formula` of length 2 with with levels to be merged separated by the
  plus (`+`) sign. Optionally, a list with two character vectors,
  signifying the variables to be combined at the left and right hand
  side, respectively.

- out.format:

  `Character scalar`. One of `'LinkMap'`, `'matrix'`.

- ...:

  Additional arguments (unused.)

## Value

a `LinkMap` or `sparse Matrix`.

## Examples

``` r
x <- randomMultiFactor()
# Merge variables with "+" operator, new names get concatenated with ".":
stack(x, b ~ c + d)
#>        b   c.d
#> 1  b_001 c_001
#> 2  b_004 c_001
#> 3  b_008 c_001
#> 4  b_010 c_001
#> 5  b_003 c_002
#> 6  b_004 c_002
#> 7  b_007 c_002
#> 8  b_009 c_002
#> 9  b_007 c_003
#> 10 b_002 c_004
#> 11 b_003 c_004
#> 12 b_002 c_005
#> 13 b_006 c_005
#> 14 b_003 c_006
#> 15 b_005 c_006
#> 16 b_004 c_007
#> 17 b_010 c_007
#> 18 b_007 c_008
#> 19 b_003 c_009
#> 20 b_004 c_009
#> 21 b_008 c_009
#> 22 b_002 c_010
#> 23 b_004 c_010
#> 24 b_005 c_010
#> 25 b_010 c_010
#> 26 b_003 d_001
#> 27 b_004 d_001
#> 28 b_008 d_001
#> 29 b_010 d_001
#> 30 b_001 d_002
#> 31 b_003 d_002
#> 32 b_004 d_002
#> 33 b_008 d_002
#> 34 b_010 d_002
#> 35 b_003 d_003
#> 36 b_004 d_003
#> 37 b_007 d_003
#> 38 b_009 d_003
#> 39 b_002 d_004
#> 40 b_003 d_004
#> 41 b_004 d_004
#> 42 b_005 d_004
#> 43 b_006 d_004
#> 44 b_007 d_004
#> 45 b_009 d_004
#> 46 b_002 d_005
#> 47 b_003 d_005
#> 48 b_004 d_005
#> 49 b_005 d_005
#> 50 b_007 d_005
#> 51 b_008 d_005
#> 52 b_009 d_005
#> 53 b_010 d_005
#> 54 b_002 d_006
#> 55 b_006 d_006
#> 56 b_007 d_006
#> 57 b_002 d_007
#> 58 b_003 d_007
#> 59 b_004 d_007
#> 60 b_005 d_007
#> 61 b_006 d_007
#> 62 b_007 d_007
#> 63 b_009 d_007
#> 64 b_003 d_008
#> 65 b_004 d_008
#> 66 b_007 d_008
#> 67 b_008 d_008
#> 68 b_009 d_008
#> 69 b_002 d_009
#> 70 b_003 d_009
#> 71 b_004 d_009
#> 72 b_005 d_009
#> 73 b_007 d_009
#> 74 b_009 d_009
#> 75 b_010 d_009
#> 76 b_003 d_010
#> 77 b_004 d_010
#> 78 b_005 d_010
#> 79 b_007 d_010
#> 80 b_009 d_010
```
