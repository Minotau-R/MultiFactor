# LinkMap S7 container class

`LinkMap` is an S7 class to organize and manage multiple sets of
factors, for instance when tracing or converting feature IDs across
databases. Methods for `LinkMap` aim to follow `factor` behaviour.

## Usage

``` r
LinkMap(x, metadata = NULL)
```

## Arguments

- x:

  `data.frame` with two named columns that can be coerced to factors.
  Optionally, additional columns will be stored as metadata.

- metadata:

  Optional `data.frame` with same number of rows as x. Contains
  information about the feature link in that row.

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
#> A MultiFactor::LinkMap data.frame S7_object: 8 rows.
#>    a A
#> 1  a A
#> 2  c A
#> 3  c C
#> 4  a C
#> 5  b A
#> 6  c B
#> 9  b C
#> 10 a B
#> Levels:
#> a : 3 Levels: a b c 
#> A : 3 Levels: A B C 
```
