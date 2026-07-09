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
#' # Generate random data
#' x <- randomMultiFactor(n_features = 20)
#'
#' # Spike in a lower number of a observations
#' x <- MultiFactor(
#'     list(x[[1]][sample(size = 5, 1:NROW(x[[1]])),], x[[2]])
#' )
#'
#' # Now enrich test input
#' weave_coverage(x, a ~ b ~ c)
#'
weave_coverage <- function(
        x, .path, .data = NULL, metric = c("count", "coverage", "complete"),
        out.format = c("LinkMap", "matrix"), .data_column = "row.names"
) {
    metric <- match.arg(metric, c("count", "coverage", "complete"))
    out.format <- match.arg(out.format, c("LinkMap", "matrix"))

    .p_check <- .check_path(.path)

    if(.p_check["vars"] == "complex") {
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
    res <- .calc_coverage(res, bg = shared2to, metric)

    if( out.format == "LinkMap" ) {
        val <- data.frame(res@x)
        colnames(val) <- metric
        res <- .res_weave_matrix_to_LinkMap(res, levels(x)[c(from, to)])
        res <- LinkMap(res, metadata = val)
    }
    return(res)
}

.weave_coverage_two <- function(
        x, all_terms, .data, metric, out.format
) {
    bg <- as.matrix(x[[1L]], terms = all_terms)
    if( length(.data) ) {
        obs <- bg[.data, ]
    } else {
        obs <- bg
    }
    res <- .calc_coverage(obs, bg, metric)
    if( out.format == "LinkMap" ) {
        val <- data.frame(res@x)
        colnames(val) <- metric
        res <- .res_weave_matrix_to_LinkMap(res, levels(x)[all_terms])
        res <- LinkMap(res, metadata = val)
    }
    return(res)
}

#' res (observed) and bg (background) are two sparse matrices.
#' @noRd
#' @importFrom Matrix colSums t Matrix
#'
.calc_coverage <- function(res, bg, metric) {
    if( metric != "count" ) tot_set <- pmax(Matrix::colSums(bg), 1L)
    if( metric == "coverage" ) res <- res/tot_set
    if( metric == "complete" ) res <- res == tot_set

    res <- Matrix::t( Matrix::Matrix( res, sparse = TRUE ) )
    return(res)
}


# Legacy
# path_coverage <- function(x, path, out.format = "matrix") {
#     # rename to all_terms for internal consistency with .weave_*
#     all_terms <- path
#     # tolerate single path result in list
#     if(length(all_terms) == 1L && is.list(all_terms)) all_terms <- all_terms[[1L]]
#     stopifnot(
#         "'path' must be a character vector of steps to take, in order." =
#             is.character(all_terms)
#     )
#     stopifnot(
#         "All entries in 'path' must be found in colnames(x)." =
#             all( all_terms %in% colnames(x) )
#     )
#     stopifnot("length( path ) must be 3." = length( all_terms ) == 3L )
#
#     x <- subsetByPath(x, all_terms)
#     terms <- all_terms[c(1L, length(all_terms))]
#     # Compute coverage
#     res <- .weave_coverage_three(x, all_terms, .data, "coverage")
#
#     # Check if we're done
#     if(out.format == "matrix") {
#         dimnames(res) <- levels(x)[terms]
#         return(res)
#     }
#     # Otherwise, make a LinkMap
#     res <- .res_weave_matrix_to_LinkMap(res, levels(x)[terms])
#
#     return(res)
#
# }
