# Index a table and apply arbitrary code to it

`subgroup_apply` can run arbitrary code specified by `FUN` across any
number of row-based subsets of table `X`. Mimics lapply.

## Usage

``` r
subgroup_apply(X, LINK, BY, FUN = NULL, ..., INDEX = "row.names")
```

## Arguments

- X:

  `A table`. A `data.frame`, `matrix`, other object with rows and
  columns.

- LINK:

  a `MultiFactor` object.

- BY:

  either a `formula` or a \`character vector“ of length 2 with the names
  of the desired combination of feature types.

- FUN:

  A function, passed to lapply.

- ...:

  Additional arguments passed to lapply call.

- INDEX:

  `Character scalar` Where in `X` can the target feature names be found.
  (Default: "row.names")

## Value

a `Named list` of desired output.

## See also

[`weave()`](https://minotau-r.github.io/MultiFactor/reference/weave-generic.md)
[`LinkMap()`](https://minotau-r.github.io/MultiFactor/reference/LinkMap-class.md)
[`MultiFactor()`](https://minotau-r.github.io/MultiFactor/reference/MultiFactor-class.md)

## Examples

``` r

# Prepare data

link <- trade_posts()

# Generate small example feature table 'x'.
n <- nlevels(link)[["clothing"]]
x <- replicate(10, rbinom(n, rbinom(n, 100, runif(n)), runif(n)))

#' # Ensure rownames correspond to the second (RHS) variable in the formula.
x <- as.data.frame(x, row.names = levels(link)$clothing)

# Apply arbitrary code to x based on group membership
subgroup_apply(x, link, BY = fruit ~ clothing, FUN = function(x) colSums(x))
#> $apples
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  86  60 110  87  38  65 104 118  11 162 
#> 
#> $cherries
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  64   2  39  15   1  57  12   6  11  21 
#> 
#> $grapes
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  61  54  97  56  29  39 104  68   9 118 
#> 
#> $melons
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  61  54  97  56  29  39 104  68   9 118 
#> 
#> $oranges
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#> 150  62 149 102  39 122 116 124  22 183 
#> 
#> $pears
#>  V1  V2  V3  V4  V5  V6  V7  V8  V9 V10 
#>  90  65  96  20  62  91  37  50  28  98 
#> 
```
