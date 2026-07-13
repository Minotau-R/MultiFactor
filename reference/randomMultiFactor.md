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
#>     a b  c  d  e  f
#> a2b 8 9  .  .  .  .
#> b2c . 9  9  .  .  .
#> c2d . . 10  9  .  .
#> d2e . .  . 10 10  .
#> e2f . .  .  .  9 10
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

# Use a (possibly random) igraph as input:
randomMultiFactor( igraph::sample_gnp(6, 2/3) )
#> A MultiFactor::MultiFactor list S7_object,
#>     6 feature types across 11 LinkMaps.
#> 
#>       v1 v2 v4 v3 v5 v6
#> v12v2 10 10  .  .  .  .
#> v12v4  9  .  8  .  .  .
#> v22v4  . 10 10  .  .  .
#> v12v3 10  .  . 10  .  .
#> v22v3  . 10  .  9  .  .
#> v12v5  9  .  .  .  9  .
#> v32v5  .  .  . 10  9  .
#> v12v6  9  .  .  .  . 10
#> v22v6  .  9  .  .  . 10
#> v42v6  .  .  9  .  . 10
#> v52v6  .  .  .  . 10 10
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> v1 : 10 Levels: v1_001 v1_002 ... v1_010 
#> v2 : 10 Levels: v2_001 v2_002 ... v2_010 
#> v4 : 10 Levels: v4_001 v4_002 ... v4_010 
#> v3 : 10 Levels: v3_001 v3_002 ... v3_010 
#> v5 : 10 Levels: v5_001 v5_002 ... v5_010 
#> v6 : 10 Levels: v6_001 v6_002 ... v6_010 

# Make a random LinkMap object
randomLinkMap()
#> A MultiFactor::LinkMap data.frame S7_object: 338 rows.
#>    lower UPPER
#> 1      a     A
#> 2      c     A
#> 3      d     A
#> 4      f     A
#> 5      i     A
#> 6      l     A
#> 7      n     A
#> 8      o     A
#> 9      p     A
#> 10     q     A
#>  + 328 more rows. Use `print(n = ...)` to see more rows.
#> Levels:
#> lower : 26 Levels: a b ... z 
#> UPPER : 26 Levels: A B ... Z 

# Make a random MultiFactor with the trading goods from the vignettes
trade_posts()
#> A MultiFactor::MultiFactor list S7_object,
#>     6 feature types across 6 LinkMaps.
#> 
#>                      books clothing fruit instruments marbles furniture
#> books2clothing           4        6     .           .       .         .
#> clothing2fruit           .        4     6           .       .         .
#> clothing2instruments     .        5     .           6       .         .
#> clothing2marbles         .        5     .           .       5         .
#> fruit2marbles            .        .     5           .       4         .
#> furniture2marbles        .        .     .           .       5         5
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> books       : 6 Levels: fancy book ... plain book 
#> clothing    : 6 Levels: t-shirt ... scarf 
#> fruit       : 6 Levels: apples ... grapes 
#> instruments : 6 Levels: trumpet ... saxophone 
#> marbles     : 6 Levels: red marble ... sparkly marble 
#> furniture   : 6 Levels: couch ... door 

# Playing cards
draw_cards(5)
#> [1] "7♣️"    "9♦️"    "King♦️" "4♣️"    "8♥️"   
poker_scores()
#> A MultiFactor::MultiFactor list S7_object,
#>     3 feature types across 2 LinkMaps.
#> 
#>           card rank suit
#> card2rank   52   13    .
#> card2suit   52    .    4
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> card : 52 Levels: Ace♥️ 2♥️ ... King♣️ 
#> rank : 13 Levels: Ace 2 ... King 
#> suit :  4 Levels: hearts spades diamonds clubs 
```
