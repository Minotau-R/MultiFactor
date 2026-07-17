# Define a path through a MultiFactor object.

Define a path through a MultiFactor object.

## Arguments

- x:

  input object

- .path:

  either a `formula` or a `character vector` of length 2 with the names
  of the desired combination of feature types.

## Value

a `factor_path` object.

## Examples

``` r
#' # Generate pair of random linkage input
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

# Inspect a path between data types
select_path(x, b ~ c)
#> A MultiFactor::factor_path S7_object from `b` to `c`:
#> [[1]]
#> [1] "b" "a" "c"
#> 
```
