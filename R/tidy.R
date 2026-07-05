#' Expand a table based on possibly overlapping group membership.
#' @name subgroup_to_tbl
#' @description
#' Expand a table into a tidy table suitable for tidyverse-stype operations.
#' @param x `A table`. A `data.frame`, `matrix`, other object with rows and
#'     columns. Should have a `cbind` method.
#' @param link a `MultiFactor`.
#' @param .path either a `formula` or a `character vector`` of length 2 with the
#'     names of the desired combination of feature types.
#' @param .index `Character scalar` Column to look for feature IDs to link.
#'     Default: "row.names".
#' @returns An expanded table `x`, with an added first column containing
#'     subgroups.
#' @importFrom Matrix which
#' @examples
#' # Prepare data
#' link <- trade_posts()
#'
#' # Generate small example feature table 'x'.
#' n <- nlevels(link)[["clothing"]]
#' x <- replicate(10, rbinom(n, rbinom(n, 100, runif(n)), runif(n)))
#'
#' #' # Ensure rownames correspond to the second (RHS) variable in the formula.
#' x <- as.data.frame(x, row.names = levels(link)$clothing)
#'
#' # Apply arbitrary code to x based on group membership
#' subgroup_to_tbl(x, link, .path = fruit ~ clothing)
#'
#' @export
#'
subgroup_to_tbl <- function(x, link, .path, .index = "row.names") {
   out <- S7::S7_data( .index_tbl_by(x, link, .path, .index) )
   class(out) <- "data.frame"
   out[[2L]] <- as.integer(out[[2L]])
   xcol <- if(.index == "row.names") row.names(x) else x[[.index]]

   subgroup <- data.frame(y = out[1L], x = xcol[out[[2L]]], check.rows = FALSE)
   colnames(subgroup) <- if(inherits(.path, "formula")) all.vars(.path) else .path

   out <- data.frame(subgroup, x[out[[2L]], ])
   row.names(out) <- NULL
   out
}
