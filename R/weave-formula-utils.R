.check_by_terms <- function(.by) {
    res <- c("single", "character")
    #Some grace for select_path output
    if(is.list(.by)) {
        stopifnot(
            "'.by' must be a formula or character vector." = length(.by) == 1L
        )
        .by <- .by[[1L]]
    }
    stopifnot(
        "'.by' must be a character vector or a formula." =
            inherits(.by, c("character", "formula"))
    )
    if(is.character(.by)) {
        if(length(.by) < 2L) stop(
            "Length of '.by' is must be at least 2 using character input. "
        )
        if(length(.by) >= 3L ) res[1L] <- "full"
    }
    if(inherits(.by, "formula")) {
        res[2L] <- "formula"
        if(.by_is_complex(.by)) {
            res[1L] <- "complex"
        }
    }
    return(res)
}


#' Standardize terms
#' @returns a length 2 character vector of y, x.
#' @noRd
#'
.by_terms <- function(.by) {


    if(inherits(.by, "formula")) return(.weave_parse_formula(.by))

    if(inherits(.by, "character")) {
        if(length(.by == 2L)) return(.by) else stop(
            "Length of '.by' is must be exactly 2 using character input. ",
            "Use formula syntax for more control."
        )
    }
}

#' @returns BOOL
#' @noRd
#' @importFrom rlang as_label
#'
.by_is_complex <- function(.by) {
    # Only support complex through formula
    if(is.character(.by)) return(FALSE)

    stopifnot(
        "'.by' must be a character vector or a formula." =
            inherits(.by, c("character", "formula"))
    )
    # Returns TRUE if more than one "~" seen.
    length(unlist(strsplit(rlang::as_label(.by), "~", fixed = TRUE))) > 2L
}

#' @importFrom stats reformulate
#' @noRd
#' @returns a list of step-wise formulae.
.by_prep_complex_call <- function(.by) {
    all_terms <- unlist(strsplit(rlang::as_label(.by), "~", fixed = TRUE))
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
.weave_parse_formula <- function(.by) {
    stopifnot( "'.by' must be a formula." = inherits(.by, "formula"))
    y_vars <- rlang::f_lhs(.by)
    x_vars <- rlang::f_rhs(.by)
    if( is.null(y_vars) || is.null(x_vars) ) {
        stop("Neither formula side can be empty.")
    }
    lapply(list(y_vars, x_vars), all.vars)
}

