# Methods for factor_path S7 class

Methods for factor_path S7 class

## Arguments

- x, object:

  `factor_path` on which the method should be applied.

## Value

A `factor_path`

## Examples

``` r
# Setup

set.seed(2612)
tp <- trade_posts()
x <- select_path(tp, fruit ~ furniture)

# Basic properties
length(x)
#> [1] 4 4
terms(x)
#> [1] "fruit"     "furniture"
```
