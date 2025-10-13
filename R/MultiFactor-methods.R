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
#' nlevels(x)
#'
#' # Retain MultiFactor structure using `[`.
#' x["a2b"]
#'
#' # Or extract individual LinkMaps using `[[`
#' x[["a2c"]]
#'
#' # Subset by a path
#' subset(x, a ~ c)
#'
#' # Unused features will be dropped unless specified:
#' subset(x, a ~ c, drop.unmatched = FALSE)
#'
#' # Combine using `c`:
#' c(x[2], x[1])
#'
#' @param x,object `MultiFactor` on which the method should be applied.
#' @returns A `MultiFactor`
NULL

#' @param use.names `Boolean scalar` Whether tho provide names.
#'     (Default: `TRUE`)
#' @noRd
#'
S7::method(nlevels, MultiFactor) <-
    function(x, use.names = TRUE) lengths(levels(x), use.names)

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
        "Levels:\n",
        sep = ""
    )
    id_w <- max(nchar(colnames(x)))
    nm_w <- max(nchar(lengths(levels(x), use.names = FALSE)))
    fr_w <- getOption("width") -id_w -nm_w -12
    for (id in colnames(x)) {
        num_lvs <- length(levels(x)[[id]])
        cat(
            format(id, width = id_w),
            " : ",
            format(num_lvs, width = nm_w),
            " Levels: ",
            sep = ""
        )

        if (num_lvs > 4L) {
            n_show   <- floor(fr_w / 20) -1
            show_lvs <- levels(x)[[id]][c(seq(n_show), num_lvs)]
            show_lvs <- c(show_lvs[seq(n_show)], "...", show_lvs[n_show+1])
            cat(
                ifelse(nchar(show_lvs) > 20,
                       paste0(substring(show_lvs, 1, 16), ".."),
                       show_lvs)
                ,
                "\n",
                sep = " "
            )
        } else {
            cat(levels(x)[[id]], "\n", sep = " ")
        }
    }
    invisible(NULL)
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

#' @export
#' @aliases subset.MultiFactor
#'
`subset.MultiFactor::MultiFactor` <- function(
        x, subset = NULL, by_path = TRUE, drop.unmatched = TRUE, ...
        ) {
    if(drop.unmatched) x <- .trimMultiFactor(x)
    if(is.null(subset)) return(x)
    if(by_path){
        if(inherits(subset, "formula")) {subset <- all.vars(subset)}
        stopifnot("Argument `subset` must be length 2 if by_path` is TRUE" =
                      length(subset) == 2L)
        subset <- termSeq(subset, x)
        # Determine required ids in order, keep relevant elements of MultiFactor
        return(subsetByPath(x, subset))
    } else `[`(x, subset)
}

#' @export
#'
method(subset, MultiFactor) <-
    function(x, subset = NULL, by_path = TRUE, ...)
        `subset.MultiFactor::MultiFactor`(x, subset, by_path)

