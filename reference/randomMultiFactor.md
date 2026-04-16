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
#>      a b c d  e f
#> a2b 10 9 . .  . .
#> b2c  . 9 9 .  . .
#> c2d  . . 9 9  . .
#> d2e  . . . 8  8 .
#> e2f  . . . . 10 9
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
#>     6 feature types across 10 LinkMaps.
#> 
#>      1  2  3  4  5  6
#> 122 10 10  .  .  .  .
#> 123 10  .  9  .  .  .
#> 223  . 10 10  .  .  .
#> 324  .  .  9  9  .  .
#> 125 10  .  .  . 10  .
#> 225  . 10  .  . 10  .
#> 325  .  . 10  . 10  .
#> 425  .  .  . 10  9  .
#> 426  .  .  . 10  .  8
#> 526  .  .  .  . 10 10
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> 1 : 10 Levels: 1_001 1_002 ... 1_010 
#> 2 : 10 Levels: 2_001 2_002 ... 2_010 
#> 3 : 10 Levels: 3_001 3_002 ... 3_010 
#> 4 : 10 Levels: 4_001 4_002 ... 4_010 
#> 5 : 10 Levels: 5_001 5_002 ... 5_010 
#> 6 : 10 Levels: 6_001 6_002 ... 6_010 

# Make a random LinkMap object
randomLinkMap()
#>     lower UPPER
#> 6       f     A
#> 8       h     A
#> 9       i     A
#> 13      m     A
#> 14      n     A
#> 15      o     A
#> 16      p     A
#> 17      q     A
#> 20      t     A
#> 21      u     A
#> 23      w     A
#> 27      a     B
#> 30      d     B
#> 31      e     B
#> 32      f     B
#> 34      h     B
#> 35      i     B
#> 37      k     B
#> 38      l     B
#> 39      m     B
#> 40      n     B
#> 43      q     B
#> 44      r     B
#> 47      u     B
#> 48      v     B
#> 55      c     C
#> 56      d     C
#> 57      e     C
#> 58      f     C
#> 62      j     C
#> 63      k     C
#> 64      l     C
#> 66      n     C
#> 68      p     C
#> 71      s     C
#> 72      t     C
#> 74      v     C
#> 75      w     C
#> 79      a     D
#> 81      c     D
#> 83      e     D
#> 85      g     D
#> 86      h     D
#> 88      j     D
#> 91      m     D
#> 92      n     D
#> 93      o     D
#> 98      t     D
#> 99      u     D
#> 100     v     D
#> 102     x     D
#> 104     z     D
#> 106     b     E
#> 107     c     E
#> 110     f     E
#> 111     g     E
#> 112     h     E
#> 113     i     E
#> 115     k     E
#> 117     m     E
#> 122     r     E
#> 123     s     E
#> 125     u     E
#> 126     v     E
#> 127     w     E
#> 135     e     F
#> 136     f     F
#> 138     h     F
#> 141     k     F
#> 142     l     F
#> 144     n     F
#> 151     u     F
#> 153     w     F
#> 154     x     F
#> 157     a     G
#> 158     b     G
#> 159     c     G
#> 160     d     G
#> 162     f     G
#> 164     h     G
#> 165     i     G
#> 169     m     G
#> 171     o     G
#> 174     r     G
#> 175     s     G
#> 178     v     G
#> 179     w     G
#> 180     x     G
#> 181     y     G
#> 184     b     H
#> 186     d     H
#> 187     e     H
#> 188     f     H
#> 190     h     H
#> 194     l     H
#> 198     p     H
#> 200     r     H
#> 201     s     H
#> 205     w     H
#> 206     x     H
#> 208     z     H
#> 209     a     I
#> 213     e     I
#> 216     h     I
#> 217     i     I
#> 221     m     I
#> 222     n     I
#> 223     o     I
#> 227     s     I
#> 230     v     I
#> 231     w     I
#> 232     x     I
#> 234     z     I
#> 236     b     J
#> 240     f     J
#> 241     g     J
#> 244     j     J
#> 245     k     J
#> 248     n     J
#> 249     o     J
#> 252     r     J
#> 254     t     J
#> 256     v     J
#> 257     w     J
#> 260     z     J
#> 261     a     K
#> 263     c     K
#> 265     e     K
#> 266     f     K
#> 268     h     K
#> 270     j     K
#> 271     k     K
#> 272     l     K
#> 276     p     K
#> 278     r     K
#> 283     w     K
#> 284     x     K
#> 285     y     K
#> 286     z     K
#> 287     a     L
#> 288     b     L
#> 289     c     L
#> 291     e     L
#> 293     g     L
#> 294     h     L
#> 297     k     L
#> 302     p     L
#> 303     q     L
#> 304     r     L
#> 306     t     L
#> 308     v     L
#> 320     h     M
#> 324     l     M
#> 326     n     M
#> 327     o     M
#> 330     r     M
#> 332     t     M
#> 334     v     M
#> 335     w     M
#> 336     x     M
#> 337     y     M
#> 339     a     N
#> 341     c     N
#> 342     d     N
#> 343     e     N
#> 344     f     N
#> 345     g     N
#> 346     h     N
#> 347     i     N
#> 349     k     N
#> 350     l     N
#> 351     m     N
#> 353     o     N
#> 354     p     N
#> 357     s     N
#> 358     t     N
#> 362     x     N
#> 369     e     O
#> 372     h     O
#> 373     i     O
#> 374     j     O
#> 375     k     O
#> 377     m     O
#> 379     o     O
#> 381     q     O
#> 382     r     O
#> 384     t     O
#> 385     u     O
#> 387     w     O
#> 388     x     O
#> 389     y     O
#> 390     z     O
#> 395     e     P
#> 399     i     P
#> 400     j     P
#> 401     k     P
#> 402     l     P
#> 404     n     P
#> 405     o     P
#> 406     p     P
#> 407     q     P
#> 409     s     P
#> 411     u     P
#> 413     w     P
#> 414     x     P
#> 415     y     P
#> 417     a     Q
#> 418     b     Q
#> 419     c     Q
#> 422     f     Q
#> 425     i     Q
#> 427     k     Q
#> 428     l     Q
#> 429     m     Q
#> 431     o     Q
#> 432     p     Q
#> 437     u     Q
#> 439     w     Q
#> 445     c     R
#> 448     f     R
#> 453     k     R
#> 454     l     R
#> 457     o     R
#> 458     p     R
#> 460     r     R
#> 462     t     R
#> 464     v     R
#> 465     w     R
#> 467     y     R
#> 468     z     R
#> 469     a     S
#> 471     c     S
#> 473     e     S
#> 474     f     S
#> 475     g     S
#> 478     j     S
#> 479     k     S
#> 483     o     S
#> 486     r     S
#> 487     s     S
#> 488     t     S
#> 489     u     S
#> 490     v     S
#> 495     a     T
#> 497     c     T
#> 499     e     T
#> 500     f     T
#> 510     p     T
#> 511     q     T
#> 512     r     T
#> 513     s     T
#> 514     t     T
#> 516     v     T
#> 518     x     T
#> 522     b     U
#> 523     c     U
#> 527     g     U
#> 528     h     U
#> 531     k     U
#> 532     l     U
#> 534     n     U
#> 535     o     U
#> 538     r     U
#> 539     s     U
#> 540     t     U
#> 543     w     U
#> 545     y     U
#> 548     b     V
#> 549     c     V
#> 550     d     V
#> 551     e     V
#> 553     g     V
#> 554     h     V
#> 555     i     V
#> 556     j     V
#> 557     k     V
#> 558     l     V
#> 559     m     V
#> 563     q     V
#> 566     t     V
#> 568     v     V
#> 576     d     W
#> 581     i     W
#> 583     k     W
#> 585     m     W
#> 587     o     W
#> 588     p     W
#> 589     q     W
#> 591     s     W
#> 593     u     W
#> 594     v     W
#> 595     w     W
#> 598     z     W
#> 601     c     X
#> 602     d     X
#> 606     h     X
#> 607     i     X
#> 608     j     X
#> 610     l     X
#> 611     m     X
#> 615     q     X
#> 616     r     X
#> 617     s     X
#> 620     v     X
#> 623     y     X
#> 626     b     Y
#> 629     e     Y
#> 630     f     Y
#> 631     g     Y
#> 633     i     Y
#> 637     m     Y
#> 638     n     Y
#> 639     o     Y
#> 642     r     Y
#> 643     s     Y
#> 644     t     Y
#> 645     u     Y
#> 648     x     Y
#> 649     y     Y
#> 650     z     Y
#> 651     a     Z
#> 652     b     Z
#> 654     d     Z
#> 655     e     Z
#> 656     f     Z
#> 657     g     Z
#> 658     h     Z
#> 659     i     Z
#> 660     j     Z
#> 662     l     Z
#> 663     m     Z
#> 665     o     Z
#> 666     p     Z
#> 667     q     Z
#> 670     t     Z
#> 671     u     Z
#> 673     w     Z
#> 675     y     Z

# Make a random MultiFactor with the trading goods from the vignettes
trade_posts()
#> A MultiFactor::MultiFactor list S7_object,
#>     5 feature types across 5 LinkMaps.
#> 
#>                    fruit furniture quartz utensils marbles
#> fruit2furniture        6         5      .        .       .
#> fruit2quartz           5         .      4        .       .
#> fruit2utensils         6         .      .        4       .
#> furniture2utensils     .         5      .        5       .
#> quartz2marbles         .         .      5        .       4
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> fruit     : 6 Levels: apple ... blueberry 
#> furniture : 6 Levels: chair ... chest 
#> quartz    : 6 Levels: amethyst ... agate 
#> utensils  : 6 Levels: spatula ... cup 
#> marbles   : 6 Levels: red marble ... spotted marble 
```
