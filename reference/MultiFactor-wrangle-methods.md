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

# Use augment to build upon the same MultiFactor.
augment(x,
    weave(x, a ~ c),
    weave(x, d ~ f)
)
#> A MultiFactor::MultiFactor list S7_object,
#>     6 feature types across 5 LinkMaps.
#> 
#>      a  b c  d  e f
#> a2b 10  9 .  .  . .
#> b2c  . 10 9  .  . .
#> c2d  .  . 9  9  . .
#> d2e  .  . . 10 10 .
#> e2f  .  . .  . 10 9
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> a : 10 Levels: a_001 a_002 ... a_010 
#> b : 10 Levels: b_001 b_002 ... b_010 
#> c : 10 Levels: c_001 c_002 ... c_010 
#> d : 10 Levels: d_001 d_002 ... d_010 
#> e : 10 Levels: e_001 e_002 ... e_010 
#> f : 10 Levels: f_001 f_002 ... f_010 
# Setting a LinkMap to NULL deletes it from the MultiFactor
augment(x, a2b = NULL )
#> A MultiFactor::MultiFactor list S7_object,
#>     5 feature types across 4 LinkMaps.
#> 
#>      b c  d  e f
#> b2c 10 9  .  . .
#> c2d  . 9  9  . .
#> d2e  . . 10 10 .
#> e2f  . .  . 10 9
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> b : 10 Levels: b_001 b_002 ... b_010 
#> c : 10 Levels: c_001 c_002 ... c_010 
#> d : 10 Levels: d_001 d_002 ... d_010 
#> e : 10 Levels: e_001 e_002 ... e_010 
#> f : 10 Levels: f_001 f_002 ... f_010 
```
