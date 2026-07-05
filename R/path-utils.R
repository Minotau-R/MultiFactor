.check_path <- function(.path) {
    # Initialize output with defaults
    res <- c(info = "minimal", vars = "ordinary", class = "character")
    #Some grace for select_path output
    if(is.list(.path) && length(.path) == 1L) {.path <- .path[[1L]] }

    # Defenses
    stopifnot("'.path' requires at least two variables." = length(.path) >= 2L )
    stopifnot(
        "'.path' must be a formula or a (list of) character vector(s)." =
            inherits(.path, c("character", "formula", "list"))
    )
    if(inherits(.path, "formula")) {
        # Formula case
        res["class"] <- "formula"
        # TODO
        # FIXME
        if(.path_function_is_detailed(.path)) {
            res["info"] <- "detailed"
        }
    } else {
        # Character case
        if(is.list(.path)) {
            stopifnot(
                "'.path' list elements must all be character vectors." =
                    all(vapply(.path, is.character, FUN.VALUE = FALSE))
            )
            if( any(lengths(.path) >= 2L) ) { res["vars"] <- "complex" }

        }
        if(length(.path) >= 3L ) res["info"] <- "detailed"

    }
    return(res)
}

.path_ordinary_to_full <- function(x, .path) {
    if(inherits(.path, "formula")) {
    all_terms <- unlist(strsplit(rlang::as_label(.path), " ~ ", fixed = TRUE))
    } else {
        all_terms <- .path
    }
    terms <- all_terms[c(1L, length(all_terms))]
    include <- all_terms[-c(1, length(all_terms))]
    if(!length(include)) { include <- NULL}
    full_path <- .select_path( x, terms, include)
    return(full_path)
}

.build_path <- function(x, .path, pc) {
    if(pc["class"] == "factor") {

    }
    if(pc["vars"] == "complex") .path_prep_complex(.path)
}

#' Standardize terms
#' @returns a length 2 character vector of y, x.
#' @noRd
#'
.path_parse <- function(.path) {

    if(inherits(.path, "formula")) return(.path_parse_formula(.path))

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
.path_function_is_detailed <- function(.path) {
    # Returns TRUE if more than one "~" seen.
    length(unlist(strsplit(rlang::as_label(.path), "~", fixed = TRUE))) > 2L
}

#' @importFrom stats reformulate
#' @noRd
#' @returns a list of step-wise formulae.
.path_prep_complex <- function(.path) {
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
.path_parse_formula <- function(.path) {
    stopifnot( "'.path' must be a formula." = inherits(.path, "formula"))
    y_vars <- rlang::f_lhs(.path)
    x_vars <- rlang::f_rhs(.path)
    if( is.null(y_vars) || is.null(x_vars) ) {
        stop("Neither formula side can be empty.")
    }
    lapply(list(y_vars, x_vars), all.vars)
}

