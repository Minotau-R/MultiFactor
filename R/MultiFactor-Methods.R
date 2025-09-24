
method(str, MultiFactor) <- function(object, ...) {
    Matrix::printSpMatrix(object@map)
    str(levels(object))
}

method(levels, MultiFactor) <- function(x) {
    lvs <- unlist(unname(lapply(x, levels)), recursive = FALSE)
    lvs[!duplicated(names(lvs))]
}
