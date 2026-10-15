#' Methods for path_frame S7 container class
#' @name path_frame-methods
#' @rdname path_frame-methods
#'
#' @examples
#' x <- randomMultiFactor()
#'
#' # Generate a path_frame
#' p <- select_path(x, a ~ d)
#'
#' # Get formula notation for the full path:
#' formula(p)
#'
#' @param x,object `path_frame` on which the method should be applied.
#' @returns A `path_frame` or method-appropriate value.
NULL

S7::method(formula, path_frame) <- function(x) `formula.MultiFactor::path_frame`(x)

#' @export
#' @importFrom stats formula as.formula
#'
`formula.MultiFactor::path_frame` <- function(x, ...) {
    out_len <- 1 + 2*NROW(x)
    res <- rep("~", out_len )
    res[seq_len(out_len) %% 2 == 1L] <- `terms.MultiFactor::path_frame`(x)

    if("coverage" %in% colnames(x)) {
        res[seq_len(out_len) %% 2 == 0L][x[["coverage"]] != 0L] <- ":"
        if(any(prop <- x[["coverage"]] > 0L & x[["coverage"]] < 1L)) {

            res[2 * which(prop) + 1L] <- paste0(
                res[2 * which(prop) + 1L], " < ", x[["coverage"]][which(prop)]
            )
        }
    }

    res <- paste0(res, collapse = "")

    stats::as.formula(res, globalenv())

}

S7::method(terms, path_frame) <- function(x) `terms.MultiFactor::path_frame`(x)

#' @export
`terms.MultiFactor::path_frame` <- function(x, ...) as.character(
        c(x[[1L]], x[[2L]][NROW(x)])
    )

S7::method(print, path_frame) <- function(x, ...) {
    from_to <- terms(x)[c(1, NROW(x) + 1L)]

    if( has_comps <- "components" %in% colnames(x) ) {
        p <- tapply(
            x, ~components, `formula.MultiFactor::path_frame`, simplify = FALSE
        )
    } else {
        p <- list(formula(x))
    }

    cat(
        "A ", paste(setdiff(class(x), "data.frame"), collapse = " "),
        ".\n  A path from `", from_to[[1L]], "` to `", from_to[[2L]], "`",
        sep = ""
        )
    if(length(p) == 1L) {
        cat(":\n")
    } else {
        cat(" with ", length(p), " sub-paths:\n", sep = "")
    }
    for ( i in length(p) ) {
        print(p[[1]])
        cat("\n")
    }
}
