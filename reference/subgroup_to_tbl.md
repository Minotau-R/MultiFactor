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
#> 1  oranges  t-shirt 44  9 11  8 27 39 41  4  2  43
#> 2    pears  t-shirt 44  9 11  8 27 39 41  4  2  43
#> 3  oranges    dress 61 26  5 22 12 40  5 22 20  62
#> 4    pears    socks  5 65 38  0 31 66 42  2  3   6
#> 5   melons   gloves 18  6 59 12  3  5 26  5 35   9
#> 6  oranges   gloves 18  6 59 12  3  5 26  5 35   9
#> 7    pears   gloves 18  6 59 12  3  5 26  5 35   9
#> 8 cherries      hat  5 56 23  8 46 15  5  0 25   6
#> 9   grapes      hat  5 56 23  8 46 15  5  0 25   6
```
