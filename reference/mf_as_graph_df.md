# Convert a multifactor to relational graph format.

Utility function to convert graph information of a multifactor to a
`data.frame`. Used in `as.igraph` method for multifactor.

## Usage

``` r
mf_as_graph_df(x)
```

## Arguments

- x:

  multifactor

## Value

a `data.frame` with three or more named columns; from, to and name.

## Examples

``` r
x <- random_multifactor()

# Three-column dfs of layouts
x_df <- mf_as_graph_df(x)
```
