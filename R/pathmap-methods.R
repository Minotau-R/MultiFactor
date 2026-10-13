.new_pathmap <- function(x) PathMap(as.LinkMap(x))

S7::method(formula, PathMap) <- function(x) `formula.MultiFactor::PathMap`(x)

#' @export
#'
`formula.MultiFactor::PathMap` <- function(x, ...) {
    x <- as.data.frame(x)
    out_len <- 1 + 2*NROW(x)
    res <- rep("~", out_len )
    res[seq_len(out_len) %% 2 == 1L] <- `terms.MultiFactor::PathMap`(x)

    if("coverage" %in% colnames(x)) {
        res[seq_len(out_len) %% 2 == 0L][x[["coverage"]] != 0L] <- ":"
    }

    res <- paste0(res, collapse = "")

    stats::as.formula(res, globalenv())

}

S7::method(terms, PathMap) <- function(x) `terms.MultiFactor::PathMap`(x)

#' @export
`terms.MultiFactor::PathMap` <- function(x, ...) as.character(
        c(x[[1L]], x[[2L]][NROW(x)])
    )

S7::method(print, PathMap) <- function(x, ...) {
    from_to <- terms(x)[c(1, NROW(x) + 1L)]

    if( has_comps <- "components" %in% colnames(S7::prop(x, "metadata")) ) {

        m <- as.data.frame(x)

        p <- tapply(
            m, ~components, `formula.MultiFactor::PathMap`, simplify = FALSE
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
