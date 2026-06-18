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
#> IGRAPH 14fcf07 UN-B 52 338 -- 
#> + attr: type (v/l), name (v/c)
#> + edges from 14fcf07 (vertex names):
#>   [1] d--A e--A f--A g--A h--A j--A k--A l--A m--A n--A p--A q--A r--A s--A t--A
#>  [16] v--A w--A a--B b--B c--B f--B g--B h--B i--B j--B k--B m--B o--B p--B q--B
#>  [31] r--B s--B z--B c--C e--C f--C i--C o--C q--C s--C t--C u--C v--C w--C z--C
#>  [46] a--D d--D e--D f--D h--D i--D k--D n--D p--D r--D s--D u--D v--D z--D b--E
#>  [61] e--E f--E g--E j--E l--E n--E p--E r--E t--E w--E e--F f--F g--F h--F i--F
#>  [76] j--F k--F l--F r--F s--F u--F v--F x--F z--F a--G e--G f--G g--G n--G o--G
#>  [91] p--G r--G t--G u--G v--G x--G y--G a--H d--H e--H j--H k--H l--H o--H p--H
#> [106] q--H r--H u--H v--H w--H y--H a--I d--I g--I j--I n--I o--I p--I s--I v--I
#> + ... omitted several edges
```
