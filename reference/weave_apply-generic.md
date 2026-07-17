# Index a table and apply arbitrary code to it

`weave_apply()` is an S7 generic that finds a path through a relational
object and evaluates provided code to each corresponding subset of an
input table.

## Usage

``` r
weave_apply(.x, .path, .data, .fun = NULL, ...)
```

## Arguments

- .x:

  input relational object to dispatch on.

- .path:

  either a `formula` or a `character vector` of length 2 with the names
  of the desired combination of feature types.

- .data:

  an R object, such as tabular data.

- .fun:

  the function to be applied to each subgroup of `.x`.

- ...:

  Optional arguments to `.fun`

## Value

a list containing the results of `.fun`.

## Examples

``` r
# Available methods:
weave_apply
#> <S7_generic> weave_apply(.x, .path, .data, .fun = NULL, ...) with 1 methods:
#> 1: method(weave_apply, MultiFactor::MultiFactor)
```
