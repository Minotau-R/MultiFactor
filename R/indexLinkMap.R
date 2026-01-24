#' Index a table
#' @name indexLinkMap
#' @description
#' `indexLinkMap` is a utility function that flexibly takes a table as input and
#' returns a special `LinkMap` object that has (1) row names and (2)
#' corresponding row indices of that table as columns. It can be used with
#' `weave()` to obtain row indices in based on possibly overlapping groupings.
#'
#' @param x `A table`. A `data.frame`, `matrix`, other object with rows and
#'     columns.
#' @param type `Character scalar` Specifies name of the feature type, will be
#'     used as name of the first column in output.
#' @param ... Additional arguments passed to `LinkMap()` call.
#' @returns a `LinkMap` object.
#' @examples
#' # Any table can be a indexed
#' indexLinkMap(mtcars)
#'
#' @seealso [LinkMap()] [MultiFactor()]
#' @export
#'
indexLinkMap <- function(x, type = deparse1(substitute(x)), ...) {
    res <- data.frame( rownames(x), seq_len(NROW(x)) )

    colnames(res) <- c(type, "row.index")
    LinkMap(res, ...)
}
