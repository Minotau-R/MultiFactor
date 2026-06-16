#' Define a path through a MultiFactor object.
#' @rdname select_path
#' @name select_path
#' @inheritParams weave-methods
#' @param as.edges `Boolean scalar` Whether to return names of edges or nodes
#'     (Default) in the path.
#' @returns a list of character vectors.
#' @importFrom igraph as_ids
#' @examples
#' #' # Generate pair of random linkage input
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
#' # Inspect a path between data types
#' select_path(x, b ~ c)
#' @export
#'
select_path <- function(
        x, .by, include = NULL, exclude = NULL, exact = NULL, as.edges = FALSE
) {
    paths <- .select_path(x, .by_terms(.by), include, exclude, exact)

    if( as.edges ) paths <- lapply(paths, .V_path_as_E_path)
    return(paths)
}

.select_path <- function(
        x, terms, include = NULL, exclude = NULL, exact = NULL
) {
    g <- `as.igraph.MultiFactor::MultiFactor`(x)
    g <- .subset_paths(g, include, exclude, exact)
    # Use apply + unlist to support multiple variables on either side of .by
    term.grid <- expand.grid(as.list(terms))
    if( !is.null(include) ) {
        paths <- .shortest_path_include(term.grid, g, include)
    } else {
        paths <- apply( term.grid, 1L, .apply_shortest_ps, g )
        paths <- lapply( unlist(paths, FALSE, FALSE), as_ids )
    }
}

.subset_paths <- function(g, include, exclude, exact) {
    # Defenses
    if( length(dupes <- intersect(include, exclude)) != 0L ) stop(
        "Cannot 'include' and 'exclude' simultaneously: ",
        paste(dupes, collapse = ", "), "."
    )
    if( !is.null(exact) ) stopifnot(
        "If 'exact' is specified, 'include' and 'exclude' must be NULL." =
            all( is.null(include), is.null(exclude) )
    )

    g <- .filter_exclude_edges(g, exclude)

    if( !is.null(exact) ) {
        g <- .filter_exact_edges(g, exact)
        .path_in_graph(exact, g, error = TRUE)
        }

    return(g)
}

#' @importFrom igraph induced_subgraph
#'
.filter_exclude_edges <- function(x, exclude) {
    # Only do work if exclude is not NULL
    if( is.null(exclude) ) return(x)
    igraph::induced_subgraph(x, setdiff(.V_names(x), exclude))
}

#' @importFrom igraph V induced_subgraph
#'
.filter_exact_edges <- function(x, exact) {
    # Only do work if exclude is not NULL
    if( is.null(exact) ) return(x)
    if( any(miss <- ! exact %in% .V_names(x)) ) stop(
        "Elements of 'exact' not found: ",
        paste(.V_names(x)[miss], collapse = ", "), "."
    )
    igraph::induced_subgraph(x, exact)
}

#' @importFrom igraph as_ids V
#'
.V_names <- function(x) igraph::as_ids(igraph::V(x))

#' @importFrom igraph as_ids E
#'
.E_names <- function(x) igraph::as_ids(igraph::E(x))

.path_in_graph <- function(x, g, error = FALSE) {
    in_graph <- .V_path_as_E_path(x) %in% .E_names(g)

    if( error && !all(in_graph) ) stop(
        "Defined path contains vertices not found in graph: '",
        paste(.V_path_as_E_path(x)[!in_graph], collapse = "', '"),
        "'."
    )
    return(all(in_graph))
}

.V_path_as_E_path <- function(x) vapply(
    seq_len(length(x) -1L), function(i) paste0(x[i], "|", x[i + 1L]), ""
)


.shortest_path_include <- function(x, g, include) {
    head_term <- as.character(unique(x[[1L]]))
    tail_term <- as.character(unique(x[[2L]]))
    p_head <- .shortest_path_incl_head(g, include[[1L]], head_term)
    p_tail <- .shortest_path_incl_tail(g, include[[length(include)]], tail_term)
    if( length(include) == 1L ) {
        res_path <- mapply(c, p_head, p_tail, SIMPLIFY = FALSE)
    } else {
        p_include <- .shortest_path_incl_multiples(g, include)
        res_path <- mapply(c, p_head, p_include, SIMPLIFY = FALSE)
        res_path <- mapply(c, res_path, p_tail, SIMPLIFY = FALSE)
    }
    return(res_path)
}

#' @importFrom igraph all_shortest_paths as_ids
.shortest_path_incl_head <- function(g, i, start_term) {
    lapply(
        igraph::all_shortest_paths(g, from = i, to = start_term)[["vpaths"]],
        function(x) rev(igraph::as_ids(x))
    )
}

#' @importFrom igraph all_shortest_paths as_ids
.shortest_path_incl_tail <- function(g, i, final_term) {
    lapply(
        igraph::all_shortest_paths(g, from = i, to = final_term)[["vpaths"]],
        function(x) igraph::as_ids(x)[-1L]
    )
}

#' @importFrom igraph all_shortest_paths as_ids
#'
.shortest_path_incl_multiples <- function(g, i) {
    inter_paths <- lapply(
        seq_len(length(i) -1L),
        function(x) lapply(
            igraph::all_shortest_paths(
                g, from = i[[x]], to = i[[x + 1L]]
            )[["vpaths"]], function(y) igraph::as_ids(y)[-1L]
        )
    )
    res_path <- inter_paths[[1L]]
    for( p in seq_len(length(inter_paths) -1L)) {
        res_path <- mapply(
            c, res_path, inter_paths[[p + 1L]], SIMPLIFY = FALSE
        )
    }
    return(res_path)

}



.apply_shortest_ps <- function(terms, g) {
    igraph::all_shortest_paths(
        g, from = terms[1], to = terms[2]
    )[["vpaths"]]
}


.weave_mult <- function(x, terms, out.format) {
    res <- apply(
    expand.grid(terms), 1L, .weave_ordinary_terms_df,
    x = x, out.format = out.format, simplify = FALSE
    )
    if(out.format == "LinkMap") {
        cn <- vapply(lapply(terms, unique), paste, collapse = ".", "")
        res <- do.call( rbind.data.frame, lapply(res, `colnames<-`, cn) )
        res <- LinkMap(res)
    }
    return(res)
    }



.weave_ordinary_terms_df <- function(df, x, out.format) .weave_ordinary_terms(
    x, c(df[seq_len(2L)]), out.format
)


# Utilities ----


# Find a path through different feature types.
# returns a Character vector of the ids to walk in order.
#' @importFrom igraph shortest_paths graph_from_data_frame
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
    sp <- igraph::all_shortest_paths(
        g, from = terms[1], to = terms[2])
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
#' @param link `MultiFactor`
#' @param all_terms `Character vector` of all path terms in sequence.
#'     `termSeq(x, y, link)`
#' @importMethodsFrom Matrix %&%
#' @noRd
#'
.weave_to_dictionary_matrix <- function(link, all_terms) {
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


