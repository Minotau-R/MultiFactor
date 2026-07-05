#' Convert a MultiFactor to igraph
#' @description
#' Extract relational information from MultiFactor and return an igraph object.
#' Calls `igraph::graph_from_data_frame` under the hood.
#' @name as.igraph.MultiFactor
#' @aliases as.igraph.MultiFactor::MultiFactor
#' @importFrom igraph as.igraph graph_from_data_frame
#' @param x a `MultiFactor`
#' @param directed See `?igraph::graph_from_data_frame`
#' @param ... Additional arguments passed to `igraph::graph_from_data_frame`.
#' @returns an `igraph` object.
#' @method as.igraph MultiFactor::MultiFactor
#' @export
#' @examples
#' x <- randomMultiFactor()
#'
#' # Make igraph object:
#' igraph::as.igraph(x)
#'
`as.igraph.MultiFactor::MultiFactor`  <- function(x, directed = FALSE, ...) {
    igraph::graph_from_data_frame(mf_as_graph_df(x), directed, ...)
}

#' Convert a LinkMap to igraph
#' @description
#' Extract relational information from LinkMap and return an igraph object.
#' Calls `igraph::graph_from_biadjacency_matrix` under the hood.
#' @name as.igraph.LinkMap
#' @aliases as.igraph.MultiFactor::LinkMap
#' @importFrom igraph as.igraph graph_from_biadjacency_matrix edge_attr<-
#' @param x a `MultiFactor`
#' @param directed See `?igraph::graph_from_biadjacency_matrix`
#' @param ... Additional arguments passed to
#'     `igraph::graph_from_biadjacency_matrix`.
#' @returns an `igraph` object.
#' @details If a `LinkMap` contains metadata, this can be found back as edge
#' attributes in the returned graph (see `igraph::edge_attr()`)
#' @method as.igraph MultiFactor::LinkMap
#' @export
#' @examples
#' x <- randomLinkMap()
#'
#' # Make igraph object:
#' igraph::as.igraph(x)
#'
`as.igraph.MultiFactor::LinkMap`  <- function( x, directed = FALSE, ... ) {

    g <- igraph::graph_from_biadjacency_matrix(
        `as.matrix.MultiFactor::LinkMap`( x ),
        directed, ...
    )
    # Include metadata if it exits
    if ( NCOL(mm <- x@metadata) > 0L ) {
        for( m in NCOL(mm) ) edge_attr(g, colnames(mm)[m]) <- mm[[m]]
    }
    return(g)
}

#' @export
#' @importFrom igraph as.igraph
#'
S7::method(as.igraph, LinkMap) <-
    function(x, ...) `as.igraph.MultiFactor::LinkMap`(x, ...)


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
    if(!S7::S7_inherits(x, MultiFactor)) x <- MultiFactor(x)
    res <- as.data.frame.matrix( .all_names_in_list_mf(x) )
    res <- cbind.data.frame(  res, x@metadata )
    return(res)
}

