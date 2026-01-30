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
    igraph::graph_from_data_frame(mf_to_graph_df(x), ...)
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
#' @param source_name `Character scalar` Content of source column in output.
#' @returns a `data.frame` with three named columns; from, to and source_name.
#' @export
#' @examples
#' x <- randomMultiFactor()
#'
#' # Three-column dfs of layouts
#' x_df <- mf_to_graph_df(x, source_name = "example_name")
#'
mf_to_graph_df <- function(x, source_name) {
    if(missing(source_name)) source_name <- deparse1(substitute(x))
    x <- MultiFactor(x)
    x <- lapply(x, names) |>
        list2DF() |>
        t() |>
        as.data.frame.matrix(row.names = NULL, make.names = FALSE)
    rownames(x) <- NULL
    colnames(x) <- c("from", "to")
    x[["source_name"]] <- source_name
    x
}

