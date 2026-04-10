#' Read Relational Data Values
#' @name read_adjacency_list
#' @description
#' Read relational data from a file in adjacency list format and parse it into a
#' `LinkMap` (or a `LinkMap`-shaped `data.frame`). Relies on `base::scan` and
#' `utils::count.fields` under the hood.
#' @inheritParams base::scan
#' @param sep the field separator character. Values on each line of the file
#'     are separated by this character. (Default: `"\t"`)
#' @param col.names `Character vector` of length 2, specifying the colnames of
#'     the output. (Default: `c("id.x", "id.y")`)
#' @param as.df `Boolean` Whether to return an unmodified `data.frame` or a
#'     `LinkMap` (Default).
#' the underlying `data.frame`.
#' @param ... Additional arguments, passed to `count.fields` and `scan`.
#' @seealso [utils::count.fields()] [base::scan()]
#' @returns A `LinkMap`, or `if( as.df )`, a two-column data.frame formatted
#'     like an edge list, appropriate input for `LinkMap()`.
#' @importFrom utils count.fields
#' @export
#' @examples
#' # read_adjacency_list(
#' #     "https://ftp.microbio.me/pub/wol2/function/kegg/ko-to-ec.map"
#' # )
#'
read_adjacency_list <- function(
        file, sep = "\t", col.names = c("id.x", "id.y"), as.df = FALSE, ...
        ) {
    # Count fields per line to find indices of the first element of each line.
    n_fields <- count.fields(file, sep = sep, ...)
    key_indices <- cumsum(c(1L, n_fields[-length(n_fields)]))

    x.content <- scan(file, what = character(), sep = sep, quiet = TRUE, ...)

    out <- data.frame(
            id.x = rep(x.content[key_indices], n_fields -1L),
            id.y = x.content[-key_indices]
        )
    colnames(out) <- col.names

    if( !as.df ) out <- LinkMap(out)

    return(out)
}
