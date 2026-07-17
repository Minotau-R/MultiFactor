#' Convert common classes to LinkMap
#' @export
#' @rdname as.LinkMap
#' @name as.LinkMap
#' @param x input object
#' @param ... additional arguments
#' @seealso [as.LinkMap-methods]
#' @returns a `LinkMap`
#' @examples
#' # Available methods:
#' as.LinkMap
#'
as.LinkMap <- S7::new_generic("as.LinkMap", "x")

#' The Number of Levels of an Object
#' @name nlevels
#' @rdname nlevels
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
#' @rdname as.MultiFactor
#' @name as.MultiFactor
#' @param x input object
#' @param ... additional arguments
#' @returns a `MultiFactor`.
#' @seealso [as.LinkMap]
#' @examples
#' # Available methods:
#' as.MultiFactor
#'
as.MultiFactor <- S7::new_generic("as.MultiFactor", "x")

#' Weave a path through an object
#' @rdname weave-generic
#' @name weave-generic
#' @description `weave()` is an S7 generic that finds a path through a
#'     relational object.
#'
#' @param x input object
#' @param .path either a `formula` or a `character vector` of length 2 with the
#'     names of the desired combination of feature types.
#' @param ... additional arguments
#' @returns a `LinkMap` or `matrix`.
#' @importFrom S7 S7_dispatch
#' @export
#' @examples
#' # Available methods:
#' weave
#'
weave <- S7::new_generic("weave", "x", function(x, .path, ...) {
    S7::S7_dispatch()
})

#' Index a table and apply arbitrary code to it
#' @rdname weave_apply-generic
#' @name weave_apply-generic
#' @description `weave_apply()` is an S7 generic that finds a path through a
#'     relational object and evaluates provided code to each corresponding
#'     subset of an input table.
#'
#' @param .x input relational object to dispatch on.
#' @param .path either a `formula` or a `character vector` of length 2 with the
#'     names of the desired combination of feature types.
#' @param .data an R object, such as tabular data.
#' @param .fun the function to be applied to each subgroup of `.x`.
#' @param ... Optional arguments to `.fun`
#' @importFrom S7 S7_dispatch new_generic
#' @export
#' @returns a list containing the results of `.fun`.
#' @examples
#' # Available methods:
#' weave_apply
#'
weave_apply <- S7::new_generic(
    "weave_apply",
    ".x",
    function(.x, .path, .data, .fun = NULL, ...) {S7::S7_dispatch()}
)

#' Weave a path through an object
#' @name select_path-generic
#' @rdname select_path-generic
#' @description `select_path()` is an S7 generic that finds and returns a path
#'     through a relational object.
#'
#' @param x input object
#' @param .path either a `formula` or a `character vector` of length 2 with the
#'     names of the desired combination of feature types.
#' @param ... additional arguments
#' @export
#' @importFrom S7 S7_dispatch
#' @returns a (list of) character vector(s).
#' @examples
#' # Available methods:
#' select_path
#'
select_path <- S7::new_generic("select_path", "x", function(x, .path, ...) {
    S7::S7_dispatch()
})

