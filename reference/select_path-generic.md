# Weave a path through an object

`select_path()` is an S7 generic that finds and returns a path through a
relational object.

## Usage

``` r
select_path(x, .path, ...)
```

## Arguments

- x:

  input object

- .path:

  either a `formula` or a `character vector` of length 2 with the names
  of the desired combination of feature types.

- ...:

  additional arguments

## Value

a (list of) character vector(s).

## Examples

``` r
# Available methods:
select_path
#> <S7_generic> select_path(x, .path, ...) with 1 methods:
#> 1: method(select_path, MultiFactor::MultiFactor)
```
