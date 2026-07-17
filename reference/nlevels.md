# The Number of Levels of an Object

Return the number of levels which its argument has. Extends
[`base::nlevels`](https://rdrr.io/r/base/nlevels.html).

## Usage

``` r
nlevels(x, ...)
```

## Arguments

- x:

  an object, such as a `LinkMap`, `MultiFactor` or `factor`.

- ...:

  additional arguments. Not used for
  [`base::factor`](https://rdrr.io/r/base/factor.html) method.

## Value

A `Numeric vector` of length equal to the number of elements in `x`.
Optionally, named.

## Examples

``` r
# Available methods:
nlevels
#> <S7_generic> nlevels(x, ...) with 3 methods:
#> 1: method(nlevels, MultiFactor::MultiFactor)
#> 2: method(nlevels, MultiFactor::LinkMap)
#> 3: method(nlevels, class_any)
```
