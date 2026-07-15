#' Check .path input
#' @returns a named list with three variables. See details.
#' @details
#'     `info` - How long is the provided path? `minimal` or `detailed`.
#'     `complex` - `Logical`. Are the variables `ordinary` or concatenated with "+" `complex`.
#'     `class`- .path class. `character`, `list`, `formula` or `data.frame`.
#'
#' @noRd
#'
.check_path <- function(.path) {
    # Initialize output with defaults
    res <- list(info = "minimal", complex = logical(1L), class = "character")
    classes <- c("character", "formula", "data.frame", "list")
    #Some grace for select_path output
    if(is.list(.path) && length(.path) == 1L) {.path <- .path[[1L]] }
    stopifnot(
        "'.path' must be a formula or a (list of) character vector(s)." =
            inherits(.path, c("character", "formula", "data.frame", "list"))
    )
    # Capture one class for switch statement
    res[["class"]] <- .pc <- intersect(class(.path), classes)
    # Defenses
    stopifnot("'.path' requires at least two variables." = length(.path) >= 2L)

    switch (.pc,
            formula = {
                ff <- .cut_fm_by_tildes(.path)
                res[["complex"]] <- any(grepl(" + ", ff, fixed = TRUE))
                if( length(ff) > 2L ) res["info"] <- "detailed"
            },
            list =,
            character = {
                stopifnot(
                    "'.path' list elements must all be character vectors." =
                        all(vapply(.path, is.character, FUN.VALUE = FALSE))
                )
                res[["complex"]] <- any(lengths(.path) >= 2L)
                if( length(.path) >= 3L ) res["info"] <- "detailed"
            },
            data.frame = {
                stopifnot(
                    "If class(.path) == 'data.frame' it must have two columns" =
                        NCOL(.path) == 2L
                )
                if(NROW(.path) >= 2L) res["info"] <- "detailed"
            }
    )

    return(res)
}

.std_path_to_list <- function(x, .path, check) switch(
    check[["class"]],
    "character"  = res <- as.list(.path),
    "data.frame" = res <- .path_df_to_list(.path),
    "formula"    = res <- as.list(.cut_fm_by_tildes(.path)),
    "list"       = res <- .path
)

.select_std_path <- function(x, std_path) {
    terms <- unlist(std_path[c(1L, length(std_path))], FALSE, FALSE)
    include <- unlist(std_path[-c(1, length(std_path))], FALSE, FALSE)
    if(!length(include)) { include <- NULL }
    full_path <- .select_path( x, terms, include )

    return(full_path)
}


#' @param std_path Takes a std list form and splits it by " + " for stack().
#' @returns a std list with split variables.
#' @noRd
#'
.parse_stack_std_path <- function(std_path) unlist(
    lapply(std_path, strsplit, split = " + ", fixed = TRUE), FALSE, FALSE
)


.path_df_to_list <- function(x) as.list(c(x[[1L]], x[[2L]][NROW(x)]))


.path_ordinary_to_full <- function(x, .path) {
    if(inherits(.path, "formula")) {
        all_terms <- .cut_fm_by_tildes(.path)
    } else {
        all_terms <- .path
    }
    terms <- all_terms[c(1L, length(all_terms))]
    include <- all_terms[-c(1, length(all_terms))]
    if(!length(include)) { include <- NULL}
    full_path <- .select_path( x, terms, include)
    return(full_path)
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


#' @importFrom rlang as_label
#' @noRd
#' @returns a character vector of length >= 2L.
.cut_fm_by_tildes <- function(x) unlist(
    strsplit(rlang::as_label(x), " ~ ", fixed = TRUE)
    )



#' @importFrom stats reformulate
#' @noRd
#' @returns a list of step-wise formulae.
.path_prep_fm_detailed <- function(.path) {
    all_terms <- .cut_fm_by_tildes(.path)
    lapply(
        seq_len(length(all_terms) -1L),
        function(i) stats::reformulate(all_terms[i+1L], all_terms[i])
    )
}




