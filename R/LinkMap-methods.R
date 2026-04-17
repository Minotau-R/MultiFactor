#' Methods for LinkMap S7 container class
#' @name LinkMap-methods
#' @rdname LinkMap-methods
#' @examples
#' # Setup
#' a2b <- data.frame(
#'     a = sample(letters[seq(3)], 10, replace = TRUE),
#'     b = sample(LETTERS[seq(3)], 10, replace = TRUE)
#' )
#'
#' # Create LinkMap
#' x <- LinkMap(a2b)
#'
#' # Basic properties
#' dim(x)
#' dimnames(x)
#'
#' # Factor-like properties
#' levels(x)
#' nlevels(x)
#'
#'
#' @param x,object `LinkMap` on which the method should be applied.
#' @returns A `LinkMap`
NULL

S7::method(names, LinkMap) <- function(x) names(
    S7::S7_data(x)[c(1, 2)]
    )

S7::method(dimnames, LinkMap) <- function(x) dimnames(
    `class<-`(S7::S7_data(x), "data.frame")[c(1, 2)]
    )

S7::method(dim, LinkMap) <- function(x) dim(
    `class<-`(S7::S7_data(x), "data.frame")[c(1, 2)]
    )

S7::method(print, LinkMap) <- function(x, ...) print(
    `class<-`(S7::S7_data(x), "data.frame")[c(1, 2)], ...
)

S7::method(str, LinkMap) <- function(object, ...) str(
    `class<-`(S7::S7_data(object), "data.frame")
)

S7::method(levels, LinkMap) <- function(x) lapply(x[c(1, 2)], levels)

#' @param use.names `Boolean scalar` Should names be provided.
#'     (Default: `TRUE`)
#' @noRd
#'
S7::method(nlevels, LinkMap) <- function(x, use.names = TRUE) lengths(
    levels(x), use.names
    )

#' @title Convert a LinkMap to a sparse matrix.
#' Convert a LinkMap to a sparse matrix object from the `Matrix` package.
#' @name as.matrix.LinkMap
#' @param x a `LinkMap` object.
#' @param terms id of cols in their desired order. `c(rows, cols)`.
#' @param dims length-2 integer vector of matrix dimensions.
#'     Default: `colnames(x)`
#' @param dimnames list of dimnames. (Default: `levels(x)`).
#' @param ... additional arguments. Not used.
#' @importFrom Matrix sparseMatrix
#' @returns a sparse biadjacency `Matrix` with
#' @importFrom Matrix sparseMatrix
#' @export
#' @seealso [Matrix::sparseMatrix()]
#'
`as.matrix.MultiFactor::LinkMap` <- function(
        x, terms = colnames(x),
        dims = nlevels(x[terms]), dimnames = levels(x)[terms],
        ...
) Matrix::sparseMatrix(
    i = x[[terms[1L]]], j = x[[terms[2L]]],
    dims = dims, dimnames = dimnames,
    ...
)
