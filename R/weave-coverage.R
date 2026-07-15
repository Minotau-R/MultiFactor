#' Perform enrichtment analysis from a weave
#' @param x a `MultiFactor`
#' @param .path Either a `formula` or a `character vector` of length 2 with the
#'     names of the desired combination of feature types.
#' @param .data Optional `Character vector`. Lists observed features from the
#'     found within the first element of `.path`. Alternatively, a `data.frame`
#'     with the same information. (Also see `.data_column` argument).
#' @param metric `Character scalar`.
#'     One of `'count'`, `'coverage'`, `'complete'`.
#' @param out.format `Character scalar`.
#'     One of `'LinkMap'`, `'matrix'`.
#' @param .data_column `Character scalar`. if `.data` is a table, where to find
#'     feature IDs
#' @returns a `LinkMap` or `matrix` with the desired coverage information in
#'     the @metadata slot.
#' @export
#' @examples
#' set.seed(2612)
#' # Draw five cards from a deck
#' drawn  <- draw_cards(5)
#' drawn
#' scores <- poker_scores()
#' scores
#'
#' # Now enrich input
#' result <- weave_coverage(
#'     x = scores, .path = card ~ suit, .data = drawn, metric = "count"
#' )
#'
#' result
#'
#' # Now let's spike a hand
#' cheat <- draw_cards()[c(1, 10, 11, 12, 13)]
#' cheat
#'
#' .path = c("card", "rank", "straight")
#' weave_coverage(scores, c("card", "rank", "straight"), .data = cheat)
#'
weave_coverage <- function(
        x, .path, .data = NULL,
        metric = c("count", "size", "coverage", "complete"),
        out.format = c("LinkMap", "matrix"), .data_column = "row.names"
) {
    metric <- match.arg(
        metric, c("count", "size", "coverage", "complete"),
        several.ok = TRUE
    )
    out.format <- match.arg(out.format, c("LinkMap", "matrix"))

    path_check <- .check_path(.path)

    if(path_check[["complex"]]) {
        stop("weave_coverage() '.path' cannot contain '+'.\n",
             "Use stack() to prepare input.")
    }

    full_path <- .path_ordinary_to_full(x, .path)[[1L]]

    stopifnot(
        "weave_coverage() '.path' must be 2 or 3 steps long." =
            length(full_path) %in% c(2L, 3L)
    )
    x <- subsetByPath(x, full_path)

    .data <- .data_coverage_to_vector(.data, .data_column)
    if( length(full_path) == 2L ) {
        res <- .weave_coverage_two(x, full_path, .data, metric, out.format)
    } else if( length(full_path) == 3L ) {
        res <- .weave_coverage_three(x, full_path, .data, metric, out.format)
    }

    return(res)


}


.weave_contingency_params <- function(x) {
    shared <- do.call(intersect, unname(lapply(x, names)))
    stopifnot( "LinkMaps must share exactly one column" = length(shared) == 1L )

    # Prepare params
    seen <- x[[1L]]
    full <- x[[2L]]
    from <- setdiff(names(seen), shared)
    to <- setdiff(names(full), shared)
    # Ensure order
    if(names(full)[2L] == shared) full <- full[,c(2L, 1L)]

    to_from <- weave(x, reformulate(to, from))

    hits <- weave(
        MultiFactor(list( to_from, seen )),
        reformulate(to, shared)
    )

    q <- tapply(X = hits, INDEX = reformulate(to), FUN = NROW)
    m <- tapply(X = full, INDEX = reformulate(to), FUN = NROW)
    n <- nlevels(full)[[to]] - m
    k <- length( unique(hits[[1L]]) )

    data.frame(q, m, n, k)
}

