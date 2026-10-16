#' Convert a multifactor to igraph
#' @description
#' Extract relational information from multifactor and return an igraph object.
#' Calls `igraph::graph_from_data_frame` under the hood.
#' @name as.igraph.multifactor
#' @aliases as.igraph.multifactor::multifactor
#' @importFrom igraph as.igraph graph_from_data_frame
#' @param x a `multifactor`
#' @param directed See `?igraph::graph_from_data_frame`
#' @param ... Additional arguments passed to `igraph::graph_from_data_frame`.
#' @returns an `igraph` object.
#' @method as.igraph multifactor::multifactor
#' @export
#' @examples
#' x <- random_multifactor()
#'
#' # Make igraph object:
#' igraph::as.igraph(x)
#'
`as.igraph.multifactor::multifactor` <- function(x, directed = FALSE, ...) {
  igraph::graph_from_data_frame(mf_as_graph_df(x), directed, ...)
}

#' Convert a linkmap to igraph
#' @description
#' Extract relational information from linkmap and return an igraph object.
#' Calls `igraph::graph_from_biadjacency_matrix` under the hood.
#' @name as.igraph.linkmap
#' @aliases as.igraph.multifactor::linkmap
#' @importFrom igraph as.igraph graph_from_biadjacency_matrix edge_attr<-
#' @param x a `multifactor`
#' @param directed See `?igraph::graph_from_biadjacency_matrix`
#' @param ... Additional arguments passed to
#'     `igraph::graph_from_biadjacency_matrix`.
#' @returns an `igraph` object.
#' @details If a `linkmap` contains metadata, this can be found back as edge
#' attributes in the returned graph (see `igraph::edge_attr()`)
#' @method as.igraph multifactor::linkmap
#' @export
#' @examples
#' x <- random_linkmap()
#'
#' # Make igraph object:
#' igraph::as.igraph(x)
#'
`as.igraph.multifactor::linkmap` <- function(x, directed = FALSE, ...) {
  g <- igraph::graph_from_biadjacency_matrix(
    `as.matrix.multifactor::linkmap`(x),
    directed, ...
  )
  # Include metadata if it exits
  if (NCOL(mm <- x@metadata) > 0L) {
    for (m in NCOL(mm)) edge_attr(g, colnames(mm)[m]) <- mm[[m]]
  }
  return(g)
}

#' @export
#' @importFrom igraph as.igraph
#'
S7::method(as.igraph, linkmap) <-
  function(x, ...) `as.igraph.multifactor::linkmap`(x, ...)


#' @export
#' @importFrom igraph as.igraph
#'
S7::method(as.igraph, multifactor) <-
  function(x, ...) `as.igraph.multifactor::multifactor`(x, ...)

#' Convert a multifactor to relational graph format.
#' @description
#' Utility function to convert graph information of a multifactor to a
#' `data.frame`. Used in `as.igraph` method for multifactor.
#' @param x multifactor
#' @returns a `data.frame` with three or more named columns; from, to and name.
#' @export
#' @examples
#' x <- random_multifactor()
#'
#' # Three-column dfs of layouts
#' x_df <- mf_as_graph_df(x)
#'
mf_as_graph_df <- function(x) {
  if (!S7::S7_inherits(x, multifactor)) x <- multifactor(x)
  res <- as.data.frame.matrix(.all_names_in_list_mf(x))
  res <- cbind.data.frame(res, x@metadata)
  return(res)
}
