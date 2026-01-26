
S7::method(str, LinkMap) <- function(object, ...) str(
    `class<-`(S7::S7_data(object), "data.frame")
)

S7::method(levels, LinkMap) <- function(x) lapply(x, levels)

#' @param use.names `Boolean scalar` Should names be provided.
#'     (Default: `TRUE`)
#' @noRd
#'
S7::method(nlevels, LinkMap) <- function(x, use.names = TRUE) lengths(
    levels(x), use.names
    )

#' @title Convert a LinkMap to a sparse matrix.
#' @name as.matrix.LinkMap
#' @param x a `LinkMap` object.
#' @param terms id of cols in their desired order. `c(rows, cols)`.
#' @param dims length-2 integer vector of matrix dimensions.
#' @param ... additional arguments. Not used.
#' @importFrom Matrix sparseMatrix
#' @returns a sparse biadjacency `Matrix` with
#' @importFrom Matrix sparseMatrix
#' @export
#' @seealso [Matrix::sparseMatrix()]
#'
`as.matrix.MultiFactor::LinkMap` <- function(
        x, terms = colnames(x),
        dims = nlevels(x[terms]), ...
) Matrix::sparseMatrix(i = x[[terms[1L]]], j = x[[terms[2L]]], dims = dims)
