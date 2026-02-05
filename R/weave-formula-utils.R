#' Combine LinkMaps by stacking features of multiple types.
#' @description
#' Utility to resolve multiple paths
#' @param x `MultiFactor`
#' @param .by formula
#' @examples
#' x <- randomMultiFactor()
#' .stack_by_formula(x, a + c ~ d + e)
#'
#' @noRd
#'
.stack_by_formula <- function(x, .by) {
    all_terms <- .weave_parse_formula(.by)

    .stack_by_character(x, all_terms[[1L]], all_terms[[2L]])
}

#' Standardize terms
#' @importFrom rlang  f_lhs f_rhs
#' @returns a length 2 character vector of y, x.
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

#' Combine LinkMaps by stacking features of multiple types.
#' @description
#' Utility to resolve multiple paths
#' @param x `MultiFactor`
#' @param y_vars,x_vars `Character vector` names of feature types in left and
#'     right columns of output, respectively.
#' @returns `LinkMap`
#' @noRd
#'
.stack_by_character <- function(x, y_vars, x_vars) {
    # Defensive
    if( length(y_vars) == 0L || length(x_vars) == 0L ) {
        stop("Variables must be specified.")
    }
    stopifnot(
        "Same variable may not appear in both arguments." =
            length(intersect(y_vars, x_vars)) == 0L
    )
    if( length(miss <- setdiff(c(y_vars, x_vars), colnames(x))) >= 1L ) {
        stop(
            "Variables '", paste(miss, collapse = "', '"), "' not found in 'x'."
        )
    }
    # Check combinations
    var_grid <- expand.grid(y_vars, x_vars)
    y_dupes  <- apply(var_grid, 1L, function(v) all(v %in% y_vars))
    x_dupes  <- apply(var_grid, 1L, function(v) all(v %in% x_vars))
    var_list <- apply(var_grid, 1L, `[`, simplify = FALSE)

    i <- vapply(var_list, rowsWithCol, d = x@map, names = FALSE, FUN.VALUE = 0L)

    tot_vars <- unique(unlist(var_list[i > 0L], use.names = FALSE))
    y_name   <- paste(intersect(y_vars, tot_vars), collapse = ".")
    x_name   <- paste(intersect(x_vars, tot_vars), collapse = ".")

    x_sub <- lapply(
        S7::S7_data(x)[i], function(y) {
            # Ensure order: bools + 1L to get 1 and 2, where 2 is the x-column.
            y <- y[, 1L + colnames(y) %in% x_vars ]
            colnames(y) <- c(y_name, x_name)
            y
        }
    )
   do.call(
        rbind.data.frame,
        args = c(x_sub, make.row.names = FALSE, stringsAsFactors = TRUE)
    )

}
