# Index a table by a MultiFactor and apply arbitrary code to it

`weave_apply` can run arbitrary code specified by `FUN` across any
number of row-based subsets of table `.data`. Mimics lapply.

## Arguments

- .x:

  a `MultiFactor` object.

- .path:

  either a `formula` or a \`character vector“ of length 2 with the names
  of the desired combination of feature types.

- .data:

  `A table`. A `data.frame`, `matrix`, other object with rows and
  columns.

- .fun:

  A function, passed to lapply.

- ...:

  Additional arguments passed to lapply call.

- .index:

  `Character scalar` Where in `.x` can the target feature names be
  found. (Default: "row.names")

## Value

a `Named list` of desired output.

## See also

[`weave()`](https://minotau-r.github.io/MultiFactor/reference/weave-generic.md)
[`lapply()`](https://rdrr.io/r/base/lapply.html)
[`LinkMap()`](https://minotau-r.github.io/MultiFactor/reference/LinkMap-class.md)
[`MultiFactor()`](https://minotau-r.github.io/MultiFactor/reference/MultiFactor-class.md)

## Examples

``` r

# Prepare data
x <- trade_posts()

# Generate small example feature table 'df'.
n <- nlevels(x)[["clothing"]]
df <- replicate(10, rbinom(n, rbinom(n, 100, runif(n)), runif(n)))

#' # Ensure rownames correspond to the second (RHS) variable in the formula.
df <- as.data.frame(df, row.names = levels(x)$clothing)

# Apply arbitrary code to x based on group membership
weave_apply(
    x,
    .path = fruit ~ clothing,
    .data = df,
    .fun = function(x) colSums(x)
)
#> $apples
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  26  34   2  51   9  10  88   8   0  21 
#> 
#> $pears
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  29  20   9   6  15  17  68  59  29  13 
#> 
#> $cherries
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  45  38  31  41  35  47  68 109  36  41 
#> 
#> $oranges
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  26  50  15  59  10  63 157  19  10  32 
#> 
#> $melons
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  16  18  22  35  20  30   0  50   7  28 
#> 
#> $grapes
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  29  36  22  14  16  70 137  70  39  24 
#> 
```
