# Generate a random MultiFactor or LinkMap

Randomly generate a valid `MultiFactor` or `LinkMap` object.
`randomMultiFactor` can optionally take am `igraph` object to determine
its layout. (See examples) `trade_posts()` generates a random
`MultiFactor` in the style of the trading example from the vignette.

called by `randomMultiFactor`, shouldn't be called by user.

## Usage

``` r
randomMultiFactor(layout = NULL, n_features = 10, sparseness = 0.75)

trade_posts(raw.data = FALSE)

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

- raw.data:

  `Boolean`, Whether to return the `data.frame` of goods rather than the
  default `MultiFactor`.

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
#> a :  9 Levels: a_001 a_002 ... a_010 
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
#>       X1 X3 X2 X4 X5 X6
#> X12X3 10  9  .  .  .  .
#> X22X4  .  . 10 10  .  .
#> X12X4 10  .  . 10  .  .
#> X32X4  .  9  . 10  .  .
#> X22X5  .  . 10  . 10  .
#> X12X5 10  .  .  . 10  .
#> X32X5  .  9  .  . 10  .
#> X42X5  .  .  . 10 10  .
#> X22X6  .  .  9  .  . 10
#> X12X6  9  .  .  .  .  9
#> X32X6  . 10  .  .  .  9
#> X42X6  .  .  .  9  . 10
#> X52X6  .  .  .  . 10  9
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> X1 : 10 Levels: 1_001 1_002 ... 1_010 
#> X3 : 10 Levels: 3_001 3_002 ... 3_007 
#> X2 : 10 Levels: 2_001 2_002 ... 2_010 
#> X4 : 10 Levels: 4_001 4_002 ... 4_010 
#> X5 : 10 Levels: 5_001 5_002 ... 5_010 
#> X6 : 10 Levels: 6_001 6_002 ... 6_010 

# Make a random LinkMap object
randomLinkMap()
#>       lower UPPER
#> 1         a     A
#> 3         c     A
#> 4         d     A
#> 5         e     A
#> 6         f     A
#> 9         i     A
#> 12        l     A
#> 14        n     A
#> 16        p     A
#> 17        q     A
#> 18        r     A
#> 19        s     A
#> 20        t     A
#> 22        v     A
#> 23        w     A
#> 1.1       a     B
#> 6.1       f     B
#> 7         g     B
#> 8         h     B
#> 9.1       i     B
#> 12.1      l     B
#> 13        m     B
#> 14.1      n     B
#> 15        o     B
#> 16.1      p     B
#> 18.1      r     B
#> 19.1      s     B
#> 21        u     B
#> 22.1      v     B
#> 23.1      w     B
#> 25        y     B
#> 26        z     B
#> 8.1       h     C
#> 12.2      l     C
#> 13.1      m     C
#> 16.2      p     C
#> 19.2      s     C
#> 21.1      u     C
#> 22.2      v     C
#> 23.2      w     C
#> 24        x     C
#> 26.1      z     C
#> 2         b     D
#> 3.1       c     D
#> 11        k     D
#> 14.2      n     D
#> 15.1      o     D
#> 18.2      r     D
#> 19.3      s     D
#> 20.1      t     D
#> 22.3      v     D
#> 23.3      w     D
#> 24.1      x     D
#> 2.1       b     E
#> 5.1       e     E
#> 6.2       f     E
#> 8.2       h     E
#> 9.2       i     E
#> 19.4      s     E
#> 22.4      v     E
#> 23.4      w     E
#> 25.1      y     E
#> 2.2       b     F
#> 4.1       d     F
#> 5.2       e     F
#> 8.3       h     F
#> 13.2      m     F
#> 18.3      r     F
#> 19.5      s     F
#> 20.2      t     F
#> 21.2      u     F
#> 23.5      w     F
#> 1.2       a     G
#> 2.3       b     G
#> 3.2       c     G
#> 7.1       g     G
#> 9.3       i     G
#> 11.1      k     G
#> 12.3      l     G
#> 16.3      p     G
#> 17.1      q     G
#> 20.3      t     G
#> 21.3      u     G
#> 22.5      v     G
#> 25.2      y     G
#> 1.3       a     H
#> 2.4       b     H
#> 6.3       f     H
#> 7.2       g     H
#> 8.4       h     H
#> 11.2      k     H
#> 14.3      n     H
#> 15.2      o     H
#> 16.4      p     H
#> 17.2      q     H
#> 18.4      r     H
#> 26.2      z     H
#> 1.4       a     I
#> 4.2       d     I
#> 5.3       e     I
#> 10        j     I
#> 13.3      m     I
#> 14.4      n     I
#> 15.3      o     I
#> 19.6      s     I
#> 20.4      t     I
#> 25.3      y     I
#> 2.5       b     J
#> 4.3       d     J
#> 6.4       f     J
#> 7.3       g     J
#> 10.1      j     J
#> 14.5      n     J
#> 16.5      p     J
#> 17.3      q     J
#> 18.5      r     J
#> 20.5      t     J
#> 21.4      u     J
#> 23.6      w     J
#> 26.3      z     J
#> 5.4       e     K
#> 7.4       g     K
#> 8.5       h     K
#> 13.4      m     K
#> 18.6      r     K
#> 19.7      s     K
#> 21.5      u     K
#> 22.6      v     K
#> 3.3       c     L
#> 4.4       d     L
#> 6.5       f     L
#> 7.5       g     L
#> 11.3      k     L
#> 12.4      l     L
#> 13.5      m     L
#> 14.6      n     L
#> 15.4      o     L
#> 16.6      p     L
#> 18.7      r     L
#> 22.7      v     L
#> 23.7      w     L
#> 25.4      y     L
#> 26.4      z     L
#> 1.5       a     M
#> 6.6       f     M
#> 7.6       g     M
#> 9.4       i     M
#> 10.2      j     M
#> 12.5      l     M
#> 14.7      n     M
#> 15.5      o     M
#> 16.7      p     M
#> 18.8      r     M
#> 19.8      s     M
#> 21.6      u     M
#> 22.8      v     M
#> 24.2      x     M
#> 25.5      y     M
#> 2.6       b     N
#> 3.4       c     N
#> 4.5       d     N
#> 5.5       e     N
#> 6.7       f     N
#> 7.7       g     N
#> 15.6      o     N
#> 16.8      p     N
#> 17.4      q     N
#> 18.9      r     N
#> 20.6      t     N
#> 22.9      v     N
#> 24.3      x     N
#> 26.5      z     N
#> 2.7       b     O
#> 3.5       c     O
#> 4.6       d     O
#> 5.6       e     O
#> 8.6       h     O
#> 14.8      n     O
#> 15.7      o     O
#> 17.5      q     O
#> 18.10     r     O
#> 20.7      t     O
#> 21.7      u     O
#> 22.10     v     O
#> 25.6      y     O
#> 1.6       a     P
#> 3.6       c     P
#> 4.7       d     P
#> 5.7       e     P
#> 9.5       i     P
#> 11.4      k     P
#> 12.6      l     P
#> 14.9      n     P
#> 16.9      p     P
#> 19.9      s     P
#> 21.8      u     P
#> 22.11     v     P
#> 1.7       a     Q
#> 2.8       b     Q
#> 5.8       e     Q
#> 6.8       f     Q
#> 8.7       h     Q
#> 9.6       i     Q
#> 10.3      j     Q
#> 11.5      k     Q
#> 12.7      l     Q
#> 15.8      o     Q
#> 17.6      q     Q
#> 20.8      t     Q
#> 21.9      u     Q
#> 22.12     v     Q
#> 23.8      w     Q
#> 25.7      y     Q
#> 26.6      z     Q
#> 1.8       a     R
#> 3.7       c     R
#> 4.8       d     R
#> 7.8       g     R
#> 8.8       h     R
#> 9.7       i     R
#> 10.4      j     R
#> 11.6      k     R
#> 12.8      l     R
#> 13.6      m     R
#> 15.9      o     R
#> 16.10     p     R
#> 17.7      q     R
#> 18.11     r     R
#> 20.9      t     R
#> 21.10     u     R
#> 22.13     v     R
#> 23.9      w     R
#> 25.8      y     R
#> 3.8       c     S
#> 5.9       e     S
#> 8.9       h     S
#> 9.8       i     S
#> 10.5      j     S
#> 11.7      k     S
#> 14.10     n     S
#> 15.10     o     S
#> 16.11     p     S
#> 17.8      q     S
#> 19.10     s     S
#> 20.10     t     S
#> 23.10     w     S
#> 25.9      y     S
#> 1.9       a     T
#> 2.9       b     T
#> 3.9       c     T
#> 4.9       d     T
#> 6.9       f     T
#> 7.9       g     T
#> 8.10      h     T
#> 9.9       i     T
#> 10.6      j     T
#> 11.8      k     T
#> 12.9      l     T
#> 13.7      m     T
#> 16.12     p     T
#> 18.12     r     T
#> 19.11     s     T
#> 21.11     u     T
#> 24.4      x     T
#> 26.7      z     T
#> 1.10      a     U
#> 3.10      c     U
#> 4.10      d     U
#> 5.10      e     U
#> 9.10      i     U
#> 10.7      j     U
#> 18.13     r     U
#> 21.12     u     U
#> 22.14     v     U
#> 23.11     w     U
#> 24.5      x     U
#> 2.10      b     V
#> 4.11      d     V
#> 9.11      i     V
#> 10.8      j     V
#> 11.9      k     V
#> 13.8      m     V
#> 15.11     o     V
#> 16.13     p     V
#> 17.9      q     V
#> 18.14     r     V
#> 19.12     s     V
#> 20.11     t     V
#> 21.13     u     V
#> 22.15     v     V
#> 23.12     w     V
#> 26.8      z     V
#> 1.11      a     W
#> 2.11      b     W
#> 3.11      c     W
#> 4.12      d     W
#> 6.10      f     W
#> 7.10      g     W
#> 8.11      h     W
#> 10.9      j     W
#> 11.10     k     W
#> 12.10     l     W
#> 13.9      m     W
#> 14.11     n     W
#> 17.10     q     W
#> 24.6      x     W
#> 25.10     y     W
#> 26.9      z     W
#> 1.12      a     X
#> 3.12      c     X
#> 4.13      d     X
#> 5.11      e     X
#> 6.11      f     X
#> 10.10     j     X
#> 16.14     p     X
#> 20.12     t     X
#> 21.14     u     X
#> 23.13     w     X
#> 24.7      x     X
#> 3.13      c     Y
#> 5.12      e     Y
#> 6.12      f     Y
#> 10.11     j     Y
#> 13.10     m     Y
#> 15.12     o     Y
#> 18.15     r     Y
#> 1.13      a     Z
#> 6.13      f     Z
#> 8.12      h     Z
#> 9.12      i     Z
#> 10.12     j     Z
#> 12.11     l     Z
#> 15.13     o     Z
#> 17.11     q     Z
#> 18.16     r     Z
#> 19.13     s     Z
#> 25.11     y     Z
#> 26.10     z     Z

# Make a random MultiFactor with the trading goods from the vignettes
trade_posts()
#> A MultiFactor::MultiFactor list S7_object,
#>     6 feature types across 6 LinkMaps.
#> 
#>                       clothing fruit books furniture instruments marbles
#> clothing2fruit               5     4     .         .           .       .
#> books2furniture              .     .     5         4           .       .
#> fruit2furniture              .     5     .         5           .       .
#> books2instruments            .     .     5         .           4       .
#> furniture2instruments        .     .     .         4           6       .
#> books2marbles                .     .     6         .           .       6
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> clothing    : 5 Levels: dress ... socks 
#> fruit       : 6 Levels: cherries ... grapes 
#> books       : 6 Levels: fancy book ... blue book 
#> furniture   : 6 Levels: bed ... wastebin 
#> instruments : 6 Levels: drum ... saxophone 
#> marbles     : 6 Levels: 8 marble ... white marble 
```
