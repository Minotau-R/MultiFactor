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
