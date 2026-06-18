# Define a path through a MultiFactor object.

Define a path through a MultiFactor object.

## Usage

``` r
select_path(
  x,
  .path,
  include = NULL,
  exclude = NULL,
  exact = NULL,
  as.edges = FALSE
)
```

## Arguments

- x:

  a `MultiFactor`

- .path:

  Either a `formula` or a `character vector` of length 2 with the names
  of the desired combination of feature types.

- include, exclude, exact:

  `Character vectors` Should feature types be included or excluded from
  the available paths? Exact allows for exact path definition.

- as.edges:

  `Boolean scalar` Whether to return names of edges or nodes (Default)
  in the path.

## Value

a list of character vectors.

## Examples

``` r
#' # Generate pair of random linkage input
a2b <- data.frame(
   a = sample(letters[seq(3)], 10, replace = TRUE),
   b = sample(LETTERS[seq(3)], 10, replace = TRUE)
)
a2c <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    c = sample(c("x", "y", "z"), 10, replace = TRUE)
)

# Create MultiFactor
x <- MultiFactor(list(a2b, a2c))

# Inspect a path between data types
select_path(x, b ~ c)
#> [[1]]
#> [1] "b" "a" "c"
#> 
```
