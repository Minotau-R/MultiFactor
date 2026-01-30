#' Index a table and apply arbitrary code to it
#' @name subgroup_apply
#' @rdname subgroup_apply
#' @description
#' `subgroup_apply` can run arbitrary code specified by `FUN` across any number
#'  of row-based subsets of table `X`. Mimics lapply.
#' @param X `A table`. A `data.frame`, `matrix`, other object with rows and
#'     columns.
#' @param LINK a `MultiFactor` object.
#' @param BY either a `formula` or a `character vector`` of length 2 with the
#'     names of the desired combination of feature types.
#' @param FUN A function, passed to lapply.
#' @param ... Additional arguments passed to lapply call.
#' @param INDEX `Character scalar` Where in `X` can the target feature names be
#'     found. (Default: "row.names")
#' @returns a `Named list` of desired output.
#' @examples
#'
#' # Prepare data
#' link <- anansi::kegg_link()
#' data("FMT_data", package = "anansi")
#' x <- FMT_KOs
#'
#' # Apply arbitrary code to x based on group membership
#' subgroup_apply(x, link, BY =  ec ~ ko, FUN = function(x) dim(x))
#'
#' @seealso [weave()] [LinkMap()] [MultiFactor()]
#' @export
#'
subgroup_apply <- function( X, LINK, BY, FUN = NULL, ..., INDEX = "row.names" ) {
    FUN <- if (!is.null(FUN)) match.fun(FUN)

    IDX <- .splitLinkMap( .index_tbl_by(X, LINK, BY, INDEX) )

    # Mimic tapply behaviour
    if(is.null(FUN)) return(IDX)

    # Apply FUN over each subset of X indexed by IDX
    lapply(X = IDX, FUN = function(iii) FUN(X[iii, ]), ...)
}

#' Index a table
#' @name .index_tbl_by
#' @rdname index_tbl
#' @description
#' `.index_tbl_by()` finds row indices for input table `x`, based on a
#' user-defined path through a MultiFactor (`link` arg).
#'
#' @param type `Character scalar` Specifies name of the feature type, will be
#'     used as name of the first column in output.
#' @param .i `Character scalar` column with features. Defaults to `rownames(X)`
#' @noRd
#' @examples
#' # Any table can be a indexed into a LinkMap:
#' .index_tbl(mtcars)
#'
.index_tbl <- function(
        X, type = deparse1(substitute(X)), .i = "row.names", ...
        ) {
    if (.i == "row.names") { row.index <- rownames(X) } else row.index <- X[[.i]]

    res <- data.frame( row.index, seq_len(NROW(X)) )

    colnames(res) <- c(type, "row.index")
    LinkMap(res, ...)
}

#' Index a table
#' @name .index_tbl_by
#' @rdname index_tbl
#' @description
#' `.index_tbl()` is a utility function that flexibly takes a table as input and
#' returns a special `LinkMap` object that has (1) row names and (2)
#' corresponding row indices of that table as columns.
#'
#' @param link a `MultiFactor` object.
#' @param .by either a `formula` or a `character vector`` of length 2 with the
#'     names of the desired combination of feature types.
#' @noRd
#' @examples
#' # Utilities
#' .index_tbl_by(x, link, ec ~ ko)
#'
.index_tbl_by <- function(X, link, .by, .i = "row.names", ...) {
    # Ensure link is a MultiFactor
    link <- MultiFactor(link)

    terms <- .by_terms(.by)
    X <- .index_tbl(X, type = terms[[2L]], .i = .i)
    terms[[2L]] <- colnames(X)[[2L]]
    X <- MultiFactor(X)

    X <- `c.MultiFactor::MultiFactor`(link, X)

    weave(X, .by = terms, ...)

}

#' @noRd
.splitLinkMap <- function(x, drop = TRUE) split.default(
    as.integer(x[[2L]]), x[[1L]], drop
    )



