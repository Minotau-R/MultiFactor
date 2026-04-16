# Read Relational Data Values

Read relational data from a file in adjacency list format and parse it
into a `LinkMap` (or a `LinkMap`-shaped `data.frame`). Relies on
[`base::scan`](https://rdrr.io/r/base/scan.html) and
[`utils::count.fields`](https://rdrr.io/r/utils/count.fields.html) under
the hood.

## Usage

``` r
read_adjacency_list(
  file,
  sep = "\t",
  quote = "'\"",
  col.names = c("id.x", "id.y"),
  as.df = FALSE,
  ...
)
```

## Arguments

- file:

  the name of a file to read data values from. If the specified file is
  `""`, then input is taken from the keyboard (or whatever
  [`stdin()`](https://rdrr.io/r/base/showConnections.html) reads if
  input is redirected or R is embedded). (In this case input can be
  terminated by a blank line or an signal, `Ctrl-D` on Unix and `Ctrl-Z`
  on Windows.)

  Otherwise, the file name is interpreted *relative* to the current
  working directory (given by
  [`getwd()`](https://rdrr.io/r/base/getwd.html)), unless it specifies
  an *absolute* path. Tilde-expansion is performed where supported. When
  running R from a script, `file = "stdin"` can be used to refer to the
  process's `stdin` file stream.

  This can be a compressed file (see
  [`file`](https://rdrr.io/r/base/connections.html)).

  Alternatively, `file` can be a
  [`connection`](https://rdrr.io/r/base/connections.html), which will be
  opened if necessary, and if so closed at the end of the function call.
  Whatever mode the connection is opened in, any of , or will be
  accepted as the marker for a line and so will match `sep = "\n"`.

  `file` can also be a complete URL. (For the supported URL schemes, see
  the ‘URLs’ section of the help for
  [`url`](https://rdrr.io/r/base/connections.html).)

  To read a data file not in the current encoding (for example a Latin-1
  file in a UTF-8 locale or conversely) use a
  [`file`](https://rdrr.io/r/base/connections.html) connection setting
  its `encoding` argument (or `scan`'s `fileEncoding` argument).

- sep:

  the field separator character. Values on each line of the file are
  separated by this character. (Default: `"\t"`)

- quote:

  the set of quoting characters as a single character string or `NULL`.
  In a multibyte locale the quoting characters must be ASCII
  (single-byte).

- col.names:

  `Character vector` of length 2, specifying the colnames of the output.
  (Default: `c("id.x", "id.y")`)

- as.df:

  `Boolean` Whether to return an unmodified `data.frame` or a `LinkMap`
  (Default).

- ...:

  Additional arguments, passed to `scan`.

## Value

A `LinkMap`, or `if( as.df )`, a two-column data.frame formatted like an
edge list, appropriate input for
[`LinkMap()`](https://minotau-r.github.io/MultiFactor/reference/LinkMap-class.md).

## Details

Note that the other common representation of relational data, a
two-column table, known as an edge list, can be read in using regular
approaches (e.g., `?base::read.table`).

## See also

[`utils::count.fields()`](https://rdrr.io/r/utils/count.fields.html)
[`base::scan()`](https://rdrr.io/r/base/scan.html)

## Examples

``` r
# read_adjacency_list(
#     "https://ftp.microbio.me/pub/wol2/function/kegg/ko-to-ec.map"
# )
```
