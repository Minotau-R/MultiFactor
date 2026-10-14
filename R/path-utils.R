#' Check .path input
#' @returns a named list with three variables. See details.
#' @details
#'     `info`     - How long is the provided path? `minimal` or `detailed`.
#'     `stack`    - `Logical`. are steps concatenated with "+"?
#'     `coverage` - `Logical` or proportion (0-1) of coverage required.
#'
#' @importFrom S7 prop
#' @noRd
#'
.check_path_frame_is_minimal <- function(.path_map) NROW(.path_map) == 1L

.check_path_frame_uses_stack <- function(.path_map) any(.path_map[["stack"]])

.check_path_frame_uses_coverage <- function(.path_map) any(
    .path_map[["coverage"]] > 0
    )

.pm_as_path_list <- function(x) strsplit(terms(x), "+", fixed = TRUE)

.pm_as_full_path_list <- function(x) unname(
    tapply(x, ~components,
        `terms.MultiFactor::path_frame`, simplify = FALSE
    )
)


.valid_path_input <- function(.path) {
    classes <- c("character", "formula", "data.frame", "list")
    #Some grace for select_path output
    if(is.list(.path) && length(.path) == 1L) { .path <- .path[[1L]] }
    stopifnot(
        "'.path' must be a formula or a (list of) character vector(s)." =
            inherits(.path, classes)
    )
    invisible()
}

.path_to_path_frame <- function(.path) path_frame(
        .path_to_path_frame_df(.path)
)

#' @importFrom stats as.formula
.path_to_path_frame_df <- function(.path) {
    .valid_path_input(.path)

    if(is.list(.path) && length(.path) == 1L) {
        .path <- .path[[1L]]
    }
    if(inherits(.path, "character")) {
        .path <- stats::as.formula(paste0(.path, collapse = "~"))
    }
    res <- .cut_fm_to_df(.path)
    return(res)
}


#' @noRd
#' @returns a character vector of length >= 2L.
.cut_fm_by_separators <- function(x, all_seps = c("~", ":")) unlist(
    strsplit(
        gsub(" ", "", deparse1(x)),
        paste0(all_seps, collapse = "|"), fixed = FALSE
    )
)

#' @noRd
#' @returns a character vector of length >= 2L.
.cut_fm_to_df <- function(x, all_seps = c("~", ":")) {
    # Convert to character
    x <- gsub(" ", "", deparse1(x))

    steps <- paste0(all_seps, collapse = "|")

    # Get all separators and content
    seps    <- strsplit(gsub(paste0("[^", steps, "]"), "", x), "")[[1L]]
    content <- strsplit(x, steps)[[1L]]

    from     <- factor(content[seq_along(seps)],      unique(sort(content)) )
    to       <- factor(content[seq_along(seps) + 1L], unique(sort(content)) )
    coverage <- seps == ":"
    stack    <- grepl("+", to, fixed = TRUE) | grepl("+", from, fixed = TRUE)

    data.frame(from, to, coverage, stack)
}