.char_contingency_params <- function(x, observed, set) {
    stopifnot("'observed' must be a named list" = length(names(observed)) == 1L)

    shared <- names(observed)
    to <- set
    stopifnot(
        "Both set and observed must be found in 'x'" =
            all(c(shared, set) %in% colnames(x))
    )
    full <- weave(x, reformulate(to, shared))
    hits <- full[full[[shared]] %in% observed[[1L]] ,]

    q <- tapply(X = hits, INDEX = reformulate(to), FUN = NROW)
    m <- tapply(X = full, INDEX = reformulate(to), FUN = NROW)
    n <- nlevels(full)[[to]] - m
    k <- length( unique(hits[[1L]]) )

    data.frame(q, m, n, k)
}

.as_cont_matrix <- function(x) {
    q <- x[1L]
    m <- x[2L]
    n <- x[3L]
    k <- x[4L]

    matrix(c(q, m-q, k-q, n-(k-q)), 2, 2)

}




#' @importFrom Matrix crossprod colSums t
#' @importFrom S7 S7_data
#'
#' @noRd
#' @examples
#' x <- randomMultiFactor()[seq_len(2L)]
#' at <- c("a", "b", "c")
#' x.cov <- .weave_coverage_three(x, all_terms = at, metric = "coverage")
#' x.cnt <- .weave_coverage_three(x, all_terms = at, metric = "count")
#' x.cpt <- .weave_coverage_three(x, all_terms = at, metric = "complete")
#'
#' x.cov@metadata
#' x.cnt@metadata
#' x.cpt@metadata
#'
.weave_coverage_three <- function(
        x, all_terms, .data, metric, out.format
) {
    # All steps in order
    from <- all_terms[[1L]]
    shared <- all_terms[[2L]]
    to <- all_terms[[3L]]

    seen <- x[[rowsWithCol(x@map, c(shared, from))]]
    full <- x[[rowsWithCol(x@map, c(shared, to))  ]]

    # Ensure LinkMap order
    shared2from <- as.matrix(seen, terms = c(shared, from))
    shared2to <- as.matrix(full, terms = c(shared, to))

    if( length(.data) ) { shared2from <- shared2from[, .data] }
    # Link observed features to sets
    res <- Matrix::crossprod( shared2to, shared2from != 0L )
    res <- Matrix::t(Matrix::Matrix( res, sparse = TRUE ))
    obs_set <- Matrix::colSums(res)

    tot_set <- pmax(Matrix::colSums(shared2to), 1L)

    metadata <- data.frame(
        count    = obs_set,
        size     = tot_set,
        coverage = obs_set / tot_set,
        complete = obs_set == tot_set
    )

    if( out.format == "LinkMap" ) {
        res <- .res_weave_matrix_to_LinkMap(res, levels(x)[c(from, to)])
        metadata <- metadata[as.integer(res[[to]]), metric]
        res <- LinkMap(res, metadata)
    } else if (out.format == "matrix") {
        res@x <- metadata[as.integer(res[[to]]), metric]
    }
    return(res)
}

#' @importFrom Matrix colSums
#'
.weave_coverage_two <- function(
        x, all_terms, .data, metric, out.format
) {
    set_unit <- all_terms[[1L]]
    set_full <- all_terms[[2L]]
    x.lm <-x[[1L]]
    bg <- `class<-`(S7::S7_data(x.lm), "data.frame")
    if( length(.data) ) {
        obs <- bg[bg[[set_unit]] %in% .data , ]
    } else {
        obs <- bg
    }
    tot_set <- pmax.int(
        c(tapply(bg, INDEX = reformulate(set_full), FUN = NROW)), 1L
        )
    obs_set <- c(tapply(obs, INDEX = reformulate(set_full), FUN = NROW))
    val <- data.frame(
        count    = obs_set,
        size     = tot_set,
        coverage = obs_set / tot_set,
        complete =  obs_set == tot_set
    )[metric]

    metadata <- val[match(bg[[set_full]], row.names(val)), , drop = FALSE]
    row.names(metadata) <- NULL
    res <- LinkMap(x.lm, metadata)

    if( out.format == "matrix" ) {
        res <- `as.matrix.MultiFactor::LinkMap`(res, value_id = metric[[1L]])
    }
    return(res)
}
