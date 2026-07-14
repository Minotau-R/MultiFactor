# Perform enrichtment analysis from a weave

Perform enrichtment analysis from a weave

## Usage

``` r
weave_coverage(
  x,
  .path,
  .data = NULL,
  metric = c("count", "size", "coverage", "complete"),
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
set.seed(2612)
# Draw five cards from a deck
drawn  <- draw_cards(5)
drawn
#> [1] "Jack♦️" "5♥️"    "King♠️" "7♥️"    "6♦️"   
scores <- poker_scores()
scores
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

# Now enrich input
result <- weave_coverage(
    x = scores, .path = card ~ suit, .data = drawn, metric = "count"
)

result
#> A MultiFactor::LinkMap data.frame S7_object: 52 rows.
#>    card  suit
#> 1  Ace♣️ clubs
#> 2    2♣️ clubs
#> 3    3♣️ clubs
#> 4    4♣️ clubs
#> 5    5♣️ clubs
#> 6    6♣️ clubs
#> 7    7♣️ clubs
#> 8    8♣️ clubs
#> 9    9♣️ clubs
#> 10  10♣️ clubs
#>  + 42 more rows. Use `print(n = ...)` to see more rows.
#> 
#> @ levels:   2 variables: 
#>  $ card : 52 Levels: 10♠️ ... Queen♦️ 
#>  $ suit :  4 Levels: clubs diamonds hearts spades 
#> 
#> @ metadata: 1 variables: 
#> List of 1
#>  $ count: int  0 0 0 0 0 0 0 0 0 0 ...

# Now let's spike a hand
cheat <- draw_cards()[c(1, 10, 11, 12, 13)]
cheat
#> [1] "Ace♥️"   "10♥️"    "Jack♥️"  "Queen♥️" "King♥️" 

.path = c("card", "rank", "straight")
weave_coverage(scores, c("card", "rank", "straight"), .data = cheat)
#> A MultiFactor::LinkMap data.frame S7_object: 16 rows.
#>    card   straight
#> 1   10♣️    6 to 10
#> 2   10♣️  7 to Jack
#> 3   10♥️  7 to Jack
#> 4   10♣️ 8 to Queen
#> 5   10♥️ 8 to Queen
#> 6   10♦️ 8 to Queen
#> 7   10♣️  9 to King
#> 8   10♥️  9 to King
#> 9   10♦️  9 to King
#> 10   2♠️  9 to King
#>  + 6 more rows. Use `print(n = ...)` to see more rows.
#> 
#> @ levels:   2 variables: 
#>  $ card     : 5 Levels: 10♠️ ... 2♠️ 
#>  $ straight : 6 Levels: 6 to 10 ... Royal straight 
#> 
#> @ metadata: 4 variables: 
#> List of 4
#>  $ count   : num  1 2 2 3 3 3 4 4 4 4 ...
#>  $ size    : int  5 5 5 5 5 5 5 5 5 5 ...
#>  $ coverage: num  0.2 0.4 0.4 0.6 0.6 0.6 0.8 0.8 0.8 0.8 ...
#>  $ complete: logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
```
