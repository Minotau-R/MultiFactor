#' Generate a random MultiFactor or LinkMap
#' @name randomMultiFactor
#' @description
#' Randomly generate a valid `MultiFactor` or `LinkMap` object.
#' `randomMultiFactor` can optionally take am `igraph` object to determine its
#' layout. (See examples)
#' `trade_posts()` generates a random `MultiFactor` in the style of the trading
#' example from the vignette.
#' @returns a randomly generated object of the specified class.
#' @examples
#' # Make a random MultiFactor object
#' randomMultiFactor()
#'
#' # Use a (possibly random) igraph as input:
#' randomMultiFactor( igraph::sample_gnp(6, 2/3) )
#'
#' # Make a random LinkMap object
#' randomLinkMap()
#'
#' # Make a random MultiFactor with the trading goods from the vignettes
#' trade_posts()
#' @seealso [MultiFactor()]
#' @seealso [LinkMap()]
#'
NULL

#' @rdname randomMultiFactor
#' @name randomMultiFactor
#' @param layout `igraph`, optional graph structure to generate random data for
#' @param n_features `Numeric scalar`, number of features per type
#' @param sparseness `Numeric scalar`, proportion: How rare are connections
#' @importFrom igraph as_edgelist
#' @export
#'
randomMultiFactor <- function(layout = NULL, n_features = 10, sparseness = 0.75) {
    stopifnot(
        "'sparseness' must be a proportion [0-1]." =
            sparseness <= 1 && sparseness > 0
    )
    if(is.null(layout)) {
        res <- .randomMultiFactor.auto( n_features, sparseness )
    } else {
    res <- .randomMultiFactor.layout( layout, n_features, sparseness )
    }
    return(res)
}


.randomMultiFactor.layout <- function(layout, n_features, sparseness) {
    stopifnot("'layout' must be an igraph object." = inherits(layout, "igraph"))
    el <- igraph::as_edgelist(layout)
    edge_names <- unique(c(el))
    if(is.numeric(edge_names)) edge_names <- paste0("v", edge_names)
    lv_list <- .feature_names(edge_names, n_features)
    names(lv_list) <- edge_names
    out <- apply(el, 1L, function(i) randomLinkMap(
        lv_list[c(i[1], i[2])], sparseness = sparseness
    ), simplify = FALSE
    )

    names(out) <- apply(el, 1L, paste, collapse = "2")
    return( MultiFactor(out, levels = lv_list) )

}

#' @rdname randomMultiFactor
#' @name trade_posts
#' @param raw.data `Boolean`, Whether to return the `data.frame` of goods rather
#' than the default `MultiFactor`.
#' @importFrom igraph as_edgelist sample_gnm
#' @export
#'
trade_posts <- function(raw.data = FALSE) {
    # Small dummy data; six factors of length six
    trade_goods <- .load_trade_goods()
    # Finish immediately if raw.data is toggled.
    if(raw.data) return(trade_goods)
    # Split and trim row.names
    trade_goods <- tapply(
        trade_goods[, -4], trade_goods[, 4], `rownames<-`, NULL
        )
    layout <- igraph::sample_gnm(length(trade_goods), length(trade_goods))

    el <- igraph::as_edgelist(layout)

    out <- apply(el, 1L, function(i) randomLinkMap(
        trade_goods[c(i[1], i[2])], sparseness = 3/4
    ), simplify = FALSE
    )

    MultiFactor(out, levels = lapply(trade_goods, `[[`, "name"))

}


#' @importFrom utils data
.load_trade_goods <- function() local({
    utils::data("trade_goods", package = "MultiFactor", envir = environment())
    trade_goods <- get("trade_goods")

    return(trade_goods)
})

.randomMultiFactor.auto <- function(n_features, sparseness) {
    n_types <- 6
    ids <- letters[seq_len(n_types)]
    out_names <- paste0(ids[-n_types], "2", ids[-1L])
    id_list <- .feature_names(ids, n_features)

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
    names(id_list) <- ids

    return( MultiFactor(out, levels = id_list) )
}

.feature_names <- function(y, n_features) lapply(y, function(x) {
    paste0( x, "_", formatC(seq_len(n_features), digits = 2, flag = "0") )
})

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
    LinkMap(.randomLinkDF(
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
.randomLinkDF <- function(l, r, l_id, r_id, p) {
    # Ensure l and r are data.frames with properly named columns
    if( NCOL( l <- data.frame(l) ) == 1L ) {
        colnames(l) <- l_id
    } else {
        colnames(l) <- c( l_id, paste(l_id, colnames(l)[-1], sep = "_") )
    }
    if( NCOL( r <- data.frame(r) ) == 1L ) {
        colnames(r) <- r_id
    } else {
        colnames(r) <- c( r_id, paste(r_id, colnames(r)[-1], sep = "_") )
    }

    ind <- expand.grid( seq_len(NROW(l)), seq_len(NROW(r)) )
    len <- NROW(ind)
    keep <- sort(sample(seq_len(len), size = ceiling(p * len)))
    ind <- ind[keep, ]

    out <- data.frame(
        l[ind[["Var1"]], , drop = FALSE],
        r[ind[["Var2"]], , drop = FALSE]
        )
    # Rearrange columns
    if( NCOL(l) > 1 ) {
        r_idx <- 1 + NCOL(l)
        if( NCOL(r) == 1L ) {
            col.order <- c( 1, r_idx, seq(from = 2, to = NCOL(l)) )
        } else {
            col.order <- c(
                1, r_idx, seq(from = 2, to = NCOL(l)),
                seq(from = r_idx + 1L, to = NCOL(out))
            )
        }
        out <- out[, col.order]
    }
    return(out)
}
