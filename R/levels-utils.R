#' Set levels of a MultiFactor Object
#' @param x MultiFactor or appropriately formatted list
#' @param levels A `named list of character vectors`, to be used as
#'     replacement levels.
#' @param merge A boolean. Whether to merge or overwrite (default) overlapping
#'     levels
#' @importFrom S7 prop<-
#' @returns a MultiFactor with updated levels.
#' @noRd
#'
.set_levels_MultiFactor <- function(x, levels) {
    all_lvs <- colnames(x)
    matched_lvs <- names(levels) %in% all_lvs

    new_levels <- levels[matched_lvs]
    S7::S7_data(x) <- .unify_levels(
        `class<-`(S7::S7_data(x), "data.frame"),
        new_levels
    )

    return(x)
}

