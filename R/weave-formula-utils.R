#' Standardize terms
#' @returns a length 2 character vector of y, x.
#' @noRd
#'
.by_terms <- function(.by) {
    stopifnot(
        "'.by' must be a character vector or a formula." =
            inherits(.by, c("character", "formula"))
    )
    if(inherits(.by, "formula")) return(.weave_parse_formula(.by))

    if(inherits(.by, "character")) {
        if(length(.by == 2L)) return(.by) else stop(
            "Length of '.by' is must be exactly 2 using character input. ",
            "Use formula syntax for more control."
        )
    }
}




#' Standardize terms
#' @importFrom rlang f_lhs f_rhs
#' @returns a list of length 2 containing character vectors of y, x.
#' @noRd
#'
.weave_parse_formula <- function(.by) {
    stopifnot( "'.by' must be a formula." = inherits(.by, "formula"))
    y_vars <- rlang::f_lhs(.by)
    x_vars <- rlang::f_rhs(.by)
    if( is.null(y_vars) || is.null(x_vars) ) {
        stop("Neither formula side can be empty.")
    }
    lapply(list(y_vars, x_vars), all.vars)
}

