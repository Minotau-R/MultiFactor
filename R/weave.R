#' Weave a new LinkMap from a MultiFactor
#' @name weave.MultiFactor
#' @rdname weave-methods
#' @description
#' Generates a new `LinkMap` object by cross-referencing the elements of a
#'     given `MultiFactor`
#' @param x a `MultiFactor`
#' @param .by either a `formula` or a `character vector` of length 2 with the
#'     names of the desired combination of feature types.
#' @param out.format `Character scalar`. One of `'LinkMap'`, `'matrix'`.
#'
#' @returns a `LinkMap` or `sparse Matrix`.
#' @examples
#' # Generate pair of random linkage input
#' a2b <- data.frame(
#'    a = sample(letters[seq(3)], 10, replace = TRUE),
#'    b = sample(LETTERS[seq(3)], 10, replace = TRUE)
#' )
#' a2c <- data.frame(
#'     a = sample(letters[seq(3)], 10, replace = TRUE),
#'     c = sample(c("x", "y", "z"), 10, replace = TRUE)
#' )
#'
#' # Create MultiFactor
#' x <- MultiFactor(list(a2b, a2c))
#'
#' # Weave new b2c LinkMap
#' weave(x, b ~ c)
#' weave(x, b ~ a, out.format = "matrix")
NULL

#' @export
#'
S7::method(weave, MultiFactor) <- function(x, .by, out.format = c("LinkMap", "matrix")) {
    out.format <- match.arg(out.format, c("LinkMap", "matrix"))
    x <- MultiFactor(x)
    terms <- .by_terms(.by)

    #Stacking case
    if( any(lengths(terms) > 1L) ) {
        x <- .stack_by_character(x, terms[[1L]], terms[[2L]])
        if(out.format == "matrix") {
            res <- `as.matrix.MultiFactor::LinkMap`(res)
            dimnames(res) <- levels(x)[terms]
            return(res)
        } else
            if( out.format == "LinkMap" ) return(x)
    }
    # Non-stacking case
    terms <- unlist(terms)
    x <- subset(x, subset = .by, by_path = TRUE)
    # Determine required ids in order, only keep relevant elements of link.
    all_terms <- termSeq(terms, x)
    x <- subsetByPath(x, all_terms)

    # Construct dictionary
    res <- dictionaryMatrix(x, all_terms)

    # Check if we're done
    if(out.format == "matrix") {
        dimnames(res) <- levels(x)[terms]
        return(res)
    }
    # Otherwise, make a LinkMap
    res <- as.data.frame.matrix(Matrix::which(res, arr.ind = TRUE))
    res[] <- mapply(FUN = function(x, y) {
        attr(x, "levels") <- y
        `class<-`(x, "factor")
    }, x = res, y = levels(x)[terms], SIMPLIFY = FALSE )
    colnames(res) <- terms
    LinkMap(res)
}

# Utilities ----

#' Standardize terms
#' @returns a length 2 character vector of y, x.
#' @noRd
#'
.by_terms <- function(.by) {
    stopifnot(
        "'.by' must be a character vector or a formula." =
            inherits(.by, c("character", "formula"))
    )
    if(inherits(.by, "formula")) return(.weave_parse_formula(.by))

    if(inherits(.by, "character")) {
        if(length(.by == 2L)) return(.by) else stop(
            "Length of '.by' is must be exactly 2 using character input. ",
            "Use formula syntax for more control."
        )
    }
}

