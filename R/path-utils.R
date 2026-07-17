#' Check .path input
#' @returns a named list with three variables. See details.
#' @details
#'     `info` - How long is the provided path? `minimal` or `detailed`.
#'     `complex` - `Logical`. are steps concatenated with "+"?
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

.path_to_std_list <- function(.path, check) switch(
    check[["class"]],
    "character"  = as.list(.path),
    "data.frame" = .path_df_to_list(.path),
    "formula"    = as.list(.cut_fm_by_tildes(.path)),
    "list"       = .path
)

.path_df_to_list <- function(x) as.list( c(x[[1L]], x[[2L]][NROW(x)]) )

#' @importFrom rlang as_label
#' @noRd
#' @returns a character vector of length >= 2L.
.cut_fm_by_tildes <- function(x) unlist(
    strsplit(rlang::as_label(x), " ~ ", fixed = TRUE)
)

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





