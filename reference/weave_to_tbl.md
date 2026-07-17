# Expand a table based on possibly overlapping group membership.

Expand a table into a tidy table suitable for tidyverse-stype
operations.

## Usage

``` r
weave_to_tbl(x, .path, .data, .index = "row.names")
```

## Arguments

- x:

  a `MultiFactor`.

- .path:

  either a `formula` or a \`character vector“ of length 2 with the names
  of the desired combination of feature types.

- .data:

  `A table`. A `data.frame`, `matrix`, other object with rows and
  columns. Should have a `cbind` method.

- .index:

  `Character scalar` Column to look for feature IDs to link. Default:
  "row.names".

## Value

An expanded table `x`, with an added first column containing subgroups.

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
weave_to_tbl(x, .path = fruit ~ clothing, .data = df)
#>      fruit clothing V1 V2 V3 V4 V5 V6 V7 V8 V9 V10
#> 1   grapes  t-shirt 10 29  5  4 52 72 30  6 53  44
#> 2    pears    dress 14  5 31 19  3 65  2 43 11  16
#> 3   apples    socks 21 14 15 48 25 16 10 25 40  14
#> 4   grapes    socks 21 14 15 48 25 16 10 25 40  14
#> 5 cherries   gloves  2 13  8  4  2 21 13 45  5  38
#> 6   grapes   gloves  2 13  8  4  2 21 13 45  5  38
#> 7   melons   gloves  2 13  8  4  2 21 13 45  5  38
#> 8 cherries      hat 15  2 12 30 40 73  8 28 13  92
#> 9    pears      hat 15  2 12 30 40 73  8 28 13  92
```