#' Combine LinkMaps by stacking features of multiple types.
#' @description
#' Utility to resolve multiple paths
#' @param x `MultiFactor`
#' @param stack_vars `Character vector` names of feature types to combine
#' @param to `Character scalar` name of feature type in right column of output.
#' @returns `LinkMap`
#' @noRd
#'
.stack_features <- function(x, stack_vars, to) {
    stopifnot(
        "At least two stacking targets must be found as colnames in 'x'" =
            sum(c(stack_vars) %in% colnames(x)) >= 2L
    )
    stopifnot(
        "'to' arg must be found in colnames of 'x'" = to %in% colnames(x)
        )

    var_list <- lapply(stack_vars, `c`, to)
    i <- vapply(var_list, rowsWithCol, d = x@map, names = FALSE, FUN.VALUE = 0L)
    var_list <- var_list[i > 0L]
    stack_name <- paste(stack_vars[i > 0L], collapse = "8")
    x_sub <- lapply(
        S7::S7_data(x)[i], function(y) {
            colnames(y)[colnames(y) != to] <- stack_name
            y
        }
    )
    LinkMap(
        do.call(rbind.data.frame, list(unname(x_sub), make.row.names = FALSE ))
        )

}


# Find a path through different feature types.
# returns a Character vector of the ids to walk in order.
#' @importFrom igraph shortest_paths
#'
termSeq <- function(terms, x) {
    stopifnot(
        "both terms must be found as colnames in 'x'" = all(
            terms %in% colnames(x)
        )
    )
    g <- igraph::graph_from_data_frame(
        d = t(vapply(x, names, c(NA_character_, NA_character_))),
        directed = FALSE
    )
    sp <- igraph::shortest_paths(
        g, from = terms[1], to = terms[2], output = "vpath")
    names(unlist(sp, FALSE, FALSE)[[1]])
}

#' Find the order in which link data frames should be listed
#' @param term_list list of `Character vectors`, each with length of two.
#' @param d link@map.
#' @returns a numeric vector with order in which row data frames should be
#'     traversed.
#' @noRd
#'
stepSeq <- function(term_list, d) vapply(
    term_list,
    FUN = rowsWithCol,
    d = d,
    names = FALSE,
    FUN.VALUE = 0L,
    USE.NAMES = FALSE
)

#' @param d `MultiFactor@map`
#' @param id `Character or Integer scalar`. Selects column(s) of `d`.
#' @param names Whether to return characters (Default) or integer indices.
#' @returns A vector indicating which elements of `MultiFactor` contain `id`.
#' @importFrom Matrix rowSums
#' @noRd
#' @description Helper function for `MultiFactor` to get names or indices of
#' data frames that contain an id column
#'
rowsWithCol <- function(d, id, names = TRUE) {
    rowInds <- which(Matrix::rowSums(d[, id, drop = FALSE] != 0L) == length(id))
    if (length(rowInds) == 0L) {
        return(0L)
    }
    if (names) {
        rowInds <- rownames(d)[rowInds]
    }
    return(rowInds)
}

subsetByPath <- function(link, all_terms) {
    term_list <- lapply(
        seq_len(length(all_terms) - 1L),
        FUN = function(x) all_terms[c(x, x + 1L)]
    )
    steps <- stepSeq(term_list, link@map)
    link <- link[steps]
    return(link)
}

#' Generate dictionary Matrix from link input
#' @inheritParams weaveWeb
#' @param all_terms `Character vector` of all path terms in sequence.
#'     `termSeq(x, y, link)`
#' @importMethodsFrom Matrix %&%
#' @noRd
#'
dictionaryMatrix <- function(link, all_terms) {
    term_list <- lapply(
        seq_len(length(all_terms) - 1L),
        FUN = function(x) all_terms[c(x, x + 1L)]
    )
    steps <- stepSeq(term_list, link@map)
    lv_len <- nlevels(link, use.names = TRUE)

    # Handle simple case of one link df first, return sparse matrix.
    if (length(steps) == 1L) {
        return(`as.matrix.MultiFactor::LinkMap`(
            x = S7::S7_data(link)[[steps]],
            terms = all_terms,
            dims = lv_len[all_terms]
        ))
    }
    lv_list <- lapply(term_list, function(x) lv_len[x])
    # Otherwise, make a list of matrices to Reduce to final dictionary
    mat_list <- mapply(
        FUN = `as.matrix.MultiFactor::LinkMap`,
        x = S7::S7_data(link)[steps],
        terms = term_list,
        dims = lv_list
    )
    Reduce(Matrix::`%&%`, mat_list)
}

