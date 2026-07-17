#' Methods for factor_path S7 class
#' @name factor_path-methods
#' @rdname factor_path-methods
#' @examples
#' # Setup
#'
#' set.seed(2612)
#' tp <- trade_posts()
#' x <- select_path(tp, fruit ~ furniture)
#'
#' # Basic properties
#' length(x)
#' terms(x)
#'
#' @param x,object `factor_path` on which the method should be applied.
#' @returns A `factor_path`
NULL

S7::method(length, factor_path) <- function(x) lengths(x@include) + 2L

#' @importFrom stats terms
S7::method(terms, factor_path) <-
    function(x, ...) `terms.MultiFactor::factor_path`(x)

#' @export
`terms.MultiFactor::factor_path` <- function(x, ...) S7::S7_data(x)

#' @export
#'
S7::method(as.list, factor_path) <- function(x, ...) {
    terms <- terms(x)
    lapply(x@include, function(x) c(terms[1L], x, terms[2L]))
}

S7::method(print, factor_path) <- function(x,...) {
    terms <- terms(x)
    from <- terms[1L]
    to   <- terms[2L]
    p <- lapply(x@include, function(x) c(from, x, to))
    cat(
        "A ", paste(setdiff(class(x), "character"), collapse = " "),
        " from `", from, "` to `", to, "`",
        sep = ""
        )
    if(length(p) == 1L) {
        cat(":\n")
    } else {
        cat(" with ", length(p), " sub-paths:\n", sep = "")
    }
    print(p)
}
