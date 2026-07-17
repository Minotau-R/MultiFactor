# factor_path S7 class

`factor_path` is an S7 class to standardize the various ways in which
paths that can be specified across the `MultiFactor` package. This class
is mostly for internal use.

## Usage

``` r
factor_path(
  x,
  include = list(character()),
  exclude = character(),
  exact = FALSE
)
```

## Arguments

- x:

  `Character vector` of length two; `c(<from>, <to>)`.

- include:

  `List of character vectors`. Which elements are included in the path?
  Length of the list indicates number of paths.

- exclude:

  `Character vector`. Which elements are excluded from the path?

- exact:

  `Logical`. Should the path be followed as is? (i.e., no pathfinding
  required)

## Value

a `factor_path` object.

## Examples

``` r
factor_path(x = c("a", "c"), include = list("b"))
#> A MultiFactor::factor_path S7_object from `a` to `c`:
#> [[1]]
#> [1] "a" "b" "c"
#> 
```
