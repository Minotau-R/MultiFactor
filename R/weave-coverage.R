#' Perform enrichtment analysis from a weave
#' @param x `MultiFactor` with two `LinkMap` objects, the first one representing
#'     "seen" features and second the "full" set.
#' @param observed `list` with one `named character vector`. Name indicated
#'     feature type, content indicates observed features of said type.
#' @param set `character` name of the data type to be used as set.
#' @param alternative `Character scalar` indicates the alternative hypothesis
#'     and must be one of "two.sided", "greater" or "less".
#' @param raw `Boolean scalar`. Whether to return the 'untidy' list or call
#'     `broom::tidy` on the result (default).
#' @returns a data.frame containing enrichment ratios and p-value following a
#'     hypergeometric test. see ?phyper
#' @importFrom broom tidy
#' @importFrom stats fisher.test
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
#' weave(x, a ~ b ~ c) |>
#'     #test_set_enrichment()
#' @noRd
test_set_enrichment <- function(
        x, observed = NULL, set = NULL, alternative = "greater", raw = FALSE
        ) {
    stopifnot(
        "x must be a MultiFactor" = inherits(x, "MultiFactor::MultiFactor")
    )
    if(is.null(observed)) {
        stopifnot(
            "If 'observed' is missing 'x' must have two LinkMaps" =
                length(x) == 2L
        )
        param_df <- .weave_contingency_params(x)
    } else {

        param_df <- .char_contingency_params(x, observed, set)
    }

    cont_mats <- apply(param_df, 1L, .as_cont_matrix, simplify = FALSE)
    res <- lapply(cont_mats, fisher.test, alternative = alternative)
    if(!raw) res <- dplyr::bind_rows(lapply(res, broom::tidy), .id = "term")

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
#'
.weave_summarize_links <- function(
        x, all_terms, metric = c("count", "coverage", "complete")
        ) {
    metric <- match.arg(metric, c("count", "coverage", "complete"))
    seen <- x[[1L]]
    full <- x[[2L]]
    # All steps in order
    from <- all_terms[[1L]]
    shared <- all_terms[[2L]]
    to <- all_terms[[3L]]

    # Ensure LinkMap order
    shared2from <- as.matrix(seen[, c(shared, from)])
    shared2to <- as.matrix(full[, c(shared, to)])
    # Link observed features to sets
    res <- Matrix::crossprod(
        shared2to, shared2from != 0L
    )
    if(metric != "count") tot_set <- pmax(Matrix::colSums(shared2to), 1L)
    if(metric == "coverage") res <- res/tot_set
    if(metric == "complete") res <- res == tot_set

    res <- Matrix::t( Matrix::Matrix( res, sparse = TRUE ) )
    return(res)
}


# .weave_calc_coverage <- function(seen, full, to, from, shared) {
#     # Ensure LinkMap order
#     shared2from <- as.matrix(seen[, c(shared, from)])
#     shared2to <- as.matrix(full[, c(shared, to)])
#     # Link observed features to sets
#     Matrix::Matrix(
#         Matrix::crossprod(shared2to, shared2from!=0L) /
#             Matrix::colSums(shared2to),
#         sparse = TRUE
#     )
# }
#


