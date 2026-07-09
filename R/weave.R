#' Weave a new LinkMap from a MultiFactor
#' @name weave-methods
#' @rdname weave-methods
#' @description
#' Generates a new `LinkMap` object by cross-referencing the elements of a
#'     given `MultiFactor`. Elements can be merged by including several names,
#'     separated by the plus (`+`) sign. See examples.
#' @param x a `MultiFactor`
#' @param .path Either a `formula` or a `character vector` of length 2 with the
#'     names of the desired combination of feature types.
#' @param out.format `Character scalar`. One of `'LinkMap'`, `'matrix'`.
#' @param include,exclude,exact `Character vectors` Should feature types be
#'     included or excluded from the available paths? Exact allows for exact
#'     path definition.
#' @returns a `LinkMap` or `sparse Matrix`.
#' @examples
#' # Generate a random MultiFactor
#' x <- randomMultiFactor()
#'
#' # Weave new b2c LinkMap
#' weave(x, b ~ c)
#' weave(x, b ~ a, out.format = "matrix")
#'
NULL

#' @export
#'
S7::method(weave, MultiFactor) <- function(
    x, .path, out.format = c("LinkMap", "matrix"),
    include = NULL, exclude = NULL, exact = NULL
) {
  out.format <- match.arg(out.format, c("LinkMap", "matrix"))
  lv_list <- levels(x)

  .p_check <- .check_path(.path)

  if(.p_check["vars"] == "complex") {
    stop("weave() '.path' cannot contain '+'. Use stack() to prepare input.")
  }
    full_path <- .path_ordinary_to_full(x, .path)[[1L]]
    res <- .weave_full_path(x, full_path, out.format)

  if( out.format == "LinkMap" ) {
    res <- LinkMap(res)
  }

  return(res)
}


weave_along_path <- function(x, path, out.format = "LinkMap") {
  # tolerate single path result in list
  if(length(path) == 1L) path <- path[[1L]]
  stopifnot(
    "'path' must be a character vector of steps to take, in order." =
      is.character(path)
  )
  stopifnot(
    "All entries in 'path' must be found in colnames(x)." =
      all( path %in% colnames(x) )
  )
  res <- .weave_full_path(x, path, out.format)
  # Remove duplicates
  if(out.format == "LinkMap") {
    res <- res[ !duplicated(res[, seq_len(2L)]), ]
  }
  res
}


.weave_complex_formula <- function(x, .path, out.format) {
  .path_list <- .path_prep_complex(.path)
  res <- lapply( .path_list, weave, x = x, out.format = out.format )
}

.weave_complex_formula_lvs <- function(x, lv_list) {
  new_lvs <- .build_levels_from_linkmap_list(x)
  new_names <- names(new_lvs)
  kept <- intersect(new_names, names(lv_list))
  new_lvs <- list(lv_list[kept], new_lvs)
  lv_list <- lapply(
    new_names,
    function(lv) {
      x <- lapply(new_lvs, `[[`, lv)
      x <- Reduce(union, x, init = character())
      return( sort(x) )
    }
  )
  names(lv_list) <- new_names
  return(lv_list)
}

.weave_ordinary_terms <- function(x, terms, out.format) {
  lv_list <- levels(x)
  # Determine required ids in order, only keep relevant elements of link.
  all_terms <- .select_path(x, terms, include = NULL, exclude = NULL, exact = NULL)
  res <- lapply(all_terms, .weave_full_path, x = x, out.format = "LinkMap")
  res <- do.call(
    rbind.data.frame,
    c(res, make.row.names = FALSE, stringsAsFactors = TRUE)
  )
  if( out.format == "matrix" ) {
    res <- Matrix::sparseMatrix(
      i = as.numeric(res[[terms[1L]]]), j = as.numeric(res[[terms[2L]]]),
      dims = lengths(lv_list[terms]), dimnames = lv_list[terms]
    )
  }
  return(res)
}


.weave_full_path <- function(x, all_terms, out.format) {
  x <- subsetByPath(x, all_terms)
  terms <- all_terms[c(1L, length(all_terms))]
  # Construct dictionary
  res <- .weave_to_dictionary_matrix(x, all_terms)

  # Check if we're done
  if(out.format == "matrix") {
    dimnames(res) <- levels(x)[terms]
    return(res)
  }
  # Otherwise, make a LinkMap
  res <- .res_weave_matrix_to_LinkMap(res, levels(x)[terms])

  return(res)
}

#' @importFrom Matrix which
#'
.res_weave_matrix_to_LinkMap <- function(res, lvs) {

  res <- as.data.frame.matrix(Matrix::which(res > 0L, arr.ind = TRUE))
  res[] <- mapply(FUN = function(x, y) {
    attr(x, "levels") <- y
    `class<-`(x, "factor")
  }, x = res, y = lvs, SIMPLIFY = FALSE )
  colnames(res) <- names(lvs)
  return(res)
}

.weave_paths_terms <- function(x, terms) {
  stopifnot(
    "both terms must be found as colnames in 'x'" = all(
      terms %in% colnames(x)
    )
  )
  g <- igraph::graph_from_data_frame(
    d = .all_names_in_list_mf(x),
    directed = FALSE
  )
  igraph::all_shortest_paths(
    g, from = terms[1], to = terms[2])[["vpaths"]]
}
