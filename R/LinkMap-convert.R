#' Convert to LinkMap
#' 
#' \code{as.linkmap} converts a list of named vectors to a linkmap data.frame.
#' 
#' @param values \code{Character list}. List of vectors where each vector
#'   represents one type of values.
#' 
#' @param keys \code{Character vector}. The vector of keys to use as names for
#'   \code{values} if the latter is unnamed. (Default: \code{NULL}).
#' 
#' @param col.names \code{Character vector}. A vector of two elements specifying
#'   the names of the columns in the output linkmap (Default: \code{NULL}).
#' 
#' @returns
#' \code{as.linkmap} returns a linkmap \code{data.frame} where the first and
#' second columns contains \code{keys} and \code{values} and each row represents
#' a unique combination of the two.
#' 
#' @examples
#' # Create list with random linkage
#' a2b <- lapply(1:3, function(x) sample(letters[seq(3)], 3, replace = TRUE))
#' names(a2b) <- LETTERS[seq(3)]
#' 
#' # Convert to LinkMap
#' as.linkmap(a2b)
#' @name as.linkmap
NULL

#' @export
#' @rdname as.linkmap
as.linkmap <- function(values, keys = NULL, col.names = NULL){
    if( is.null(keys) ){
        keys <- names(values)
    }
    # Create linkMap
    linkmap <- data.frame(
        x = rep(keys, lengths(values)),
        y = unlist(values, recursive = TRUE, use.names = FALSE)
    )
    # Assign custom colnames
    if( !is.null(col.names) ){
        names(linkmap) <- col.names
    }
    return(linkmap)
}
