# Methods for MultiFactor S7 container class

Methods for MultiFactor S7 container class

## Arguments

- x, object:

  `MultiFactor` on which the method should be applied.

## Value

A `MultiFactor`

## Examples

``` r
# Setup
a2b <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    b = sample(LETTERS[seq(3)], 10, replace = TRUE)
)
a2c <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    c = sample(LETTERS[seq(3)], 10, replace = TRUE)
)

# Create MultiFactor
x <- MultiFactor(list(a2b, a2c))

# Basic properties
dim(x)
#> [1] 2 3
dimnames(x)
#> [[1]]
#> [1] "a2b" "a2c"
#> 
#> [[2]]
#> [1] "a" "b" "c"
#> 

# Factor-like properties
levels(x)
#> $a
#> [1] "a" "b" "c"
#> 
#> $b
#> [1] "A" "B" "C"
#> 
#> $c
#> [1] "A" "B" "C"
#> 
nlevels(x)
#> a b c 
#> 3 3 3 

# Retain MultiFactor structure using `[`.
x["a2b"]
#> A MultiFactor::MultiFactor list S7_object,
#>     2 feature types across 1 LinkMaps.
#> 
#>     a b
#> a2b 3 3
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> @ levels:
#>  $ a : 3 Levels: a b c 
#>  $ b : 3 Levels: A B C 

# Or extract individual LinkMaps using `[[`
x[["a2c"]]
#> A MultiFactor::LinkMap data.frame S7_object: 7 rows.
#>   a c
#> 1 a A
#> 2 c A
#> 3 b A
#> 4 a C
#> 5 a B
#> 6 c C
#> 7 b B
#> 
#> @ levels:   2 variables: 
#>  $ a : 3 Levels: a b c 
#>  $ c : 3 Levels: A B C 

# Subset by a path
subset(x, a ~ c)
#> A MultiFactor::MultiFactor list S7_object,
#>     2 feature types across 1 LinkMaps.
#> 
#>     a c
#> a2c 3 3
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> @ levels:
#>  $ a : 3 Levels: a b c 
#>  $ c : 3 Levels: A B C 

# Unused features will be dropped unless specified:
subset(x, a ~ c, drop.unmatched = FALSE)
#> A MultiFactor::MultiFactor list S7_object,
#>     2 feature types across 1 LinkMaps.
#> 
#>     a c
#> a2c 3 3
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> @ levels:
#>  $ a : 3 Levels: a b c 
#>  $ c : 3 Levels: A B C 

# Combine using `c`:
c(x[2], x[1])
#> A MultiFactor::MultiFactor list S7_object,
#>     3 feature types across 2 LinkMaps.
#> 
#>     a c b
#> a2c 3 3 .
#> a2b 3 . 3
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> @ levels:
#>  $ a : 3 Levels: a b c 
#>  $ c : 3 Levels: A B C 
#>  $ b : 3 Levels: A B C 
```
