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
#>     a b  c  d  e  f
#> a2b 9 9  .  .  .  .
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
#>       lower UPPER
#> 1         a     A
#> 3         c     A
#> 4         d     A
#> 6         f     A
#> 9         i     A
#> 12        l     A
#> 14        n     A
#> 15        o     A
#> 16        p     A
#> 17        q     A
#> 18        r     A
#> 19        s     A
#> 20        t     A
#> 21        u     A
#> 22        v     A
#> 23        w     A
#> 25        y     A
#> 1.1       a     B
#> 2         b     B
#> 3.1       c     B
#> 6.1       f     B
#> 7         g     B
#> 8         h     B
#> 9.1       i     B
#> 11        k     B
#> 13        m     B
#> 14.1      n     B
#> 15.1      o     B
#> 16.1      p     B
#> 18.1      r     B
#> 19.1      s     B
#> 21.1      u     B
#> 23.1      w     B
#> 25.1      y     B
#> 26        z     B
#> 3.2       c     C
#> 4.1       d     C
#> 7.1       g     C
#> 12.1      l     C
#> 13.1      m     C
#> 16.2      p     C
#> 19.2      s     C
#> 20.1      t     C
#> 21.2      u     C
#> 23.2      w     C
#> 24        x     C
#> 26.1      z     C
#> 2.1       b     D
#> 3.3       c     D
#> 9.2       i     D
#> 10        j     D
#> 11.1      k     D
#> 14.2      n     D
#> 15.2      o     D
#> 18.2      r     D
#> 19.3      s     D
#> 20.2      t     D
#> 21.3      u     D
#> 22.1      v     D
#> 23.3      w     D
#> 2.2       b     E
#> 5         e     E
#> 6.2       f     E
#> 8.1       h     E
#> 11.2      k     E
#> 15.3      o     E
#> 22.2      v     E
#> 23.4      w     E
#> 25.2      y     E
#> 2.3       b     F
#> 5.1       e     F
#> 10.1      j     F
#> 13.2      m     F
#> 17.1      q     F
#> 18.3      r     F
#> 19.4      s     F
#> 20.3      t     F
#> 21.4      u     F
#> 23.5      w     F
#> 25.3      y     F
#> 1.2       a     G
#> 3.4       c     G
#> 7.2       g     G
#> 9.3       i     G
#> 11.3      k     G
#> 14.3      n     G
#> 16.3      p     G
#> 17.2      q     G
#> 20.4      t     G
#> 21.5      u     G
#> 25.4      y     G
#> 1.3       a     H
#> 2.4       b     H
#> 7.3       g     H
#> 8.2       h     H
#> 9.4       i     H
#> 11.4      k     H
#> 15.4      o     H
#> 17.3      q     H
#> 18.4      r     H
#> 23.6      w     H
#> 25.5      y     H
#> 1.4       a     I
#> 5.2       e     I
#> 6.3       f     I
#> 8.3       h     I
#> 9.5       i     I
#> 13.3      m     I
#> 14.4      n     I
#> 15.5      o     I
#> 19.5      s     I
#> 20.5      t     I
#> 26.2      z     I
#> 3.5       c     J
#> 4.2       d     J
#> 5.3       e     J
#> 6.4       f     J
#> 7.4       g     J
#> 17.4      q     J
#> 18.5      r     J
#> 20.6      t     J
#> 21.6      u     J
#> 22.3      v     J
#> 23.7      w     J
#> 25.6      y     J
#> 26.3      z     J
#> 2.5       b     K
#> 3.6       c     K
#> 5.4       e     K
#> 7.5       g     K
#> 8.4       h     K
#> 13.4      m     K
#> 18.6      r     K
#> 19.6      s     K
#> 20.7      t     K
#> 21.7      u     K
#> 22.4      v     K
#> 23.8      w     K
#> 3.7       c     L
#> 4.3       d     L
#> 6.5       f     L
#> 7.6       g     L
#> 9.6       i     L
#> 11.5      k     L
#> 12.2      l     L
#> 14.5      n     L
#> 18.7      r     L
#> 20.8      t     L
#> 22.5      v     L
#> 25.7      y     L
#> 3.8       c     M
#> 6.6       f     M
#> 7.7       g     M
#> 9.7       i     M
#> 10.2      j     M
#> 14.6      n     M
#> 15.6      o     M
#> 16.4      p     M
#> 18.8      r     M
#> 19.7      s     M
#> 21.8      u     M
#> 22.6      v     M
#> 24.1      x     M
#> 25.8      y     M
#> 26.4      z     M
#> 2.6       b     N
#> 3.9       c     N
#> 4.4       d     N
#> 5.5       e     N
#> 6.7       f     N
#> 7.8       g     N
#> 9.8       i     N
#> 13.5      m     N
#> 16.5      p     N
#> 17.5      q     N
#> 18.9      r     N
#> 20.9      t     N
#> 23.9      w     N
#> 24.2      x     N
#> 25.9      y     N
#> 26.5      z     N
#> 2.7       b     O
#> 3.10      c     O
#> 4.5       d     O
#> 5.6       e     O
#> 13.6      m     O
#> 15.7      o     O
#> 18.10     r     O
#> 19.8      s     O
#> 20.10     t     O
#> 22.7      v     O
#> 25.10     y     O
#> 26.6      z     O
#> 3.11      c     P
#> 4.6       d     P
#> 5.7       e     P
#> 6.8       f     P
#> 9.9       i     P
#> 12.3      l     P
#> 14.7      n     P
#> 16.6      p     P
#> 17.6      q     P
#> 19.9      s     P
#> 21.9      u     P
#> 22.8      v     P
#> 25.11     y     P
#> 26.7      z     P
#> 1.5       a     Q
#> 5.8       e     Q
#> 6.9       f     Q
#> 8.5       h     Q
#> 9.10      i     Q
#> 10.3      j     Q
#> 11.6      k     Q
#> 13.7      m     Q
#> 14.8      n     Q
#> 15.8      o     Q
#> 20.11     t     Q
#> 21.10     u     Q
#> 24.3      x     Q
#> 25.12     y     Q
#> 26.8      z     Q
#> 1.6       a     R
#> 3.12      c     R
#> 4.7       d     R
#> 9.11      i     R
#> 11.7      k     R
#> 12.4      l     R
#> 13.8      m     R
#> 15.9      o     R
#> 16.7      p     R
#> 17.7      q     R
#> 18.11     r     R
#> 22.9      v     R
#> 23.10     w     R
#> 26.9      z     R
#> 3.13      c     S
#> 8.6       h     S
#> 9.12      i     S
#> 12.5      l     S
#> 13.9      m     S
#> 14.9      n     S
#> 15.10     o     S
#> 19.10     s     S
#> 20.12     t     S
#> 22.10     v     S
#> 23.11     w     S
#> 25.13     y     S
#> 2.8       b     T
#> 4.8       d     T
#> 6.10      f     T
#> 7.9       g     T
#> 8.7       h     T
#> 10.4      j     T
#> 12.6      l     T
#> 15.11     o     T
#> 16.8      p     T
#> 19.11     s     T
#> 22.11     v     T
#> 23.12     w     T
#> 26.10     z     T
#> 1.7       a     U
#> 2.9       b     U
#> 3.14      c     U
#> 4.9       d     U
#> 5.9       e     U
#> 8.8       h     U
#> 10.5      j     U
#> 11.8      k     U
#> 13.10     m     U
#> 14.10     n     U
#> 16.9      p     U
#> 19.12     s     U
#> 21.11     u     U
#> 25.14     y     U
#> 26.11     z     U
#> 4.10      d     V
#> 5.10      e     V
#> 7.10      g     V
#> 11.9      k     V
#> 14.11     n     V
#> 15.12     o     V
#> 16.10     p     V
#> 18.12     r     V
#> 21.12     u     V
#> 22.12     v     V
#> 23.13     w     V
#> 2.10      b     W
#> 3.15      c     W
#> 4.11      d     W
#> 5.11      e     W
#> 8.9       h     W
#> 9.13      i     W
#> 16.11     p     W
#> 17.8      q     W
#> 18.13     r     W
#> 19.13     s     W
#> 22.13     v     W
#> 24.4      x     W
#> 1.8       a     X
#> 4.12      d     X
#> 5.12      e     X
#> 6.11      f     X
#> 9.14      i     X
#> 11.10     k     X
#> 13.11     m     X
#> 15.13     o     X
#> 20.13     t     X
#> 25.15     y     X
#> 2.11      b     Y
#> 3.16      c     Y
#> 4.13      d     Y
#> 5.13      e     Y
#> 7.11      g     Y
#> 9.15      i     Y
#> 10.6      j     Y
#> 16.12     p     Y
#> 19.14     s     Y
#> 21.13     u     Y
#> 22.14     v     Y
#> 25.16     y     Y
#> 1.9       a     Z
#> 3.17      c     Z
#> 5.14      e     Z
#> 9.16      i     Z
#> 10.7      j     Z
#> 11.11     k     Z
#> 12.7      l     Z
#> 13.12     m     Z
#> 14.12     n     Z
#> 15.14     o     Z
#> 16.13     p     Z
#> 17.9      q     Z
#> 19.15     s     Z
#> 20.14     t     Z
#> 22.15     v     Z
#> 25.17     y     Z
#> 26.12     z     Z

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
```
