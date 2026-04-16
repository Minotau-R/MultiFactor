# MultiFactor

## Overview

MultiFactor aims to provide a consistent toolkit to incorporate
relational data into data analytical tools and methods. In practice, we
expect MultiFactor to be used in combination with additional packages
that extend it. For instance, see
[ariadne](https://github.com/minotau-R/ariadne) and
[anansi](https://github.com/thomazbastiaanssen/anansi), two such
packages that make use of MultiFactor to link and convert across
biological database IDs and perform muti-omics integration analysis,
respectively.

## Get started using MultiFactor

### Installation instructions

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install the released version of
`MultiFactor`:

``` r

install.packages("MultiFactor")
```

Or install the development version from this repository:

``` r

install.packages("remotes")
remotes::install_github("minotau-R/MultiFactor")
```

### Setup

``` r

library(MultiFactor)
#> 
#> Attaching package: 'MultiFactor'
#> The following object is masked from 'package:base':
#> 
#>     nlevels

# Load demo data
set.seed(010292)
tp <- trade_posts()
```

## MultiFactor and LinkMap objects

### LinkMap

The basic object in the `MultiFactor` package is the `LinkMap`, which
contains relational information across two types of features. This
format is sometimes referred to as an [edge
list](https://en.wikipedia.org/wiki/Edge_list). Under a thin layer of
S7, the `LinkMap` object is a `data.frame` where the first two columns
indicate which feature IDs that are considered linked. Optional
additional columns are considered metadata.

Let’s use an example data set to take a closer look at `LinkMap`. The
[`trade_posts()`](https://minotau-r.github.io/MultiFactor/reference/randomMultiFactor.md)
function generates data about fictional trade posts, where one type of
good is traded for another. In this particular case, types of furniture
are traded for types of utensils.

``` r

linkmap <- tp[[1]]
linkmap
#>    furniture utensils
#> 3       desk  spatula
#> 6      chest  spatula
#> 9       desk    whisk
#> 13     chair    sieve
#> 15      desk    sieve
#> 19     chair  blender
#> 20     table  blender
#> 33      desk      cup
#> 35    drawer      cup
```

The two types of goods are captured by the two columns, with column
names representing the *types* of good and rows representing which
specific *type-pairs* are traded at that trade post, or, more generally,
are linked in that `LinkMap`.

``` r

levels( linkmap )
#> $furniture
#> [1] "chair"  "table"  "desk"   "bed"    "drawer" "chest" 
#> 
#> $utensils
#> [1] "spatula" "whisk"   "sieve"   "blender" "knife"   "cup"
```

Notice that `LinkMap` is two `factor` columns in a trench coat. We can
inspect the levels as usual.

We can see that we have several of these types of trade posts in our
data set. However, we also notice that the column names - the types of
goods - can differ.

``` r

tp[[2]]
#>          quartz utensils
#> 9     carnelian    whisk
#> 12        agate    whisk
#> 15    carnelian    sieve
#> 24        agate  blender
#> 29         onyx    knife
#> 32      citrine      cup
#> 33    carnelian      cup
#> 34 rock crystal      cup
#> 36        agate      cup
tp[[3]]
#>        fruit        marbles
#> 3     cherry     red marble
#> 5      melon     red marble
#> 8       pear   green marble
#> 14      pear  purple marble
#> 17     melon  purple marble
#> 25     apple  yellow marble
#> 26      pear  yellow marble
#> 33    cherry spotted marble
#> 36 blueberry spotted marble
```

### MultiFactor

The `MultiFactor` is in essence a collection of `LinkMap`s. Where
`LinkMap`s contain relational information across two data types,
`MultiFactor`s are a representation of the relational graph formed by
combining those `LinkMaps`. The full object `tp`, which contains the
`LinkMaps` we just investigated, is in fact a `MultiFactor` object:

``` r

tp
#> A MultiFactor::MultiFactor list S7_object,
#>     5 feature types across 5 LinkMaps.
#> 
#>                    furniture utensils quartz fruit marbles
#> furniture2utensils         5        5      .     .       .
#> quartz2utensils            .        5      5     .       .
#> fruit2marbles              .        .      .     5       5
#> quartz2marbles             .        .      5     .       6
#> utensils2marbles           .        6      .     .       4
#> 
#> Values represent unique feature names in that LinkMap.
#> 
#> Levels:
#> furniture : 6 Levels: chair ... chest 
#> utensils  : 6 Levels: spatula ... cup 
#> quartz    : 6 Levels: amethyst ... agate 
#> fruit     : 6 Levels: apple ... blueberry 
#> marbles   : 6 Levels: red marble ... spotted marble
```

Notice that a `MultiFactor` summarizes information across the component
`LinkMaps` in several ways. First, The matrix shows the types of goods
as columns and the component `LinkMaps` that contain this information as
rows. The numbers in the matrix then show the number of unique types of
that type of good in that particular LinkMap - and that are therefore
linked to the second feature in the `LinkMap`.

For instance, in the top-left corner of the matrix, we can see that the
first `LinkMap` links furniture and utensils and is aptly named
`furniture2utensils`. Notice that five unique types of furniture as well
as five types of utensils are mentioned in `furniture2utensils`.

Though `MultiFactor` is a list of `LinkMap`s under the hood, we can also
interact with its matrix representation, as well as access the component
levels:

``` r

dim(tp)
#> [1] 5 5
dimnames(tp)
#> [[1]]
#> [1] "furniture2utensils" "quartz2utensils"    "fruit2marbles"     
#> [4] "quartz2marbles"     "utensils2marbles"  
#> 
#> [[2]]
#> [1] "furniture" "utensils"  "quartz"    "fruit"     "marbles"
levels(tp)
#> $furniture
#> [1] "chair"  "table"  "desk"   "bed"    "drawer" "chest" 
#> 
#> $utensils
#> [1] "spatula" "whisk"   "sieve"   "blender" "knife"   "cup"    
#> 
#> $quartz
#> [1] "amethyst"     "citrine"      "carnelian"    "rock crystal" "onyx"        
#> [6] "agate"       
#> 
#> $fruit
#> [1] "apple"     "pear"      "cherry"    "orange"    "melon"     "blueberry"
#> 
#> $marbles
#> [1] "red marble"     "green marble"   "purple marble"  "blue marble"   
#> [5] "yellow marble"  "spotted marble"
lengths(levels(tp))
#> furniture  utensils    quartz     fruit   marbles 
#>         6         6         6         6         6
```

Note that levels of the same type are automatically unified across all
component LinkMaps with that type of level.

## weave() a path

Going back to our trading post example, let’s say we’d want to get some
new chairs, but we only have fruit. While both fruit and furniture are
available in our data set, there aren’t any trade post that deals in
that particular pair of goods. However, we could imagine trading our
fruit for furniture in steps: We can trade our fruit for a different
good, which we trade for another one, until we reach a good that we can
trade for furniture. The
[`weave()`](https://minotau-r.github.io/MultiFactor/reference/weave-generic.md)
function does exactly this:

``` r

weave(tp, fruit ~ furniture)
#>       fruit furniture
#> 1    cherry     chair
#> 2     melon     chair
#> 3 blueberry     chair
#> 4    cherry     table
#> 5     melon     table
#> 6      pear      desk
#> 7    cherry      desk
#> 8     melon      desk
#> 9 blueberry      desk
```

We receive a new `LinkMap` containing all fruits that could be traded
for furniture.

### Selecting a path

We can use
[`select_shortest_paths()`](https://minotau-r.github.io/MultiFactor/reference/select_path.md)
to find the types of traded goods in order, or more generally, the paths
that were traversed. If several paths exist, all will be traversed and
included into one `LinkMap`.

``` r

select_shortest_paths(tp, fruit ~ furniture)
#> [[1]]
#> [1] "fruit"     "marbles"   "utensils"  "furniture"
```

## Compatibility with `igraph` and `Matrix`

`MultiFactor` relies heavily on the excellent
[`igraph`](https://r.igraph.org/) and
[`Matrix`](https://matrix.r-forge.r-project.org/) packages, particularly
for path finding and sparse matrix representation.

#### Convert `MultiFactor` main graph representation to `igraph` object

``` r

library(igraph)
#> 
#> Attaching package: 'igraph'
#> The following objects are masked from 'package:stats':
#> 
#>     decompose, spectrum
#> The following object is masked from 'package:base':
#> 
#>     union
# Convert to an igraph object
g <- as.igraph(tp)
g
#> IGRAPH a59c70b UN-- 5 5 -- 
#> + attr: name (v/c), name (e/c)
#> + edges from a59c70b (vertex names):
#> [1] furniture--utensils quartz   --utensils fruit    --marbles 
#> [4] quartz   --marbles  utensils --marbles
plot(g)
```

![](MultiFactor_files/figure-html/igraph-sp-1.png)

#### Convert `LinkMap` link information to sparse adjacency `Matrix`

``` r

# Convert to an igraph object
m <- as.matrix(linkmap, dimnames = levels(linkmap))
m
#> 6 x 6 sparse Matrix of class "ngCMatrix"
#>          utensils
#> furniture spatula whisk sieve blender knife cup
#>    chair        .     .     |       |     .   .
#>    table        .     .     .       |     .   .
#>    desk         |     |     |       .     .   |
#>    bed          .     .     .       .     .   .
#>    drawer       .     .     .       .     .   |
#>    chest        |     .     .       .     .   .
```

## Utilities

`MultiFactor` also provides some utility functions for data wrangling on
tables with features (rows) of the appropriate type.

``` r

furniture_table <- data.frame(replicate(10, rbinom(6, 10, 2/3)))
rownames(furniture_table) <- levels(tp)$furniture
```

### subgroup_apply

`subgroup_apply` allows us to run arbitrary code on subsets of a table,
based on groupings on the left hand of the formula:

``` r

subgroup_apply(
  X = furniture_table, LINK = tp, BY = fruit ~ furniture, FUN = force
  )
#> $pear
#>      X1 X2 X3 X4 X5 X6 X7 X8 X9 X10
#> desk  7  8  5  5  7  6  7 10  5   5
#> 
#> $cherry
#>       X1 X2 X3 X4 X5 X6 X7 X8 X9 X10
#> chair  7  8  6  6  6  8  7  7  6   8
#> table  7  5  7  6  7  9  7  8  8   5
#> desk   7  8  5  5  7  6  7 10  5   5
#> 
#> $melon
#>       X1 X2 X3 X4 X5 X6 X7 X8 X9 X10
#> chair  7  8  6  6  6  8  7  7  6   8
#> table  7  5  7  6  7  9  7  8  8   5
#> desk   7  8  5  5  7  6  7 10  5   5
#> 
#> $blueberry
#>       X1 X2 X3 X4 X5 X6 X7 X8 X9 X10
#> chair  7  8  6  6  6  8  7  7  6   8
#> desk   7  8  5  5  7  6  7 10  5   5
```

### tidy/subgroup_to_tbl

[`subgroup_to_tbl()`](https://minotau-r.github.io/MultiFactor/reference/subgroup_to_tbl.md)
returns a tidy wide-format table, ready to be grouped based on the first
two columns.

``` r

subgroup_to_tbl(furniture_table, tp, fruit ~ furniture)
#>       fruit furniture X1 X2 X3 X4 X5 X6 X7 X8 X9 X10
#> 1    cherry     chair  7  8  6  6  6  8  7  7  6   8
#> 2     melon     chair  7  8  6  6  6  8  7  7  6   8
#> 3 blueberry     chair  7  8  6  6  6  8  7  7  6   8
#> 4    cherry     table  7  5  7  6  7  9  7  8  8   5
#> 5     melon     table  7  5  7  6  7  9  7  8  8   5
#> 6      pear      desk  7  8  5  5  7  6  7 10  5   5
#> 7    cherry      desk  7  8  5  5  7  6  7 10  5   5
#> 8     melon      desk  7  8  5  5  7  6  7 10  5   5
#> 9 blueberry      desk  7  8  5  5  7  6  7 10  5   5
```

#### Session Info

``` r

sessionInfo()
#> R Under development (unstable) (2026-04-12 r89873)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.4 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
#>  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
#>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> time zone: UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] igraph_2.2.3      MultiFactor_0.1.2
#> 
#> loaded via a namespace (and not attached):
#>  [1] cli_3.6.6         knitr_1.51        rlang_1.2.0       xfun_0.57        
#>  [5] forcats_1.0.1     otel_0.2.0        textshaping_1.0.5 S7_0.2.1         
#>  [9] jsonlite_2.0.0    glue_1.8.0        htmltools_0.5.9   ragg_1.5.2       
#> [13] sass_0.4.10       rmarkdown_2.31    grid_4.7.0        evaluate_1.0.5   
#> [17] jquerylib_0.1.4   fastmap_1.2.0     yaml_2.3.12       lifecycle_1.0.5  
#> [21] compiler_4.7.0    fs_2.0.1          pkgconfig_2.0.3   htmlwidgets_1.6.4
#> [25] lattice_0.22-9    systemfonts_1.3.2 digest_0.6.39     R6_2.6.1         
#> [29] magrittr_2.0.5    bslib_0.10.0      Matrix_1.7-5      tools_4.7.0      
#> [33] pkgdown_2.2.0     cachem_1.1.0      desc_1.4.3
```
