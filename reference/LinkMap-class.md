# LinkMap S7 container class

`LinkMap` is an S7 class to organize and manage multiple sets of
factors, for instance when tracing or converting feature IDs across
databases. Methods for `LinkMap` aim to follow `factor` behaviour.

## Usage

``` r
LinkMap(x)
```

## Arguments

- x:

  `data.frame` with two named columns that can be coerced to factors.
  Optionally, additional columns will be stored as metadata.

## Value

a `LinkMap` object.

## Slots

- `levels`:

  `Named list` of character vectors depicting levels.

- `metadata`:

  `data.frame`. Optional. Used to store additional data or
  application-specific tags.

## See also

[`MultiFactor()`](https://minotau-r.github.io/MultiFactor/reference/MultiFactor-class.md)

## Examples

``` r
# Generate random linkage input
x <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    A = sample(LETTERS[seq(3)], 10, replace = TRUE)
)

# Create LinkMap
LinkMap(x)
#>    a A
#> 1  a A
#> 2  c A
#> 3  c C
#> 4  a C
#> 5  b A
#> 6  c B
#> 7  c B
#> 8  c C
#> 9  b C
#> 10 a B
```
