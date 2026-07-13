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
set.seed(2612)
# Draw five cards from a deck
drawn  <- draw_cards(5); drawn
#> [1] "Jack♦️" "5♥️"    "King♠️" "7♥️"    "6♦️"   
scores <- poker_scores()

# Now enrich input
result <- weave_coverage(
    x = scores, .path = card ~ suit, .data = drawn, metric = "count"
)
# show result plus metadata
as.data.frame(result)
#>      card     suit count
#> 1    Ace♣️    clubs     0
#> 2      2♣️    clubs     0
#> 3      3♣️    clubs     0
#> 4      4♣️    clubs     0
#> 5      5♣️    clubs     0
#> 6      6♣️    clubs     0
#> 7      7♣️    clubs     0
#> 8      8♣️    clubs     0
#> 9      9♣️    clubs     0
#> 10    10♣️    clubs     0
#> 11  Jack♣️    clubs     0
#> 12 Queen♣️    clubs     0
#> 13  King♣️    clubs     0
#> 14   Ace♦️ diamonds     2
#> 15     2♦️ diamonds     2
#> 16     3♦️ diamonds     2
#> 17     4♦️ diamonds     2
#> 18     5♦️ diamonds     2
#> 19     6♦️ diamonds     2
#> 20     7♦️ diamonds     2
#> 21     8♦️ diamonds     2
#> 22     9♦️ diamonds     2
#> 23    10♦️ diamonds     2
#> 24  Jack♦️ diamonds     2
#> 25 Queen♦️ diamonds     2
#> 26  King♦️ diamonds     2
#> 27   Ace♥️   hearts     2
#> 28     2♥️   hearts     2
#> 29     3♥️   hearts     2
#> 30     4♥️   hearts     2
#> 31     5♥️   hearts     2
#> 32     6♥️   hearts     2
#> 33     7♥️   hearts     2
#> 34     8♥️   hearts     2
#> 35     9♥️   hearts     2
#> 36    10♥️   hearts     2
#> 37  Jack♥️   hearts     2
#> 38 Queen♥️   hearts     2
#> 39  King♥️   hearts     2
#> 40   Ace♠️   spades     1
#> 41     2♠️   spades     1
#> 42     3♠️   spades     1
#> 43     4♠️   spades     1
#> 44     5♠️   spades     1
#> 45     6♠️   spades     1
#> 46     7♠️   spades     1
#> 47     8♠️   spades     1
#> 48     9♠️   spades     1
#> 49    10♠️   spades     1
#> 50  Jack♠️   spades     1
#> 51 Queen♠️   spades     1
#> 52  King♠️   spades     1
```
