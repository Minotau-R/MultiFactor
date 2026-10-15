# Methods for path_frame S7 container class

Methods for path_frame S7 container class

## Arguments

- x, object:

  `path_frame` on which the method should be applied.

## Value

A `path_frame` or method-appropriate value.

## Examples

``` r
x <- random_multifactor()

# Generate a path_frame
p <- select_path(x, a ~ d)

# Get formula notation for the full path:
formula(p)
#> a ~ b ~ c ~ d
```
