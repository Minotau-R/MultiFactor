#' Generate a random MultiFactor or LinkMap
#' @name randomMultiFactor
#' @description
#' Randomly generate a valid `MultiFactor` or `LinkMap` object.
#' @returns a randomly generated object of the specified class.
#' @examples
#' # Make a random MultiFactor object
#' randomMultiFactor()
#'
#' # Make a random LinkMap object
#' randomLinkMap()
#'
#' @seealso [MultiFactor()]
#' @seealso [LinkMap()]
#'
NULL

#' @rdname randomMultiFactor
#' @name randomMultiFactor
#' @param n_types `Numeric scalar`, number of types of features to generate
#' @param n_features `Numeric scalar`, number of features per type
#' @param sparseness `Numeric scalar`, proportion: How rare are connections
#' @export
#'
randomMultiFactor <- function(n_types = 6, n_features = 100, sparseness = 0.5) {
    stopifnot(
        "'sparseness' must be a proportion [0-1]. " = sparseness <= 1 &&
            sparseness > 0
    )
    n_types <- max(min(n_types, 26), 2)
    ids <- letters[seq_len(n_types)]
    out_names <- paste0(ids[-n_types], "2", ids[-1L])
    id_list <- lapply(ids, function(x) {
        paste(
            x,
            formatC(seq_len(n_features), digits = 2, flag = "0"),
            sep = "_"
        )
    })

    out <- lapply(seq_len(n_types - 1), FUN = function(x) {
        randomLinkMap(
            x = `names<-`(
                list(id_list[-n_types][[x]],
                     id_list[-1L][[x]]),
                c(ids[-n_types][x],ids[-1L][x])
                ),
            sparseness = sparseness
        )
    })
    names(out) <- out_names
    MultiFactor(out)
}

#' @rdname randomMultiFactor
#' @name randomLinkMap
#' @description called by `randomMultiFactor`, shouldn't be called by user.
#' @param x optional list of two named vectors of features to use. Default is
#'     `list(lower = letters, UPPER = LETTERS)`.
#' @param sparseness `Numeric scalar`, proportion: How rare are connections.
#'     Default is `0.5`.
#' @export
#'
randomLinkMap <- function(
        x = list(lower = letters, UPPER = LETTERS),
        sparseness = 0.5
        ){
stopifnot("If provided, 'x' must be a list of two named character vectors" =
              is.list(x) && length(names(x)) == 2L
          )
    stopifnot(
        "'sparseness' must be a proportion [0-1]. " = sparseness <= 1 &&
            sparseness > 0
    )
    LinkMap(randomLinkDF(
        x[[1]], x[[2]], names(x)[[1]], names(x)[[2]],
        p = 1 - sparseness
        ))

}


#' Make a single df for a random MultiFactor
#' @rdname randomMultiFactor
#' @description called by `randomMultiFactor`, shouldn't be called by user.
#' @param l,r character vector of left, right features
#' @param l_id,r_id character scalar of left, right feature names
#' @param p proportion of connections to keep
#' @noRd
#'
randomLinkDF <- function(l, r, l_id, r_id, p) {
    len <- length(l) * length(r)
    ind <- sort(sample(seq_len(len), size = ceiling(p * len)))
    out <- expand.grid(l, r, KEEP.OUT.ATTRS = FALSE)[ind, ]
    names(out) <- c(l_id, r_id)
    out
}
