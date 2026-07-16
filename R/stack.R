#' Combine levels across several LinkMaps in a MultiFactor
#' @name stack-methods
#' @rdname stack-methods
#' @description Generates a new `LinkMap` object by merging levels by name,
#'     separated by the plus (`+`) sign. See examples.
#' @param x a `MultiFactor`
#' @param .path a `formula` of length 2 with with levels to be merged separated
#'     by the plus (`+`) sign. Optionally, a list with two character vectors,
#'     signifying the variables to be combined at the left and right hand side,
#'     respectively.
#' @param ... Additional arguments (unused.)
#' @param out.format `Character scalar`. One of `'LinkMap'`, `'matrix'`.
#' @returns a `LinkMap` or `sparse Matrix`.
#' @importFrom utils stack
#' @examples
#' # Only necessary in example code
#' require(utils)
#'
#' x <- randomMultiFactor()
#' # Merge variables with "+" operator, new names get concatenated with ".":
#' stack(x, b ~ c + d)
#'
NULL

S7::method(stack, MultiFactor) <- function(
        x, .path, out.format = c("LinkMap", "matrix"), ...
        ) `stack.MultiFactor::MultiFactor`(x, .path, out.format, ...)

#' @importFrom utils stack
#' @export
#'
`stack.MultiFactor::MultiFactor` <- function(
        x, .path, out.format = c("LinkMap", "matrix"), ...
) {
    out.format <- match.arg(out.format, c("LinkMap", "matrix"))
    # Handle .path arg
    path_check <- .check_path(.path)
    .path_check_valid_stack(path_check)
    path_list <- .std_path_to_list(x, .path, path_check)

    terms <-  .parse_stack_std_path(path_list)

    res <- .stack_terms(x, terms, out.format = "LinkMap")
    if(out.format == "matrix") {
        res <- `as.matrix.MultiFactor::LinkMap`(res)
    }
    return(res)
}

.path_check_valid_stack <- function(path_check) {
    stopifnot(
        "stack does not support '.path' with multiple tildes " =
            path_check[["info"]] == "minimal"
    )
    stopifnot(
        "At least one side of '.path' must include variables combined by '+'." =
            path_check[["complex"]]
    )
}

.stack_terms <- function(x, terms, out.format) {
    res <- apply(
        expand.grid(terms), 1L, .weave_ordinary_terms_df,
        x = x, out.format = out.format, simplify = FALSE
    )
    if(out.format == "LinkMap") {
        cn <- vapply(lapply(terms, unique), paste, collapse = ".", "")
        res <- do.call( rbind.data.frame, lapply(res, `colnames<-`, cn) )
        res <- LinkMap(res)
    }
    return(res)
}

