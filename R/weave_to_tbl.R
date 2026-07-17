#' Expand a table based on possibly overlapping group membership.
#' @name weave_to_tbl
#' @description
#' Expand a table into a tidy table suitable for tidyverse-stype operations.
#' @param x a `MultiFactor`.
#' @param .data `A table`. A `data.frame`, `matrix`, other object with rows and
#'     columns. Should have a `cbind` method.
#' @param .path either a `formula` or a `character vector`` of length 2 with the
#'     names of the desired combination of feature types.
#' @param .index `Character scalar` Column to look for feature IDs to link.
#'     Default: "row.names".
#' @returns An expanded table `x`, with an added first column containing
#'     subgroups.
#' @importFrom Matrix which
#' @examples
#' # Prepare data
#' x <- trade_posts()
#'
#' # Generate small example feature table 'df'.
#' n <- nlevels(x)[["clothing"]]
#' df <- replicate(10, rbinom(n, rbinom(n, 100, runif(n)), runif(n)))
#'
#' #' # Ensure rownames correspond to the second (RHS) variable in the formula.
#' df <- as.data.frame(df, row.names = levels(x)$clothing)
#'
#' # Apply arbitrary code to x based on group membership
#' weave_to_tbl(x, .path = fruit ~ clothing, .data = df)
#'
#' @export
#'
weave_to_tbl <- function(x, .path, .data, .index = "row.names") {
   path_check <- .check_path(.path)

   .path_check_valid_weave_to_tbl(path_check)

   path_list <- .path_to_std_list(.path, path_check)

   out <- .index_tbl_by_path_list(x, path_list, .data, .index)
   out <- `class<-`(S7::S7_data(out), "data.frame")

   out[[2L]] <- as.integer(out[[2L]])
   xcol <- if(.index == "row.names") row.names(.data) else .data[[.index]]

   subgroup <- data.frame(y = out[1L], x = xcol[out[[2L]]], check.rows = FALSE)
   colnames(subgroup) <- terms(.std_path_as_factor_path(path_list))

   out <- data.frame(subgroup, .data[out[[2L]], ])
   row.names(out) <- NULL
   return(out)
}

.path_check_valid_weave_to_tbl <- function(path_check) {
   if(path_check[["complex"]]) {
      stop(
         "`weave_to_tbl()` '.path' cannot contain '+'.",
         "Use `stack()` to prepare input."
      )
   }
}
