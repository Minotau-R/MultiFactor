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
#> IGRAPH 8f6d2a9 UN-B 52 338 -- 
#> + attr: type (v/l), name (v/c)
#> + edges from 8f6d2a9 (vertex names):
#>   [1] d--A e--A f--A g--A h--A j--A k--A l--A m--A n--A p--A q--A r--A s--A t--A
#>  [16] u--A x--A y--A a--B b--B c--B f--B h--B j--B k--B m--B n--B o--B p--B q--B
#>  [31] r--B s--B t--B v--B w--B y--B z--B c--C d--C e--C f--C h--C i--C k--C o--C
#>  [46] q--C s--C u--C v--C z--C a--D b--D d--D e--D i--D k--D m--D n--D q--D r--D
#>  [61] s--D t--D u--D v--D z--D c--E e--E h--E i--E j--E m--E p--E t--E u--E w--E
#>  [76] e--F f--F h--F i--F j--F k--F l--F m--F o--F s--F u--F v--F x--F z--F a--G
#>  [91] d--G e--G g--G i--G l--G n--G o--G p--G t--G u--G v--G w--G a--H e--H j--H
#> [106] k--H l--H o--H p--H r--H s--H u--H x--H y--H a--I d--I e--I j--I k--I q--I
#> + ... omitted several edges
```
