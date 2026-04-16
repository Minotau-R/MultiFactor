# Convert a LinkMap to a sparse matrix.

Convert a LinkMap to a sparse matrix.

## Usage

``` r
# S3 method for class '`MultiFactor::LinkMap`'
as.matrix(x, terms = colnames(x), dims = nlevels(x[terms]), ...)
```

## Arguments

- x:

  a `LinkMap` object.

- terms:

  id of cols in their desired order. `c(rows, cols)`.

- dims:

  length-2 integer vector of matrix dimensions.

- ...:

  additional arguments. Not used.

## Value

a sparse biadjacency `Matrix` with

## See also

[`Matrix::sparseMatrix()`](https://rdrr.io/pkg/Matrix/man/sparseMatrix.html)
