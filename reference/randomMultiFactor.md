# Generate a random MultiFactor or LinkMap

Randomly generate a valid `MultiFactor` or `LinkMap` object.
`randomMultiFactor` can optionally take am `igraph` object to determine
its layout. (See examples) `trade_posts()` generates a random
`MultiFactor` in the style of the trading example from the vignette.

called by `randomMultiFactor`, shouldn't be called by user.

## Usage

``` r
randomMultiFactor(layout = NULL, n_features = 10, sparseness = 0.75)

trade_posts(raw.list = FALSE)

randomLinkMap(x = list(lower = letters, UPPER = LETTERS), sparseness = 0.5)
```

## Arguments

- layout:

  `igraph`, optional graph structure to generate random data for

- n_features:

  `Numeric scalar`, number of features per type

- sparseness:

  `Numeric scalar`, proportion: How rare are connections. Default is
  `0.5`.

- raw.list:

  `Boolean`, Whether to return the list of goods rather than the default
  `MultiFactor`.

- x:

  optional list of two named vectors of features to use. Default is
  `list(lower = letters, UPPER = LETTERS)`.

## Value

a randomly generated object of the specified class.

## See also

[`MultiFactor()`](https://minotau-r.github.io/MultiFactor/reference/MultiFactor-class.md)

[`LinkMap()`](https://minotau-r.github.io/MultiFactor/reference/LinkMap-class.md)

## Examples

``` r
# Make a random MultiFactor object
randomMultiFactor()
#> A MultiFactor::MultiFactor list S7_object,
#>     6 feature types across 5 LinkMaps.
#> 
#>     a  b  c  d  e  f
#> a2b 9 10  .  .  .  .
#> b2c . 10 10  .  .  .
#> c2d .  . 10 10  .  .
#> d2e .  .  . 10 10  .
#> e2f .  .  .  .  9 10
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
#>     6 feature types across 13 LinkMaps.
#> 
#>      1  3  2  4  5  6
#> 123 10  9  .  .  .  .
#> 224  .  . 10 10  .  .
#> 124 10  .  . 10  .  .
#> 324  .  9  . 10  .  .
#> 225  .  . 10  . 10  .
#> 125 10  .  .  . 10  .
#> 325  .  9  .  . 10  .
#> 425  .  .  . 10 10  .
#> 226  .  .  9  .  . 10
#> 126  9  .  .  .  .  9
#> 326  . 10  .  .  .  9
#> 426  .  .  .  9  . 10
#> 526  .  .  .  . 10  9
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> 1 : 10 Levels: 1_001 1_002 ... 1_010 
#> 3 : 10 Levels: 3_001 3_002 ... 3_010 
#> 2 : 10 Levels: 2_001 2_002 ... 2_010 
#> 4 : 10 Levels: 4_001 4_002 ... 4_010 
#> 5 : 10 Levels: 5_001 5_002 ... 5_010 
#> 6 : 10 Levels: 6_001 6_002 ... 6_010 

# Make a random LinkMap object
randomLinkMap()
#>     lower UPPER
#> 1       a     A
#> 3       c     A
#> 4       d     A
#> 5       e     A
#> 6       f     A
#> 9       i     A
#> 12      l     A
#> 14      n     A
#> 16      p     A
#> 17      q     A
#> 18      r     A
#> 19      s     A
#> 20      t     A
#> 22      v     A
#> 23      w     A
#> 27      a     B
#> 32      f     B
#> 33      g     B
#> 34      h     B
#> 35      i     B
#> 38      l     B
#> 39      m     B
#> 40      n     B
#> 41      o     B
#> 42      p     B
#> 44      r     B
#> 45      s     B
#> 47      u     B
#> 48      v     B
#> 49      w     B
#> 51      y     B
#> 52      z     B
#> 60      h     C
#> 64      l     C
#> 65      m     C
#> 68      p     C
#> 71      s     C
#> 73      u     C
#> 74      v     C
#> 75      w     C
#> 76      x     C
#> 78      z     C
#> 80      b     D
#> 81      c     D
#> 89      k     D
#> 92      n     D
#> 93      o     D
#> 96      r     D
#> 97      s     D
#> 98      t     D
#> 100     v     D
#> 101     w     D
#> 102     x     D
#> 106     b     E
#> 109     e     E
#> 110     f     E
#> 112     h     E
#> 113     i     E
#> 123     s     E
#> 126     v     E
#> 127     w     E
#> 129     y     E
#> 132     b     F
#> 134     d     F
#> 135     e     F
#> 138     h     F
#> 143     m     F
#> 148     r     F
#> 149     s     F
#> 150     t     F
#> 151     u     F
#> 153     w     F
#> 157     a     G
#> 158     b     G
#> 159     c     G
#> 163     g     G
#> 165     i     G
#> 167     k     G
#> 168     l     G
#> 172     p     G
#> 173     q     G
#> 176     t     G
#> 177     u     G
#> 178     v     G
#> 181     y     G
#> 183     a     H
#> 184     b     H
#> 188     f     H
#> 189     g     H
#> 190     h     H
#> 193     k     H
#> 196     n     H
#> 197     o     H
#> 198     p     H
#> 199     q     H
#> 200     r     H
#> 208     z     H
#> 209     a     I
#> 212     d     I
#> 213     e     I
#> 218     j     I
#> 221     m     I
#> 222     n     I
#> 223     o     I
#> 227     s     I
#> 228     t     I
#> 233     y     I
#> 236     b     J
#> 238     d     J
#> 240     f     J
#> 241     g     J
#> 244     j     J
#> 248     n     J
#> 250     p     J
#> 251     q     J
#> 252     r     J
#> 254     t     J
#> 255     u     J
#> 257     w     J
#> 260     z     J
#> 265     e     K
#> 267     g     K
#> 268     h     K
#> 273     m     K
#> 278     r     K
#> 279     s     K
#> 281     u     K
#> 282     v     K
#> 289     c     L
#> 290     d     L
#> 292     f     L
#> 293     g     L
#> 297     k     L
#> 298     l     L
#> 299     m     L
#> 300     n     L
#> 301     o     L
#> 302     p     L
#> 304     r     L
#> 308     v     L
#> 309     w     L
#> 311     y     L
#> 312     z     L
#> 313     a     M
#> 318     f     M
#> 319     g     M
#> 321     i     M
#> 322     j     M
#> 324     l     M
#> 326     n     M
#> 327     o     M
#> 328     p     M
#> 330     r     M
#> 331     s     M
#> 333     u     M
#> 334     v     M
#> 336     x     M
#> 337     y     M
#> 340     b     N
#> 341     c     N
#> 342     d     N
#> 343     e     N
#> 344     f     N
#> 345     g     N
#> 353     o     N
#> 354     p     N
#> 355     q     N
#> 356     r     N
#> 358     t     N
#> 360     v     N
#> 362     x     N
#> 364     z     N
#> 366     b     O
#> 367     c     O
#> 368     d     O
#> 369     e     O
#> 372     h     O
#> 378     n     O
#> 379     o     O
#> 381     q     O
#> 382     r     O
#> 384     t     O
#> 385     u     O
#> 386     v     O
#> 389     y     O
#> 391     a     P
#> 393     c     P
#> 394     d     P
#> 395     e     P
#> 399     i     P
#> 401     k     P
#> 402     l     P
#> 404     n     P
#> 406     p     P
#> 409     s     P
#> 411     u     P
#> 412     v     P
#> 417     a     Q
#> 418     b     Q
#> 421     e     Q
#> 422     f     Q
#> 424     h     Q
#> 425     i     Q
#> 426     j     Q
#> 427     k     Q
#> 428     l     Q
#> 431     o     Q
#> 433     q     Q
#> 436     t     Q
#> 437     u     Q
#> 438     v     Q
#> 439     w     Q
#> 441     y     Q
#> 442     z     Q
#> 443     a     R
#> 445     c     R
#> 446     d     R
#> 449     g     R
#> 450     h     R
#> 451     i     R
#> 452     j     R
#> 453     k     R
#> 454     l     R
#> 455     m     R
#> 457     o     R
#> 458     p     R
#> 459     q     R
#> 460     r     R
#> 462     t     R
#> 463     u     R
#> 464     v     R
#> 465     w     R
#> 467     y     R
#> 471     c     S
#> 473     e     S
#> 476     h     S
#> 477     i     S
#> 478     j     S
#> 479     k     S
#> 482     n     S
#> 483     o     S
#> 484     p     S
#> 485     q     S
#> 487     s     S
#> 488     t     S
#> 491     w     S
#> 493     y     S
#> 495     a     T
#> 496     b     T
#> 497     c     T
#> 498     d     T
#> 500     f     T
#> 501     g     T
#> 502     h     T
#> 503     i     T
#> 504     j     T
#> 505     k     T
#> 506     l     T
#> 507     m     T
#> 510     p     T
#> 512     r     T
#> 513     s     T
#> 515     u     T
#> 518     x     T
#> 520     z     T
#> 521     a     U
#> 523     c     U
#> 524     d     U
#> 525     e     U
#> 529     i     U
#> 530     j     U
#> 538     r     U
#> 541     u     U
#> 542     v     U
#> 543     w     U
#> 544     x     U
#> 548     b     V
#> 550     d     V
#> 555     i     V
#> 556     j     V
#> 557     k     V
#> 559     m     V
#> 561     o     V
#> 562     p     V
#> 563     q     V
#> 564     r     V
#> 565     s     V
#> 566     t     V
#> 567     u     V
#> 568     v     V
#> 569     w     V
#> 572     z     V
#> 573     a     W
#> 574     b     W
#> 575     c     W
#> 576     d     W
#> 578     f     W
#> 579     g     W
#> 580     h     W
#> 582     j     W
#> 583     k     W
#> 584     l     W
#> 585     m     W
#> 586     n     W
#> 589     q     W
#> 596     x     W
#> 597     y     W
#> 598     z     W
#> 599     a     X
#> 601     c     X
#> 602     d     X
#> 603     e     X
#> 604     f     X
#> 608     j     X
#> 614     p     X
#> 618     t     X
#> 619     u     X
#> 621     w     X
#> 622     x     X
#> 627     c     Y
#> 629     e     Y
#> 630     f     Y
#> 634     j     Y
#> 637     m     Y
#> 639     o     Y
#> 642     r     Y
#> 651     a     Z
#> 656     f     Z
#> 658     h     Z
#> 659     i     Z
#> 660     j     Z
#> 662     l     Z
#> 665     o     Z
#> 667     q     Z
#> 668     r     Z
#> 669     s     Z
#> 675     y     Z
#> 676     z     Z

# Make a random MultiFactor with the trading goods from the vignettes
trade_posts()
#> A MultiFactor::MultiFactor list S7_object,
#>     5 feature types across 5 LinkMaps.
#> 
#>                       furniture instruments fruit clothing marbles
#> furniture2instruments         5           4     .        .       .
#> fruit2clothing                .           .     5        4       .
#> instruments2clothing          .           5     .        5       .
#> fruit2marbles                 .           .     5        .       4
#> instruments2marbles           .           4     .        .       6
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> furniture   : 6 Levels: chair ... chest 
#> instruments : 6 Levels: trumpet ... harp 
#> fruit       : 6 Levels: apple ... blueberry 
#> clothing    : 6 Levels: shirt ... scarf 
#> marbles     : 6 Levels: red marble ... spotted marble 
```
