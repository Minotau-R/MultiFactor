#' Weave a new LinkMap from a MultiFactor
#' @name weave
#' @description
#' Generates a new `LinkMap` object by cross-referencing the elements of a
#'     given `MultiFactor`
#' @param x a `MultiFactor`
#' @param .by either a `formula` or a `character vector`` of length 2 with the
#'     names of the desired combination of feature types.
#' @returns a `LinkMap`
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
#' @export
#'
weave <- function(x, .by = NULL) {

    # Ensure link is a MultiFactor
    x <- subset(x, subset = .by, by_path = TRUE)
    terms <- if(inherits(.by, "formula")) all.vars(.by) else .by
    # Determine required ids in order, only keep relevant elements of link.
    all_terms <- termSeq(terms, x)
    x <- subsetByPath(x, all_terms)

    # Construct dictionary
    res <- dictionaryMatrix(x, all_terms)
    res <- as.data.frame.matrix(Matrix::which(res, arr.ind = TRUE))
    res[] <- mapply(FUN = function(x, y) {
        attr(x, "levels") <- y
        `class<-`(x, "factor")
    }, x = res, y = levels(x)[terms], SIMPLIFY = FALSE )
    colnames(res) <- terms
    LinkMap(res)
}

# Utilities ----

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
    name = FALSE,
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
        return(NULL)
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
    lv_len <- vapply(X = levels(link), FUN = length, 0L, USE.NAMES = TRUE)

    # Handle simple case of one link df first, return sparse matrix.
    if (length(steps) == 1L) {
        return(mapFromLink(
            all_terms,
            df = S7::S7_data(link)[[steps]],
            dims = lv_len[all_terms]
        ))
    }
    lv_list <- lapply(term_list, function(x) lv_len[x])
    # Otherwise, make a list of matrices to Reduce to final dictionary
    mat_list <- mapply(
        FUN = mapFromLink,
        terms = term_list,
        df = S7::S7_data(link)[steps],
        dims = lv_list
    )
    Reduce(Matrix::`%&%`, mat_list)
}

#' @param terms id of cols. `c(y, x)`.
#' @param df element of a `MultiFactor` object
#' @param dims length-2 integer vector of matrix dimensions.
#' @importFrom Matrix sparseMatrix
#' @returns a sparse biadjacency Matrix
#' @noRd
#'
mapFromLink <- function(terms, df, dims) {
    Matrix::sparseMatrix(i = df[[terms[1]]], j = df[[terms[2]]], dims = dims)
}
