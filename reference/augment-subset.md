# Tools to modify MultiFactors

Generates a new `MultiFactor` object by cross-referencing the elements
of a given `MultiFactor`.

## Usage

``` r
# S3 method for class '`MultiFactor::MultiFactor`'
augment(x, ...)
```

## Arguments

- x:

  a `MultiFactor`

- ...:

  Name-value pairs. The name gives the name of the LinkMap in the
  output.

## Value

a `MultiFactor`.

## Examples

``` r
# Only necessary in example code
require(generics)
#> Loading required package: generics
#> 
#> Attaching package: ‘generics’
#> The following objects are masked from ‘package:base’:
#> 
#>     as.difftime, as.factor, as.ordered, intersect, is.element, setdiff,
#>     setequal, union
# Generate a random MultiFactor
x <- randomMultiFactor()

# Use augment to chain together operations like weave and stack, in order.
augment(x,
    weave(x, a ~ c),
    stack(x, a + b ~ c + d),
    weave(x, d ~ f)
)
#> A MultiFactor::MultiFactor list S7_object,
#>     8 feature types across 8 LinkMaps.
#> 
#>          a b  c d  e  f a.b c.d
#> a2b     10 9  . .  .  .   .   .
#> b2c      . 9  9 .  .  .   .   .
#> c2d      . . 10 8  .  .   .   .
#> d2e      . .  . 9 10  .   .   .
#> e2f      . .  . .  9 10   .   .
#> a2c      9 .  9 .  .  .   .   .
#> a.b2c.d  . .  . .  .  .  18  17
#> d2f      . .  . 9  . 10   .   .
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> @ levels:
#>  $ a   : 10 Levels: a_001 a_002 ... a_010 
#>  $ b   : 10 Levels: b_001 b_002 ... b_010 
#>  $ c   : 10 Levels: c_001 c_002 ... c_010 
#>  $ d   : 10 Levels: d_001 d_002 ... d_010 
#>  $ e   : 10 Levels: e_001 e_002 ... e_010 
#>  $ f   : 10 Levels: f_001 f_002 ... f_010 
#>  $ a.b : 20 Levels: a_001 a_002 ... b_010 
#>  $ c.d : 20 Levels: c_001 c_002 ... d_010 

# Setting a LinkMap to NULL by name deletes it from the MultiFactor
augment(x, a2b = NULL )
#> A MultiFactor::MultiFactor list S7_object,
#>     5 feature types across 4 LinkMaps.
#> 
#>     b  c d  e  f
#> b2c 9  9 .  .  .
#> c2d . 10 8  .  .
#> d2e .  . 9 10  .
#> e2f .  . .  9 10
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> @ levels:
#>  $ b : 10 Levels: b_001 b_002 ... b_010 
#>  $ c : 10 Levels: c_001 c_002 ... c_010 
#>  $ d : 10 Levels: d_001 d_002 ... d_010 
#>  $ e : 10 Levels: e_001 e_002 ... e_010 
#>  $ f : 10 Levels: f_001 f_002 ... f_010 
```
