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
.set_levels_MultiFactor <- function(x, levels, merge = FALSE) {
    old_levels <- x@levels

    # Initialize first time
    if(!length(old_levels)) {
        new_levels <- levels[colnames(x)]
        S7::prop(x, name = "levels") <- new_levels
    } else {

    new_levels <- .set_levels_internal(old_levels, levels, merge)

    S7::S7_data(x) <- .unify_levels(S7::S7_data(x), new_levels)
    S7::prop(x, name = "levels") <- new_levels
    }
    return(x)
}

#' Utility for when x = S7::S7_data(x)
#' @noRd
.set_levels_lists <- function(x, levels, merge = FALSE) {
    old_names <- unique(unlist(lapply(x, colnames), FALSE, FALSE))
    old_levels <- .gather_all_levels(x, old_names)
    new_levels <- .set_levels_internal(old_levels, levels, merge)
    return(new_levels)
}

.set_levels_internal <- function(old_levels, levels, merge) {
    changed <- names(old_levels) %in% names(levels)
    if(merge) {
        new_levels <- .set_levels_merge(old_levels, levels)
    } else {
        new_levels <- .set_levels_replace(old_levels, levels)
    }
    old_levels[changed] <- new_levels[names(old_levels)[changed]]

    return(old_levels)
}


.set_levels_replace <- function(old_levels, levels) {
    changed <- names(levels) %in% names(old_levels)
    return(levels[changed])
}

.set_levels_merge <- function(old_levels, levels) {
    shared <- intersect(names(levels),  names(old_levels))
    old_lvs <- old_levels[shared]
    new_lvs <- levels[shared]
    merged_lvs <- mapply(union, old_lvs, new_lvs, SIMPLIFY = FALSE)
    lapply(merged_lvs, sort)
}

