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
#> A MultiFactor::LinkMap data.frame S7_object: 80 rows.
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
#>  + 70 more rows. Use `print(n = ...)` to see more rows.
#> Levels:
#> b   : 10 Levels: b_001 b_002 ... b_010 
#> c.d : 20 Levels: c_001 c_002 ... d_010 
```
