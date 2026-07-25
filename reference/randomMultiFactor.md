# Generate and optionally draw from a poker deck.

Randomly generate a valid `MultiFactor` or `LinkMap` object.
`randomMultiFactor` can optionally take am `igraph` object to determine
its layout. (See examples) `trade_posts()` generates a random
`MultiFactor` in the style of the trading example from the vignette.

called by `randomMultiFactor`, shouldn't be called by user.

## Usage

``` r
draw_cards(draw = NULL)

poker_scores()

randomMultiFactor(layout = NULL, n_features = 10, sparseness = 0.75)

trade_posts(raw.data = FALSE)

randomLinkMap(x = list(lower = letters, UPPER = LETTERS), sparseness = 0.5)
```

## Arguments

- draw:

  Optional `integer`. How many cards to draw from the deck.

- layout:

  `igraph`, optional graph structure to generate random data for

- n_features:

  `Numeric scalar`, number of features per type

- sparseness:

  `Numeric scalar`, proportion: How rare are connections. Default is
  `0.5`.

- raw.data:

  `Boolean`, Whether to return the `data.frame` of goods rather than the
  default `MultiFactor`.

- x:

  optional list of two named vectors of features to use. Default is
  `list(lower = letters, UPPER = LETTERS)`.

## Value

a randomly generated object of the specified class.

## See also

[playing_cards](https://minotau-r.github.io/MultiFactor/reference/playing_cards.md)

[`MultiFactor()`](https://minotau-r.github.io/MultiFactor/reference/MultiFactor-class.md)

[`LinkMap()`](https://minotau-r.github.io/MultiFactor/reference/LinkMap-class.md)

## Examples

``` r
# Make a random MultiFactor object
randomMultiFactor()
#> A MultiFactor::MultiFactor list S7_object,
#>     6 feature types across 5 LinkMaps.
#> 
#>     a  b c  d  e f
#> a2b 8 10 .  .  . .
#> b2c . 10 9  .  . .
#> c2d .  . 9 10  . .
#> d2e .  . .  9 10 .
#> e2f .  . .  . 10 8
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> @ levels:
#>  $ a : 10 Levels: a_001 a_002 ... a_010 
#>  $ b : 10 Levels: b_001 b_002 ... b_010 
#>  $ c : 10 Levels: c_001 c_002 ... c_010 
#>  $ d : 10 Levels: d_001 d_002 ... d_010 
#>  $ e : 10 Levels: e_001 e_002 ... e_010 
#>  $ f : 10 Levels: f_001 f_002 ... f_010 

# Use a (possibly random) igraph as input:
randomMultiFactor( igraph::sample_gnp(6, 2/3) )
#> A MultiFactor::MultiFactor list S7_object,
#>     6 feature types across 6 LinkMaps.
#> 
#>       v1 v2 v4 v3 v5 v6
#> v12v2  9  9  .  .  .  .
#> v12v4  9  .  9  .  .  .
#> v22v4  .  9 10  .  .  .
#> v32v5  .  .  .  9  9  .
#> v42v5  .  .  9  . 10  .
#> v42v6  .  . 10  .  .  9
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> @ levels:
#>  $ v1 : 10 Levels: v1_001 v1_002 ... v1_010 
#>  $ v2 : 10 Levels: v2_001 v2_002 ... v2_010 
#>  $ v4 : 10 Levels: v4_001 v4_002 ... v4_010 
#>  $ v3 : 10 Levels: v3_001 v3_002 ... v3_010 
#>  $ v5 : 10 Levels: v5_001 v5_002 ... v5_010 
#>  $ v6 : 10 Levels: v6_001 v6_002 ... v6_010 

# Make a random LinkMap object
randomLinkMap()
#> A MultiFactor::LinkMap data.frame S7_object: 338 rows.
#>    lower UPPER
#> 1      a     A
#> 2      c     A
#> 3      d     A
#> 4      e     A
#> 5      f     A
#> 6      h     A
#> 7      j     A
#> 8      l     A
#> 9      m     A
#> 10     n     A
#>  + 328 more rows. Use `print(n = ...)` to see more rows.
#> 
#> @ levels:   2 variables: 
#>  $ lower : 26 Levels: a ... s 
#>  $ UPPER : 26 Levels: A ... Z 

# Make a random MultiFactor with the trading goods from the vignettes
trade_posts()
#> A MultiFactor::MultiFactor list S7_object,
#>     6 feature types across 6 LinkMaps.
#> 
#>                     books fruit furniture instruments marbles clothing
#> books2fruit             6     6         .           .       .        .
#> books2furniture         6     .         5           .       .        .
#> books2instruments       6     .         .           4       .        .
#> books2marbles           3     .         .           .       5        .
#> clothing2marbles        .     .         .           .       4        6
#> instruments2marbles     .     .         .           6       6        .
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> @ levels:
#>  $ books       : 6 Levels: fancy book ... plain book 
#>  $ fruit       : 6 Levels: apples ... grapes 
#>  $ furniture   : 6 Levels: couch ... door 
#>  $ instruments : 6 Levels: trumpet ... saxophone 
#>  $ marbles     : 6 Levels: red marble ... sparkly marble 
#>  $ clothing    : 6 Levels: t-shirt ... scarf 

# Playing cards
draw_cards(5)
#> [1] "9♦️"     "Ace♠️"   "3♠️"     "Queen♣️" "4♥️"    
poker_scores()
#> A MultiFactor::MultiFactor list S7_object,
#>     4 feature types across 3 LinkMaps.
#> 
#>               card rank suit straight
#> card2rank       52   13    .        .
#> card2suit       52    .    4        .
#> rank2straight    .   13    .       10
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> @ levels:
#>  $ card     : 52 Levels: Ace♥️ ... King♣️ 
#>  $ rank     : 13 Levels: Ace ... King 
#>  $ suit     :  4 Levels: hearts spades diamonds clubs 
#>  $ straight : 10 Levels: Ace to 5 ... Royal straight 
```
