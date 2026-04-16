# MultiFactor S7 container class

`MultiFactor` is an S7 class to organize and manage multiple sets of
factors, for instance when tracing or converting feature IDs across
databases. Methods for `MultiFactor` aim to follow `factor` behaviour.

## Usage

``` r
MultiFactor(x)
```

## Arguments

- x:

  a `LinkMap`, or named list of `LinkMap` objects.

## Value

a `MultiFactor` object.

## Details

The most straightforward way to construct a `MultiFactor` object is as a
named list of named data.frames. The columns of the data.frames indicate
the category of factor in that column.

A `MultiFactor` object presents itself similar to a `data.frame`, in the
sense that level types can be called as columns and individual
data.frame components can be called as rows. `MultiFactor` inherits from
`list`; Content can be accessed through regular list methods (e.g., `[`,
`[[`).

## Slots

- `levels`:

  `Named list of character vectors`. Accessed through `levels(x)`

- `map`:

  `(sparse) Matrix` specifying which elements contain which levels.

## See also

[`MultiFactor-methods()`](https://minotau-r.github.io/MultiFactor/reference/MultiFactor-methods.md)

[`LinkMap()`](https://minotau-r.github.io/MultiFactor/reference/LinkMap-class.md)

## Examples

``` r
# Generate some random linkage input
a2b <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    b = sample(LETTERS[seq(3)], 10, replace = TRUE)
)
a2c <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    c = sample(LETTERS[seq(3)], 10, replace = TRUE)
)
x <- MultiFactor(list(a2b, a2c))
```
