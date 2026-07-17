# Convert a LinkMap to igraph

Extract relational information from LinkMap and return an igraph object.
Calls
[`igraph::graph_from_biadjacency_matrix`](https://r.igraph.org/reference/graph_from_biadjacency_matrix.html)
under the hood.

## Usage

``` r
# S3 method for class '`MultiFactor::LinkMap`'
as.igraph(x, directed = FALSE, ...)
```

## Arguments

- x:

  a `MultiFactor`

- directed:

  See
  [`?igraph::graph_from_biadjacency_matrix`](https://r.igraph.org/reference/graph_from_biadjacency_matrix.html)

- ...:

  Additional arguments passed to
  [`igraph::graph_from_biadjacency_matrix`](https://r.igraph.org/reference/graph_from_biadjacency_matrix.html).

## Value

an `igraph` object.

## Details

If a `LinkMap` contains metadata, this can be found back as edge
attributes in the returned graph (see
[`igraph::edge_attr()`](https://r.igraph.org/reference/edge_attr.html))

## Examples

``` r
x <- randomLinkMap()

# Make igraph object:
igraph::as.igraph(x)
#> IGRAPH bde1e1f UN-B 52 338 -- 
#> + attr: type (v/l), name (v/c)
#> + edges from bde1e1f (vertex names):
#>   [1] b--A c--A d--A e--A i--A j--A k--A l--A m--A o--A p--A s--A v--A w--A z--A
#>  [16] a--B c--B d--B g--B i--B l--B m--B n--B p--B r--B t--B w--B x--B y--B c--C
#>  [31] e--C f--C h--C k--C p--C q--C u--C v--C a--D c--D d--D e--D f--D h--D j--D
#>  [46] k--D l--D o--D p--D s--D t--D x--D z--D a--E c--E d--E f--E h--E i--E j--E
#>  [61] l--E n--E p--E r--E s--E v--E y--E z--E b--F d--F g--F h--F i--F l--F m--F
#>  [76] r--F u--F v--F x--F z--F c--G d--G g--G h--G i--G j--G l--G n--G o--G r--G
#>  [91] s--G u--G v--G w--G x--G y--G b--H d--H f--H h--H i--H l--H n--H o--H p--H
#> [106] q--H r--H w--H x--H y--H z--H a--I c--I d--I h--I j--I k--I o--I p--I q--I
#> + ... omitted several edges
```
