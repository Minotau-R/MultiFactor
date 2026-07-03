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

    # Initialize first time
    if(!length(old_levels)) {
        new_levels <- levels[colnames(x)]
        S7::prop(x, name = "levels") <- new_levels
    } else {

    new_levels <- .set_levels_internal(old_levels, levels, merge)

    S7::S7_data(x) <- .unify_levels(S7::S7_data(x), new_levels)
    S7::prop(x, name = "levels") <- new_levels
    }
    S7::S7_data(x) <- .unify_levels(
        `class<-`(S7::S7_data(x), "data.frame"),
        new_levels
        )

    return(x)
}

