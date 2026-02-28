
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

