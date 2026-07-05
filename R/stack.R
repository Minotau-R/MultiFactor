#' Combine levels across several LinkMaps in a MultiFactor
#' @name stack
#' @rdname stack.MultiFactor
#' @description
#' Generates a new `LinkMap` object by cross-referencing the elements of a
#'     given `MultiFactor`. Elements can be merged by including several names,
#'     separated by the plus (`+`) sign. See examples.
#' @param x a `MultiFactor`
#' @param .path a `formula` of length 2 with with levels to be merged separated
#'     by the plus (`+`) sign. Optionally, a list with two character vectors,
#'     signifying the variables to be combined at the left and right hand side,
#'     respectively.
#' @param ... Additional arguments (unused.)
#' @param out.format `Character scalar`. One of `'LinkMap'`, `'matrix'`.
#' @returns a `LinkMap` or `sparse Matrix`.
#' @examples
#' x <- randomMultiFactor()
#' # Merge variables with "+" operator, new names get concatenated with ".":
#' stack(x, b ~ c + d)
#'
NULL

#' @export
#'
S7::method(stack, MultiFactor) <- function(
        x, .path, out.format = c("LinkMap", "matrix"), ...
        ) `stack.MultiFactor::MultiFactor`(x, .path, out.format, ...)

#' @importFrom utils stack
#' @export
#' @rdname stack.MultiFactor
#'
`stack.MultiFactor::MultiFactor` <- function(
        x, .path, out.format = c("LinkMap", "matrix"), ...
) {
    out.format <- match.arg(out.format, c("LinkMap", "matrix"))
    .p_check <- .check_path(.path)
    stopifnot(
        "stack does not support '.path' with multiple tildes " =
            .p_check["info"] == "minimal"
        )
    if( .p_check["class"] == "formula" ) {
        terms <- .path_parse_formula(.path)
    }  else {
        terms <- .path
    }
    stopifnot(
        "At least one side of '.path' must include several variables." =
            any( lengths(terms) != 1L)
        )
    res <- .stack_terms(x, terms, out.format = "LinkMap")
    if(out.format == "matrix") {
        res <- `as.matrix.MultiFactor::LinkMap`(res)
    }
    return(res)
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

