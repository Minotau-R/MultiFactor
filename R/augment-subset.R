#' Tools to modify MultiFactors
#' @name augment-subset
#' @rdname augment-subset
#' @description
#' Generates a new `MultiFactor` object by cross-referencing the elements of a
#'     given `MultiFactor`.
#' @param x a `MultiFactor`
#' @param ... Name-value pairs. The name gives the name of the LinkMap in the
#'     output.
#' @returns a `MultiFactor`.
#' @examples
#' # Only necessary in example code
#' require(generics)
#' # Generate a random MultiFactor
#' x <- randomMultiFactor()
#'
#' # Use augment to chain together operations like weave and stack, in order.
#' augment(x,
#'     weave(x, a ~ c),
#'     stack(x, a + b ~ c + d),
#'     weave(x, d ~ f)
#' )
#'
#' # Setting a LinkMap to NULL by name deletes it from the MultiFactor
#' augment(x, a2b = NULL )
#'
NULL

#' @export
#' @aliases subset.MultiFactor
#'
`subset.MultiFactor::MultiFactor` <- function(
        x, subset = NULL, by_path = TRUE, drop.unmatched = TRUE, ...
) {
    if(drop.unmatched) x <- .trimMultiFactor(x)
    if(is.null(subset)) return(x)
    if(by_path){
        subset <- unlist(.path_parse(subset))
        stopifnot("Argument `subset` must be length 2 if by_path` is TRUE" =
                      length(subset) == 2L)
        subset <- termSeq(subset, x)
        # Determine required ids in order, keep relevant elements of MultiFactor
        return(subsetByPath(x, subset))
    } else `[`(x, subset)
}

#' @export
#'
method(subset, MultiFactor) <-
    function(
        x, subset = NULL, by_path = TRUE, drop.unmatched = TRUE, ...
    ) `subset.MultiFactor::MultiFactor`(
        x, subset, by_path, drop.unmatched, ...
    )


#' @importFrom generics augment
#'
S7::method(augment, MultiFactor) <-
    function(x, ...) `augment.MultiFactor::MultiFactor`(x, ...)

#' @export
#' @rdname augment-subset
#' @name augment.MultiFactor
#' @importFrom rlang dots_list
#'
`augment.MultiFactor::MultiFactor` <- function(x, ...) {
    old_names <- rownames(x)
    dots <- rlang::dots_list(...)
    dot_names <- names(dots)
    for ( i in seq_along(dot_names) ) {
        res <- eval(dots[[i]], envir = x, enclos = parent.frame())
        res_name <- dot_names[i]
        if(res_name == "") { res_name <- .linkmap2name(res) }

        if( res_name %in% old_names ) {
            x[[res_name]] <- res
        } else {
            x <- c(x, res)
        }
    }
    return(x)
}

#' Safely get all names from a MultiFactor as a data.frame.
#' @noRd
#'
.all_names_in_list_mf <- function(x) {
    as.data.frame.matrix(
        t(vapply(X = x,
                 FUN = function(i) return(names(i)),
                 FUN.VALUE = c(NA_character_, NA_character_))
        )
    )
}

