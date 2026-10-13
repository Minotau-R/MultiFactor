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
    .valid_path_input(.path)
    pm <- .path_to_PathMap(.path)
    .path_check_valid_stack(pm)

    terms <-  .pm_as_path_list(pm)

    res <- .stack_terms(x, terms)
    if(out.format == "matrix") {
        res <- `as.matrix.MultiFactor::LinkMap`(res)
    }
    return(res)
}

.path_check_valid_stack <- function(x) {
    stopifnot(
        "stack does not support '.path' with multiple tildes " =
            .check_pathmap_is_minimal(x)
    )
    stopifnot(
        "At least one side of '.path' must include variables combined by '+'." =
            .check_pathmap_uses_stack(x)
    )
}

#' @param std_path Takes a std list form and splits it by " + " for stack().
#' @returns a std list with split variables.
#' @noRd
#'
.stack_parse_std_path <- function(std_path) unlist(
    lapply(std_path, strsplit, split = " + ", fixed = TRUE), FALSE, FALSE
)

.stack_terms <- function(x, terms) {
    res <- apply(
        expand.grid(terms), 1L, .stack_weave_terms_df,
        x = x,  simplify = FALSE
    )
    cn <- vapply(lapply(terms, unique), paste, collapse = ".", "")
    res <- do.call( rbind.data.frame, lapply(res, `colnames<-`, cn) )
    res <- LinkMap(res)
    return(res)
}

.stack_weave_terms_df <- function(df, x) .stack_weave_terms(x, c(df))

.stack_weave_terms <- function(x, terms) {
    # Determine required ids in order, only keep relevant elements of link.
    all_terms <- .select_path(x, terms, NULL, NULL, NULL)
    res <- lapply(all_terms, .weave_full_path, x = x, out.format = "LinkMap")
    res <- do.call(
        rbind.data.frame,
        c(res, make.row.names = FALSE, stringsAsFactors = TRUE)
    )
    return(res)
}
