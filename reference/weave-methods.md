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
# Generate pair of random linkage input
a2b <- data.frame(
   a = sample(letters[seq(3)], 10, replace = TRUE),
   b = sample(LETTERS[seq(3)], 10, replace = TRUE)
)
a2c <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    c = sample(c("x", "y", "z"), 10, replace = TRUE)
)

# Create MultiFactor
x <- MultiFactor(list(a2b, a2c))

# Weave new b2c LinkMap
weave(x, b ~ c)
#>   b c
#> 1 A x
#> 2 B x
#> 3 C x
#> 4 A y
#> 5 B y
#> 6 C y
#> 7 C z
weave(x, b ~ a, out.format = "matrix")
#> 3 x 3 sparse Matrix of class "ngCMatrix"
#>    a
#> b   a b c
#>   A . | .
#>   B | | .
#>   C . | |
```
