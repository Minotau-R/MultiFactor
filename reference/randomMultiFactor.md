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
#>     lower UPPER
#> 1       a     A
#> 2       c     A
#> 3       d     A
#> 4       f     A
#> 5       i     A
#> 6       l     A
#> 7       n     A
#> 8       o     A
#> 9       p     A
#> 10      q     A
#> 11      r     A
#> 12      s     A
#> 13      t     A
#> 14      u     A
#> 15      v     A
#> 16      w     A
#> 17      y     A
#> 18      a     B
#> 19      b     B
#> 20      c     B
#> 21      f     B
#> 22      g     B
#> 23      h     B
#> 24      i     B
#> 25      k     B
#> 26      m     B
#> 27      n     B
#> 28      o     B
#> 29      p     B
#> 30      r     B
#> 31      s     B
#> 32      u     B
#> 33      w     B
#> 34      y     B
#> 35      z     B
#> 36      c     C
#> 37      d     C
#> 38      g     C
#> 39      l     C
#> 40      m     C
#> 41      p     C
#> 42      s     C
#> 43      t     C
#> 44      u     C
#> 45      w     C
#> 46      x     C
#> 47      z     C
#> 48      b     D
#> 49      c     D
#> 50      i     D
#> 51      j     D
#> 52      k     D
#> 53      n     D
#> 54      o     D
#> 55      r     D
#> 56      s     D
#> 57      t     D
#> 58      u     D
#> 59      v     D
#> 60      w     D
#> 61      b     E
#> 62      e     E
#> 63      f     E
#> 64      h     E
#> 65      k     E
#> 66      o     E
#> 67      v     E
#> 68      w     E
#> 69      y     E
#> 70      b     F
#> 71      e     F
#> 72      j     F
#> 73      m     F
#> 74      q     F
#> 75      r     F
#> 76      s     F
#> 77      t     F
#> 78      u     F
#> 79      w     F
#> 80      y     F
#> 81      a     G
#> 82      c     G
#> 83      g     G
#> 84      i     G
#> 85      k     G
#> 86      n     G
#> 87      p     G
#> 88      q     G
#> 89      t     G
#> 90      u     G
#> 91      y     G
#> 92      a     H
#> 93      b     H
#> 94      g     H
#> 95      h     H
#> 96      i     H
#> 97      k     H
#> 98      o     H
#> 99      q     H
#> 100     r     H
#> 101     w     H
#> 102     y     H
#> 103     a     I
#> 104     e     I
#> 105     f     I
#> 106     h     I
#> 107     i     I
#> 108     m     I
#> 109     n     I
#> 110     o     I
#> 111     s     I
#> 112     t     I
#> 113     z     I
#> 114     c     J
#> 115     d     J
#> 116     e     J
#> 117     f     J
#> 118     g     J
#> 119     q     J
#> 120     r     J
#> 121     t     J
#> 122     u     J
#> 123     v     J
#> 124     w     J
#> 125     y     J
#> 126     z     J
#> 127     b     K
#> 128     c     K
#> 129     e     K
#> 130     g     K
#> 131     h     K
#> 132     m     K
#> 133     r     K
#> 134     s     K
#> 135     t     K
#> 136     u     K
#> 137     v     K
#> 138     w     K
#> 139     c     L
#> 140     d     L
#> 141     f     L
#> 142     g     L
#> 143     i     L
#> 144     k     L
#> 145     l     L
#> 146     n     L
#> 147     r     L
#> 148     t     L
#> 149     v     L
#> 150     y     L
#> 151     c     M
#> 152     f     M
#> 153     g     M
#> 154     i     M
#> 155     j     M
#> 156     n     M
#> 157     o     M
#> 158     p     M
#> 159     r     M
#> 160     s     M
#> 161     u     M
#> 162     v     M
#> 163     x     M
#> 164     y     M
#> 165     z     M
#> 166     b     N
#> 167     c     N
#> 168     d     N
#> 169     e     N
#> 170     f     N
#> 171     g     N
#> 172     i     N
#> 173     m     N
#> 174     p     N
#> 175     q     N
#> 176     r     N
#> 177     t     N
#> 178     w     N
#> 179     x     N
#> 180     y     N
#> 181     z     N
#> 182     b     O
#> 183     c     O
#> 184     d     O
#> 185     e     O
#> 186     m     O
#> 187     o     O
#> 188     r     O
#> 189     s     O
#> 190     t     O
#> 191     v     O
#> 192     y     O
#> 193     z     O
#> 194     c     P
#> 195     d     P
#> 196     e     P
#> 197     f     P
#> 198     i     P
#> 199     l     P
#> 200     n     P
#> 201     p     P
#> 202     q     P
#> 203     s     P
#> 204     u     P
#> 205     v     P
#> 206     y     P
#> 207     z     P
#> 208     a     Q
#> 209     e     Q
#> 210     f     Q
#> 211     h     Q
#> 212     i     Q
#> 213     j     Q
#> 214     k     Q
#> 215     m     Q
#> 216     n     Q
#> 217     o     Q
#> 218     t     Q
#> 219     u     Q
#> 220     x     Q
#> 221     y     Q
#> 222     z     Q
#> 223     a     R
#> 224     c     R
#> 225     d     R
#> 226     i     R
#> 227     k     R
#> 228     l     R
#> 229     m     R
#> 230     o     R
#> 231     p     R
#> 232     q     R
#> 233     r     R
#> 234     v     R
#> 235     w     R
#> 236     z     R
#> 237     c     S
#> 238     h     S
#> 239     i     S
#> 240     l     S
#> 241     m     S
#> 242     n     S
#> 243     o     S
#> 244     s     S
#> 245     t     S
#> 246     v     S
#> 247     w     S
#> 248     y     S
#> 249     b     T
#> 250     d     T
#> 251     f     T
#> 252     g     T
#> 253     h     T
#> 254     j     T
#> 255     l     T
#> 256     o     T
#> 257     p     T
#> 258     s     T
#> 259     v     T
#> 260     w     T
#> 261     z     T
#> 262     a     U
#> 263     b     U
#> 264     c     U
#> 265     d     U
#> 266     e     U
#> 267     h     U
#> 268     j     U
#> 269     k     U
#> 270     m     U
#> 271     n     U
#> 272     p     U
#> 273     s     U
#> 274     u     U
#> 275     y     U
#> 276     z     U
#> 277     d     V
#> 278     e     V
#> 279     g     V
#> 280     k     V
#> 281     n     V
#> 282     o     V
#> 283     p     V
#> 284     r     V
#> 285     u     V
#> 286     v     V
#> 287     w     V
#> 288     b     W
#> 289     c     W
#> 290     d     W
#> 291     e     W
#> 292     h     W
#> 293     i     W
#> 294     p     W
#> 295     q     W
#> 296     r     W
#> 297     s     W
#> 298     v     W
#> 299     x     W
#> 300     a     X
#> 301     d     X
#> 302     e     X
#> 303     f     X
#> 304     i     X
#> 305     k     X
#> 306     m     X
#> 307     o     X
#> 308     t     X
#> 309     y     X
#> 310     b     Y
#> 311     c     Y
#> 312     d     Y
#> 313     e     Y
#> 314     g     Y
#> 315     i     Y
#> 316     j     Y
#> 317     p     Y
#> 318     s     Y
#> 319     u     Y
#> 320     v     Y
#> 321     y     Y
#> 322     a     Z
#> 323     c     Z
#> 324     e     Z
#> 325     i     Z
#> 326     j     Z
#> 327     k     Z
#> 328     l     Z
#> 329     m     Z
#> 330     n     Z
#> 331     o     Z
#> 332     p     Z
#> 333     q     Z
#> 334     s     Z
#> 335     t     Z
#> 336     v     Z
#> 337     y     Z
#> 338     z     Z

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
