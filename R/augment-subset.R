#' Tools to modify MultiFactors
#' @name augment-subset
#' @rdname augment-subset
#' @description
#' Generates a new `MultiFactor` object by cross-referencing the elements of a
#'     given `MultiFactor`.
#' @param x a `MultiFactor` or `LinkMap`.
#' @param ... Name-value pairs. The name gives the name of the LinkMap in the
#'     output.
#' @returns a `MultiFactor`.
#' @examples
#' # Only necessary in example code
#' require(generics)
#' # Generate a random MultiFactor
#' x <- randomMultiFactor()
#'
#' # Use augment to chain together operations like weave and stack, in order.
#' augment(x,
#'     weave(x, a ~ c),
#'     stack(x, a + b ~ c + d),
#'     weave(x, d ~ f)
#' )
#'
#' # Setting a LinkMap to NULL by name deletes it from the MultiFactor
#' augment(x, a2b = NULL )
#'
NULL


#' @export
#' @rdname augment-subset
#' @name augment.MultiFactor
#' @param .path Either a `formula` or a `character vector`.
#' @param .drop.unmatched `Boolean`. Whether to drop factor levels that do not
#'     appear in the data (Default: keep all levels).
#' @aliases subset.MultiFactor::MultiFactor
#'
`subset.MultiFactor::MultiFactor` <- function(
        x, .path, .drop.unmatched = FALSE, ...
) {
    if(.drop.unmatched) x <- .trimMultiFactor(x)

    path_check <- .check_path(.path)
    .path_check_valid_subset(path_check)
    path_list <- .path_to_std_list(.path, path_check)

    path_list <- .path_to_std_list(.path, path_check)

    full_path <- unlist(as.list(.select_std_path(x, path_list)), FALSE, FALSE)

    x <- .subset_by_path(x, full_path)
    return(x)
}

#' @export
#' @rdname augment-subset
#' @name subset.LinkMap
#' @aliases subset.MultiFactor::LinkMap
#' @param subset Logical expression indicating elements or rows to keep.
#'     If `NULL` (Default), subsets based on complete coverage if available.
#'
`subset.MultiFactor::LinkMap` <- function(x, subset = NULL, ...) {
    df <- as.data.frame(x)
    if( is.null(subset) ) {
        if("complete" %in% colnames(df)) {
            i <- df[["complete"]]
            } else {
                i <-  rep_len(TRUE, NROW(df))
            }
    } else {
        e <- substitute(subset)
        i <- eval(e, df, enclos = parent.frame())
    }
    # Indexing a Linkmap takes a single value.
    res <- x[i]
    return(res)
}

.path_check_valid_subset <- function(path_check) {
    if(path_check[["complex"]]) {
        stop(
            "subset() '.path' cannot contain '+'.",
            "Use `stack()` to prepare input."
        )
        }
    }

method(subset, MultiFactor) <- function(
        x, .path, .drop.unmatched = FALSE, ...
) `subset.MultiFactor::MultiFactor`(
    x, .path, .drop.unmatched
)

method(subset, LinkMap) <- function(
        x, subset = NULL, ...
) `subset.MultiFactor::LinkMap`(
    x, subset = NULL, ...
)

#' @importFrom generics augment
#'
S7::method(augment, MultiFactor) <-
    function(x, ...) `augment.MultiFactor::MultiFactor`(x, ...)

#' @export
#' @rdname augment-subset
#' @name augment.MultiFactor
#' @importFrom rlang dots_list
#'
`augment.MultiFactor::MultiFactor` <- function(x, ...) {
    old_names <- rownames(x)
    dots <- rlang::dots_list(...)
    dot_names <- names(dots)
    for ( i in seq_along(dot_names) ) {
        res <- eval(dots[[i]], envir = x, enclos = parent.frame())
        res_name <- dot_names[i]
        if(res_name == "") { res_name <- .linkmap2name(res) }

        if( res_name %in% old_names ) {
            x[[res_name]] <- res
        } else {
            x <- c(x, res)
        }
    }
    return(x)
}

#' Safely get all names from a MultiFactor as a data.frame.
#' @noRd
#'
.all_names_in_list_mf <- function(x) {
    as.data.frame.matrix(
        t(vapply(X = x,
                 FUN = function(i) return(names(i)),
                 FUN.VALUE = c(NA_character_, NA_character_))
        )
    )
}

