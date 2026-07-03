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

#' @param use.names `Boolean scalar` Should names be provided.
#'     (Default: `TRUE`)
#' @noRd
#'
S7::method(nlevels, LinkMap) <- function(x, use.names = TRUE) lengths(
    levels(x), use.names
    )

S7::method(levels, LinkMap) <- function(x) x@levels

#' @export
#'
`levels<-.MultiFactor::LinkMap` <- function(x, value) {
    x@levels <- value
    return(x)
}

# S7::method(`levels<-`, LinkMap) <- function(x, value) {
#     `levels<-.MultiFactor::LinkMap`(x, value)
# }


#' @importFrom rlang check_dots_empty0 is_missing
#' @export
#'
`[.MultiFactor::LinkMap` <- function(x, i, ...) {
    rlang::check_dots_empty0(...)
    if(! rlang::is_missing(i))  {
        metadata <- x@metadata
        metadata <- `[.data.frame`(metadata, i, , drop = FALSE)

        x <- `class<-`(S7::S7_data(x), "data.frame")
        x <- `[.data.frame`(x, i, , drop = FALSE)

        x <- LinkMap(x, metadata)
        }
    return(x)
}

S7::method(`[`, MultiFactor) <- function(x, i) {

    MultiFactor(base::`[`(S7::S7_data(x), i))
}

S7::method(`[[`, MultiFactor) <- function(x, i) base::`[[`(S7::S7_data(x), i)


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
#' @export
#' @seealso [Matrix::sparseMatrix()]
#'
`as.matrix.MultiFactor::LinkMap` <- function(
        x, terms = colnames(x)[seq_len(2L)],
        dims = nlevels(x)[terms], dimnames = levels(x)[terms],
        ...
) Matrix::sparseMatrix(
    i = x[[terms[1L]]], j = x[[terms[2L]]],
    dims = dims, dimnames = dimnames,
    ...
)
