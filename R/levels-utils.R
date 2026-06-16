#' Set levels of a MultiFactor Object
#' @param x MultiFactor or appropriately formatted list
#' @param levels A `named list of character vectors`, to be used as
#'     replacement levels.
#' @returns a MultiFactor with updated levels.
#'
.set_levels_MultiFactor <- function(x, levels) {
    all_lvs <- unique(unlist(lapply(x, colnames), FALSE, FALSE))
    matched_lvs <- names(levels) %in% all_lvs

    stopifnot( "No overlap in 'x' and 'levels'." = sum(matched_lvs) >= 1L )

    new_levels <- levels[matched_lvs]

    unchanged <- ! all_lvs %in% names(levels)
    if( sum(unchanged) >= 1L ) {
        new_levels <- c( new_levels, .gather_all_levels(x, all_lvs[unchanged]) )
    }

    if(S7::S7_inherits(x, MultiFactor)) {
        S7::S7_data(x) <- .unify_levels(S7::S7_data(x), new_levels)
        x@levels <- new_levels
    } else {
        x <- MultiFactor(x, new_levels)
    }
    return(x)
}

