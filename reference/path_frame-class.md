# path_frame S7 class

`path_frame` is an S7 class to standardize the various ways in which
paths that can be specified across the `MultiFactor` package. This class
is mostly for internal use.

## Usage

``` r
path_frame(x)
```

## Arguments

- x:

  `data.frame` with the first two columns named `"from"` and `"to"`.
  Optionally, additional columns (see Details)

## Value

a `path_frame` object.

## Details

Rows represent edges in a path. Additional (optional) columns contain
information about the edges:

- `components` `integer`. Indicates subpath ID.

- `stack` `logical`. Whether the vertex contains merged data types.

- `coverage` `numeric`. The proportional coverage threshold (or 0).

## Examples

``` r
path_frame
#> <MultiFactor::path_frame> class
#> @ parent     : S3<data.frame>
#> @ constructor: function(x) {...}
#> @ validator  : function(self) {...}
#> @ properties :
```
