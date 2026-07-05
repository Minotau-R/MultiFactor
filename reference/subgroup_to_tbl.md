# Expand a table based on possibly overlapping group membership.

Expand a table into a tidy table suitable for tidyverse-stype
operations.

## Usage

``` r
subgroup_to_tbl(x, link, .path, .index = "row.names")
```

## Arguments

- x:

  `A table`. A `data.frame`, `matrix`, other object with rows and
  columns. Should have a `cbind` method.

- link:

  a `MultiFactor`.

- .path:

  either a `formula` or a \`character vector“ of length 2 with the names
  of the desired combination of feature types.

- .index:

  `Character scalar` Column to look for feature IDs to link. Default:
  "row.names".

## Value

An expanded table `x`, with an added first column containing subgroups.

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
subgroup_to_tbl(x, link, .path = fruit ~ clothing)
#>      fruit clothing V1 V2 V3 V4 V5 V6 V7 V8 V9 V10
#> 1    pears  t-shirt 43  3 26 21 32  0  0 65 22   0
#> 2   grapes    dress  5  0 15 84 68 26 15 39  0   0
#> 3   melons    socks 54  7  1 35 15  7 14 10  8  17
#> 4  oranges    socks 54  7  1 35 15  7 14 10  8  17
#> 5   apples   gloves  6  1 14  2 33 22 32 67  1  52
#> 6 cherries   gloves  6  1 14  2 33 22 32 67  1  52
#> 7  oranges   gloves  6  1 14  2 33 22 32 67  1  52
#> 8  oranges      hat 13 27 14 16 40 20 32  9 12  36
#> 9    pears    scarf 14 29 67  3 17  4 27  3  7   5
```
