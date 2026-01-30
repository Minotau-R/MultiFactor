#' Convert common classes to LinkMap
#' @export
#' @rdname as.LinkMap-generic
#' @name as.LinkMap
#' @param x input object
#' @param ... additional arguments
#' @seealso [as.LinkMap-methods]
#' @examples
#' # Available methods:
#' as.LinkMap
#'
as.LinkMap <- S7::new_generic("as.LinkMap", "x")

#' The Number of Levels of an Object
#' @description
#' Return the number of levels which its argument has. Extends `base::nlevels`.
#' @param x an object, such as a `LinkMap`, `MultiFactor` or `factor`.
#' @param ... additional arguments. Not used for `base::factor` method.
#' @returns A `Numeric vector` of length equal to the number of elements in `x`.
#'     Optionally, named.
#' @examples
#' # Available methods:
#' nlevels
#'
#' @export
nlevels <- S7::new_generic("nlevels", "x")

S7::method(nlevels, S7::class_any) <- base::nlevels

#' Convert common classes to MultiFactor
#' @export
#' @rdname as.MultiFactor-generic
#' @name as.MultiFactor
#' @param x input object
#' @param ... additional arguments
#' @seealso [as.LinkMap-methods]
#' @examples
#' # Available methods:
#' as.MultiFactor
#'
#'
as.MultiFactor <- S7::new_generic("as.MultiFactor", "x")

#' Convert common classes to MultiFactor
#' @export
#' @rdname weave-generic
#' @name weave
#' @param x input object
#' @param .by either a `formula` or a `character vector`` of length 2 with the
#'     names of the desired combination of feature types.
#' @param ... additional arguments
#' @examples
#' # Available methods:
#' weave
#'
weave <- S7::new_generic("weave", "x", function(x, .by, ...) {
    S7_dispatch()
})
