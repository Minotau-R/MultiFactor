# Methods for path_frame S7 container class

Methods for path_frame S7 container class

## Arguments

- x, object:

  `MultiFactor` on which the method should be applied.

## Value

A `MultiFactor`

## Examples

``` r
x <- randomMultiFactor()

# Generate a path_frame
p <- select_path(x, a ~ d)

# Get formula notation for the full path:
formula(p)
#> a ~ b ~ c ~ d
```
