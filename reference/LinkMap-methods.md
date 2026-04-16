# Methods for LinkMap S7 container class

Methods for LinkMap S7 container class

## Arguments

- x, object:

  `LinkMap` on which the method should be applied.

## Value

A `LinkMap`

## Examples

``` r
# Setup
a2b <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    b = sample(LETTERS[seq(3)], 10, replace = TRUE)
)

# Create LinkMap
x <- LinkMap(a2b)

# Basic properties
dim(x)
#> [1] 10  2
dimnames(x)
#> [[1]]
#>  [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10"
#> 
#> [[2]]
#> [1] "a" "b"
#> 

# Factor-like properties
levels(x)
#> $a
#> [1] "a" "b" "c"
#> 
#> $b
#> [1] "A" "B" "C"
#> 
nlevels(x)
#> a b 
#> 3 3 

```
