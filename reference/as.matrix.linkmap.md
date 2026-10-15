# Convert a linkmap to a sparse matrix. Convert a linkmap to a sparse matrix object from the `Matrix` package.

Convert a linkmap to a sparse matrix. Convert a linkmap to a sparse
matrix object from the `Matrix` package.

## Usage

``` r
# S3 method for class '`multifactor::linkmap`'
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

  a `linkmap` object.

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

## Examples

``` r
x <- random_linkmap()
as.matrix(x)
#> 26 x 26 sparse Matrix of class "ngCMatrix"
#>   [[ suppressing 26 column names ‘A’, ‘B’, ‘C’ ... ]]
#>      UPPER
#> lower                                                    
#>     g | . . | . . . . . | . | . . . . | | | | | | . | . |
#>     h | | . | | | | | . . | | | | | | | . | | | . . | . .
#>     i | | . | | . | . | . . . . . | | . . . . | | | . . .
#>     j | . | | . . . | . | | . . . | | | . | . . . . | | .
#>     m | | . | | . | | | . . . | . . . | . | . | | | | . |
#>     n | | | | . | . . | . . . | . . . | | . | | . . | | |
#>     o | . . | . . | . | | . | | | . . | . . | . . | . . .
#>     p | | | . . . . | . | | | | | | | | | . | | . | | . .
#>     r | | . . . . | | . | | | | . | . . . | | | . | . | |
#>     t | . | | . . . . . | | | . . | . | . | . . . . | | |
#>     u | | | | | | | . . . . . . . | . . . | . . | | . | .
#>     v | | . | . . | . . | . | | . . . . | . . | | . | | |
#>     w | . | | | | | | | | | . | . | . . | . | | | | | . .
#>     x | | . | | | | | | . | . . | | | . . . | | | | | | |
#>     a . | . . . | | . | . | | . | . | | | | | . . . . . .
#>     d . | | . . . | | . . . . . | . . . | | | | | . . . .
#>     e . | | . | | . | | . | | . . | | . . | | | . . . . .
#>     f . | | | | | | | | | | . . . . . . | | . . | . . | |
#>     l . | | | | . . | . . | . | | . | | | | . | | | . | .
#>     q . | . . . . . . . . . | . . | | . . . . . | . . | |
#>     c . . | | | . | . . . | | | | . . . . | | | | . | . |
#>     s . . | . | . . | | . . | . . . | . . . | | | | | . |
#>     z . . . | . . . | | | | . . . . | | . | . . | . | . .
#>     b . . . . | . | . . | . | . | . . . . . . . | . | . .
#>     k . . . . | | . . . | | | . | | . . | | . . | . | . .
#>     y . . . . . . | . . | | . | . | | . | | . | . | . | |
```
