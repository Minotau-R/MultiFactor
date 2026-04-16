# Convert a MultiFactor to relational graph format.

Utility function to convert graph information of a MultiFactor to a
`data.frame`. Used in `as.igraph` method for MultiFactor.

## Usage

``` r
mf_as_graph_df(x)
```

## Arguments

- x:

  MultiFactor

## Value

a `data.frame` with three or more named columns; from, to and name.

## Examples

``` r
x <- randomMultiFactor()

# Three-column dfs of layouts
x_df <- mf_as_graph_df(x)
```
