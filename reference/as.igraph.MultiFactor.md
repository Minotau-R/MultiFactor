# Convert a MultiFactor to igraph

Extract relational information from MultiFactor and return an igraph
object. Calls
[`igraph::graph_from_data_frame`](https://r.igraph.org/reference/graph_from_data_frame.html)
under the hood.

## Usage

``` r
# S3 method for class '`MultiFactor::MultiFactor`'
as.igraph(x, directed = FALSE, ...)
```

## Arguments

- x:

  a `MultiFactor`

- directed:

  See
  [`?igraph::graph_from_data_frame`](https://r.igraph.org/reference/graph_from_data_frame.html)

- ...:

  Additional arguments passed to
  [`igraph::graph_from_data_frame`](https://r.igraph.org/reference/graph_from_data_frame.html).

## Value

an `igraph` object.

## Examples

``` r
x <- randomMultiFactor()

# Make igraph object:
igraph::as.igraph(x)
#> IGRAPH ce74668 UN-- 6 5 -- 
#> + attr: name (v/c), name (e/c)
#> + edges from ce74668 (vertex names):
#> [1] a--b b--c c--d d--e e--f
```
