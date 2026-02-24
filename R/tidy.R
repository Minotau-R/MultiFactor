#' Expand a table based on possibly overlapping group membership.
#' @name subgroup_to_tbl
#' @description
#' Expand a table
#' @param x `A table`. A `data.frame`, `matrix`, other object with rows and
#'     columns. Should have a `cbind` method.
#' @param link a `MultiFactor`.
#' @param .by either a `formula` or a `character vector`` of length 2 with the
#'     names of the desired combination of feature types.
#' @param .index `Character scalar` Column to look for feature IDs to link.
#'     Default: "row.names".
#' @returns An expanded table `x`, with an added first column containing
#'     subgroups.
#' @importFrom Matrix which
#' @examples
#' # Prepare data
#' link <- anansi::kegg_link()
#' data("FMT_data", package = "anansi")
#' x <- FMT_KOs
#' subgroup_to_tbl(x, link, .by = ec ~ ko)
#'
#' @export
#'
subgroup_to_tbl <- function(x, link, .by, .index = "row.names") {
   out <- .index_tbl_by(x, link, .by, .index)
   out[[2L]] <- as.integer(out[[2L]])
   xcol <- if(.index == "row.names") row.names(x) else x[[.index]]

   subgroup <- data.frame(y = out[1L], x = xcol[out[[2L]]])
   colnames(subgroup) <- if(inherits(.by, "formula")) all.vars(.by) else .by

   cbind(subgroup, x[out[[2L]], ])
}
