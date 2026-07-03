#' Set levels of a MultiFactor Object
#' @param x MultiFactor or appropriately formatted list
#' @param levels A `named list of character vectors`, to be used as
#'     replacement levels.
#' @returns a MultiFactor with updated levels.
#' @noRd
#'
.set_levels_MultiFactor <- function(x, levels) {
    all_lvs <- colnames(x)
    matched_lvs <- names(levels) %in% all_lvs

    stopifnot( "No overlap in 'x' and 'levels'." = sum(matched_lvs) >= 1L )

    new_levels <- levels[matched_lvs]

    unchanged <- ! all_lvs %in% names(levels)
    if( sum(unchanged) >= 1L ) {
        new_levels <- c( new_levels, .gather_all_levels(x, all_lvs[unchanged]) )
    }
    S7::S7_data(x) <- .unify_levels(
        `class<-`(S7::S7_data(x), "data.frame"),
        new_levels
        )

    return(x)
}

