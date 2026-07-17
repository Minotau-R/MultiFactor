#' Weave a new LinkMap from a MultiFactor
#' @name weave-methods
#' @rdname weave-methods
#' @description
#' Generates a new `LinkMap` object by cross-referencing the elements of a
#'     given `MultiFactor`.
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

S7::method(weave, MultiFactor) <- function(
    x, .path, out.format = c("LinkMap", "matrix"),
    include = NULL, exclude = NULL, exact = NULL
) {
  out.format <- match.arg(out.format, c("LinkMap", "matrix"))

  path_check <- .check_path(.path)
  .path_check_valid_weave(path_check)
  path_list <- .path_to_std_list(.path, path_check)

  full_path <- as.list(.select_std_path(x, path_list))

  res <- lapply(full_path, .weave_full_path, x = x, out.format = "LinkMap")
  res <- do.call( rbind.data.frame, res )
  res <- LinkMap(res)

  if(out.format == "matrix") {
   res <- `as.matrix.MultiFactor::LinkMap`(res)
  }

  return(res)
}

.path_check_valid_weave <- function(path_check) {
  if(path_check[["complex"]]) {
    stop("weave() '.path' cannot contain '+'. Use `stack()` to prepare input.")
  }
}

.weave_full_path <- function(x, all_terms, out.format) {
  x <- .subset_by_path(x, all_terms)
  terms <- all_terms[c(1L, length(all_terms))]

  # Construct dictionary
  res <- .weave_to_dictionary_matrix(x, all_terms)

  # make a LinkMap-shaped data.frame
  res <- .res_weave_matrix_to_LinkMap(res, levels(x)[terms])

  return(res)
}

#' Generate dictionary Matrix from link input
#' @param link `MultiFactor`
#' @param all_terms `Character vector` of all path terms in sequence.
#'     `.term_seq(x, y, link)`
#' @importMethodsFrom Matrix %&%
#' @noRd
#'
.weave_to_dictionary_matrix <- function(link, all_terms) {
  term_list <- lapply(
    seq_len(length(all_terms) - 1L),
    FUN = function(x) all_terms[c(x, x + 1L)]
  )
  steps <- .step_seq(term_list, link@map)
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
