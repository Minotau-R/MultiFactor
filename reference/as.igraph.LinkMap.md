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
#> IGRAPH 9df2fa1 UN-B 52 338 -- 
#> + attr: type (v/l), name (v/c)
#> + edges from 9df2fa1 (vertex names):
#>   [1] b--A c--A d--A e--A i--A j--A k--A l--A m--A o--A p--A s--A v--A w--A z--A
#>  [16] c--B d--B i--B l--B m--B p--B w--B a--B g--B n--B r--B t--B x--B y--B c--C
#>  [31] e--C k--C p--C v--C f--C h--C q--C u--C c--D d--D e--D j--D k--D l--D o--D
#>  [46] p--D s--D z--D a--D t--D x--D f--D h--D c--E d--E i--E j--E l--E p--E s--E
#>  [61] v--E z--E a--E n--E r--E y--E f--E h--E b--F d--F i--F l--F m--F v--F z--F
#>  [76] g--F r--F x--F h--F u--F c--G d--G i--G j--G l--G o--G s--G v--G w--G g--G
#>  [91] n--G r--G x--G y--G h--G u--G b--H d--H i--H l--H o--H p--H w--H z--H n--H
#> [106] r--H x--H y--H f--H h--H q--H c--I d--I j--I k--I o--I p--I s--I a--I r--I
#> + ... omitted several edges
```
