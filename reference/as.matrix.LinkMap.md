# Convert a LinkMap to a sparse matrix. Convert a LinkMap to a sparse matrix object from the `Matrix` package.

Convert a LinkMap to a sparse matrix. Convert a LinkMap to a sparse
matrix object from the `Matrix` package.

## Usage

``` r
# S3 method for class '`MultiFactor::LinkMap`'
as.matrix(
  x,
  terms = colnames(x),
  dims = nlevels(x)[terms],
  dimnames = levels(x)[terms],
  value_id = NULL,
  force_pattern = is.null(value_id),
  ...
)
```

## Arguments

- x:

  a `LinkMap` object.

- terms:

  id of cols in their desired order. `c(rows, cols)`.

- dims:

  length-2 integer vector of matrix dimensions. Default: `colnames(x)`

- dimnames:

  list of dimnames. (Default: `levels(x)`).

- value_id:

  Name or index of column in metadata to use as matrix values.

- force_pattern:

  `Boolean`. Whether to ignore value and return a sparse pattern matrix.
  (Default: FALSE)

- ...:

  additional arguments. Not used.

## Value

a sparse biadjacency `Matrix` with

## See also

[`Matrix::sparseMatrix()`](https://rdrr.io/pkg/Matrix/man/sparseMatrix.html)
