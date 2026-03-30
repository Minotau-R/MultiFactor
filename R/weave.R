#' Weave a new LinkMap from a MultiFactor
#' @name weave-methods
#' @rdname weave-methods
#' @description
#' Generates a new `LinkMap` object by cross-referencing the elements of a
#'     given `MultiFactor`. Elements can be merged by including several names,
#'     separated by the plus (`+`) sign. See examples.
#' @param x a `MultiFactor`
#' @param .by Either a `formula` or a `character vector` of length 2 with the
#'     names of the desired combination of feature types.
#' @param out.format `Character scalar`. One of `'LinkMap'`, `'matrix'`.
#' @param include,exclude,exact `Character vectors` Should feature types be
#'     included or excluded from the available paths? Exact allows for exact
#'     path definition.
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
#'
NULL

#' @export
#'
S7::method(weave, MultiFactor) <- function(
    x, .by, out.format = c("LinkMap", "matrix"),
    include = NULL, exclude = NULL, exact = NULL
) {
    out.format <- match.arg(out.format, c("LinkMap", "matrix"))
    terms <- .by_terms(.by)

    # Simple case
    if (all (lengths(terms) == 1L)) {
      res <- .weave_simple(terms[[1L]], terms[[2L]], x, out.format)
      if( out.format == "matrix" ) {
        res <- `as.matrix.MultiFactor::LinkMap`(res, dimnames = levels(res))
      }
    }

    # Multiple variable case
    if( any(lengths(terms) > 1L) ) {
      res <- .weave_mult(terms, x, out.format)
      if(out.format == "LinkMap") {
          cn <- vapply(lapply(terms, unique), paste, collapse = ".", "")
          res <- do.call(rbind.data.frame, lapply(res, `colnames<-`, cn))
          res <- unique(res)
      }
    }

    return(res)
}

#' @export
#' @importFrom utils stack
#'
S7::method(stack, MultiFactor) <- function(x, .by, out.format = c("LinkMap", "matrix"), ...) {
    out.format <- match.arg(out.format, c("LinkMap", "matrix"))
    terms <- .by_terms(.by)

    #Stacking case
    if( all( lengths(terms) == 1L ) ) stop(
        "At least one side of formula argument `'.by' ",
        "must contain more than one variable."
    )

    x <- .stack_by_character(x, terms[[1L]], terms[[2L]])
    if(out.format == "matrix") {
        res <- `as.matrix.MultiFactor::LinkMap`(x)
        dimnames(res) <- levels(x)[vapply(terms, paste, collapse = ".", "")]
        return(res)
    }
    if( out.format == "LinkMap" ) return(x)

}


.weave_simple <- function(y_var, x_var, x, out.format) {
  # Non-stacking case
  terms <- c(y_var, x_var)

  # Determine required ids in order, only keep relevant elements of link.
  all_terms <- .select_shortest_paths(x, terms, include = NULL, exclude = NULL, exact = NULL)
  res <- lapply(all_terms, .weave_single, x = x, out.format = "LinkMap", terms = terms)
  res <- do.call(
    rbind.data.frame,
    c(res, make.row.names = FALSE, stringsAsFactors = TRUE)
  )
  return(res)
}


.weave_single <- function(x, all_terms, out.format, terms) {
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

.weave_paths_terms <- function(x, terms) {
  stopifnot(
    "both terms must be found as colnames in 'x'" = all(
      terms %in% colnames(x)
    )
  )
  g <- igraph::graph_from_data_frame(
    d = t(vapply(x, names, c(NA_character_, NA_character_))),
    directed = FALSE
  )
  igraph::all_shortest_paths(
    g, from = terms[1], to = terms[2])[["vpaths"]]
}
