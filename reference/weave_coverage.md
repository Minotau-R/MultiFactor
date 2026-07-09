# Perform enrichtment analysis from a weave

Perform enrichtment analysis from a weave

## Usage

``` r
weave_coverage(
  x,
  .path,
  .data = NULL,
  metric = c("count", "coverage", "complete"),
  out.format = c("LinkMap", "matrix"),
  .data_column = "row.names"
)
```

## Arguments

- x:

  a `MultiFactor`

- .path:

  Either a `formula` or a `character vector` of length 2 with the names
  of the desired combination of feature types.

- .data:

  Optional `Character vector`. Lists observed features from the found
  within the first element of `.path`. Alternatively, a `data.frame`
  with the same information. (Also see `.data_column` argument).

- metric:

  `Character scalar`. One of `'count'`, `'coverage'`, `'complete'`.

- out.format:

  `Character scalar`. One of `'LinkMap'`, `'matrix'`.

- .data_column:

  `Character scalar`. if `.data` is a table, where to find feature IDs

## Value

a `LinkMap` or `matrix` with the desired coverage information in the
@metadata slot.

## Examples

``` r
# Generate random data
x <- randomMultiFactor(n_features = 20)

# Spike in a lower number of a observations
x <- MultiFactor(
    list(x[[1]][sample(size = 5, 1:NROW(x[[1]])),], x[[2]])
)

# Now enrich test input
weave_coverage(x, a ~ b ~ c)
#>        a     c
#> 1  a_001 c_001
#> 2  a_002 c_001
#> 3  a_002 c_002
#> 4  a_018 c_002
#> 5  a_001 c_003
#> 6  a_013 c_003
#> 7  a_018 c_003
#> 8  a_002 c_004
#> 9  a_013 c_004
#> 10 a_002 c_005
#> 11 a_013 c_005
#> 12 a_018 c_005
#> 13 a_002 c_006
#> 14 a_013 c_006
#> 15 a_018 c_006
#> 16 a_001 c_007
#> 17 a_002 c_007
#> 18 a_018 c_007
#> 19 a_001 c_009
#> 20 a_018 c_009
#> 21 a_012 c_011
#> 22 a_002 c_012
#> 23 a_018 c_012
#> 24 a_002 c_014
#> 25 a_018 c_014
#> 26 a_001 c_015
#> 27 a_001 c_017
#> 28 a_012 c_017
#> 29 a_018 c_017
#> 30 a_001 c_018
#> 31 a_012 c_018
#> 32 a_001 c_019
#> 33 a_002 c_020
```
