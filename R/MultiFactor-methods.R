#' Methods for MultiFactor S7 container class
#' @name MultiFactor-methods
#' @rdname MultiFactor-methods
#' @examples
#' # Setup
#' x <- data.frame(
#'     a = sample(letters[seq(3)], 10, replace = TRUE),
#'     A = sample(LETTERS[seq(3)], 10, replace = TRUE)
#' ) |> MultiFactor()
#' x
#'
#' # Basic properties
#' dim(x)
#' dimnames(x)
#'
#' # Factor-like properties
#' levels(x)
#'
#' # Extract component LinkMaps using `[`.
#' x[1]
#' x["ec2cpd"]
#'
#' @param x,object `MultiFactor` on which the method should be applied.
#' @returns A MultiFactor
NULL

method(str, MultiFactor) <- function(object, ...) {
    Matrix::printSpMatrix(object@map)
    str(levels(object))
}

method(print, MultiFactor) <- function(x, ...) {
    cat(
        "A ", paste(class(x), collapse = " "),
        ",\n    ", NCOL(x),
        " feature types across ",
        NROW(x),
        " edge lists.\n\n",
        sep = ""
    )
    Matrix::printSpMatrix(x@map)
    cat(
        "\nValues represent unique feature names in that edge list.\n\n",
        "Levels: ",
        sep = ""
    )
    str(levels(x))
}

method(levels, MultiFactor) <- function(x) {
    lvs <- unlist(unname(lapply(x, levels)), recursive = FALSE)
    lvs[!duplicated(names(lvs))]
}

S7::method(dimnames, MultiFactor) <- function(x) {
    dimnames(x@map)
}

S7::method(dim, MultiFactor) <- function(x) {
    dim(x@map)
}

