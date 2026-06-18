.check_by_terms <- function(.path) {
    res <- c("single", "character")
    #Some grace for select_path output
    if(is.list(.path)) {
        stopifnot(
            "'.path' must be a formula or character vector." = length(.path) == 1L
        )
        .path <- .path[[1L]]
    }
    stopifnot(
        "'.path' must be a character vector or a formula." =
            inherits(.path, c("character", "formula"))
    )
    if(is.character(.path)) {
        if(length(.path) < 2L) stop(
            "Length of '.path' is must be at least 2 using character input. "
        )
        if(length(.path) >= 3L ) res[1L] <- "full"
    }
    if(inherits(.path, "formula")) {
        res[2L] <- "formula"
        if(.path_is_complex(.path)) {
            res[1L] <- "complex"
        }
    }
    return(res)
}


#' Standardize terms
#' @returns a length 2 character vector of y, x.
#' @noRd
#'
.path_terms <- function(.path) {


    if(inherits(.path, "formula")) return(.weave_parse_formula(.path))

    if(inherits(.path, "character")) {
        if(length(.path == 2L)) return(.path) else stop(
            "Length of '.path' is must be exactly 2 using character input. ",
            "Use formula syntax for more control."
        )
    }
}

#' @returns BOOL
#' @noRd
#' @importFrom rlang as_label
#'
.path_is_complex <- function(.path) {
    # Only support complex through formula
    if(is.character(.path)) return(FALSE)

    stopifnot(
        "'.path' must be a character vector or a formula." =
            inherits(.path, c("character", "formula"))
    )
    # Returns TRUE if more than one "~" seen.
    length(unlist(strsplit(rlang::as_label(.path), "~", fixed = TRUE))) > 2L
}

#' @importFrom stats reformulate
#' @noRd
#' @returns a list of step-wise formulae.
.path_prep_complex_call <- function(.path) {
    all_terms <- unlist(strsplit(rlang::as_label(.path), "~", fixed = TRUE))
    lapply(
        seq_len(length(all_terms) -1L),
        function(i) stats::reformulate(all_terms[i+1L], all_terms[i])
        )
    }


#' Standardize terms
#' @importFrom rlang f_lhs f_rhs
#' @returns a list of length 2 containing character vectors of y, x.
#' @noRd
#'
.weave_parse_formula <- function(.path) {
    stopifnot( "'.path' must be a formula." = inherits(.path, "formula"))
    y_vars <- rlang::f_lhs(.path)
    x_vars <- rlang::f_rhs(.path)
    if( is.null(y_vars) || is.null(x_vars) ) {
        stop("Neither formula side can be empty.")
    }
    lapply(list(y_vars, x_vars), all.vars)
}

