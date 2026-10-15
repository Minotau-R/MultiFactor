#' Set levels of a multifactor Object
#' @param x multifactor or appropriately formatted list
#' @param levels A `named list of character vectors`, to be used as
#'     replacement levels.
#' @param merge A boolean. Whether to merge or overwrite (default) overlapping
#'     levels
#' @importFrom S7 prop<- S7_data<-
#' @returns a multifactor with updated levels.
#' @noRd
#'
.set_levels_multifactor <- function(x, levels) {
    all_lvs <- colnames(x)
    matched_lvs <- names(levels) %in% all_lvs

    new_levels <- levels[matched_lvs]
    S7::S7_data(x) <- .unify_levels( S7::S7_data(x), new_levels )

    return(x)
}

