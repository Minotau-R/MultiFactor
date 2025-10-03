#' Methods for MultiFactor S7 container class
#' @name MultiFactor-methods
#' @rdname MultiFactor-methods
#' @examples
#' # Setup
#' a2b <- data.frame(
#'     a = sample(letters[seq(3)], 10, replace = TRUE),
#'     b = sample(LETTERS[seq(3)], 10, replace = TRUE)
#' )
#' a2c <- data.frame(
#'     a = sample(letters[seq(3)], 10, replace = TRUE),
#'     c = sample(LETTERS[seq(3)], 10, replace = TRUE)
#' )
#'
#' # Create MultiFactor
#' x <- MultiFactor(list(a2b, a2c))
#'
#' # Basic properties
#' dim(x)
#' dimnames(x)
#'
#' # Factor-like properties
#' levels(x)
#'
#' # Retain MultiFactor structure using `[`.
#' x["x_1"]
#'
#' # Or extract individual LinkMaps using `[[`
#' x[["x_1"]]
#'
#' # Combine using `c`:
#' c(x[2], x[1])
#'
#' @param x,object `MultiFactor` on which the method should be applied.
#' @returns A `MultiFactor`
NULL

S7::method(str, MultiFactor) <- function(object, ...) {
    Matrix::printSpMatrix(object@map)
    str(levels(object))
}

S7::method(print, MultiFactor) <- function(x, ...) {
    cat(
        "A ", paste(class(x), collapse = " "),
        ",\n    ", NCOL(x),
        " feature types across ",
        NROW(x),
        " LinkMaps.\n\n",
        sep = ""
    )
    Matrix::printSpMatrix(x@map)
    cat(
        "\nValues represent unique feature names in that LinkMap.\n\n",
        "Levels: ",
        sep = ""
    )
    str(levels(x))
}

S7::method(levels, MultiFactor) <- function(x) {
    lvs <- unlist(unname(lapply(x, levels)), recursive = FALSE)
    lvs[!duplicated(names(lvs))]
}

S7::method(dimnames, MultiFactor) <- function(x) {
    dimnames(x@map)
}

S7::method(dim, MultiFactor) <- function(x) {
    dim(x@map)
}

local({
S7::method(`[`, MultiFactor) <- function(x, i) {
    if(rlang::is_missing(i)) return(x)
    MultiFactor(base::`[`(S7::S7_data(x), i))
}

S7::method(`[[`, MultiFactor) <- function(x, i) base::`[[`(S7::S7_data(x), i)

})

#' @export
#'
`[<-.MultiFactor::MultiFactor` <- function(x, i, value) {
    MultiFactor(base::`[<-`(S7::S7_data(x), i, value))

}

#' @export
#'
`[[<-.MultiFactor::MultiFactor` <- function(x, i, value) {
    MultiFactor(base::`[[<-`(S7::S7_data(x), i, value))
}

#' @export
#'
`c.MultiFactor::MultiFactor` <- function(...) {
    x <- unlist(lapply(list(...), S7::S7_data), recursive = FALSE)
    MultiFactor(x)
}

#'
method(subset, MultiFactor) <- function(x, subset = NULL, by_path = TRUE) {
    if(is.null(subset)) return(x)
    if(by_path){
        if(inherits(subset, "formula")) {subset <- all.vars(subset)}
        stopifnot("Argument `subset` must be length 2 if by_path` is TRUE" =
                      length(subset) == 2L)
        subset <- termSeq(subset, x)
        # Determine required ids in order, keep relevant elements of MultiFactor
        return(subsetByPath(x, subset))
    }
    `[`(x, subset)
}
