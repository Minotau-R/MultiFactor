#' Convert a MultiFactor to igraph
#' @description
#' Extract relational information from MultiFactor and return an igraph object.
#' @name as.igraph.MultiFactor
#' @aliases as.igraph.MultiFactor::MultiFactor
#' @importFrom igraph as.igraph graph_from_data_frame
#' @param x a `MultiFactor`
#' @param ... Additional arguments passed to `graph_from_data_frame`.
#' @returns an `igraph` object.
#' @method as.igraph MultiFactor::MultiFactor
#' @export
#' @examples
#' x <- randomMultiFactor()
#'
#' # Make igraph object:
#' igraph::as.igraph(x)
#'
`as.igraph.MultiFactor::MultiFactor`  <- function(x, ...) {
    igraph::graph_from_data_frame(mf_as_graph_df(x), ...)
}

#' @export
#' @importFrom igraph as.igraph
#'
S7::method(as.igraph, MultiFactor) <-
    function(x, ...) `as.igraph.MultiFactor::MultiFactor`(x, ...)


#' Convert a MultiFactor to relational graph format.
#' @description
#' Utility function to convert graph information of a MultiFactor to a
#' `data.frame`. Used in `as.igraph` method for MultiFactor.
#' @param x MultiFactor
#' @returns a `data.frame` with three or more named columns; from, to and name.
#' @export
#' @examples
#' x <- randomMultiFactor()
#'
#' # Three-column dfs of layouts
#' x_df <- mf_as_graph_df(x)
#'
mf_as_graph_df <- function(x) {
    x <- MultiFactor(x)

    res <- as.data.frame.matrix(
        t(vapply(x, names, c(NA_character_, NA_character_))),
    )
    cbind.data.frame(res, x@metadata)
}

