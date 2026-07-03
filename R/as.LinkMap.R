#' Convert common classes to LinkMap or MultiFactor
#' @name as.LinkMap-methods
#' @rdname as.LinkMap-methods
#'
#' @description
#' \code{as.LinkMap} and \code{as.MultiFactor }convert the input object(s) to a
#' \code{LinkMap} and a \code{MultiFactor}, respectively.
#'
#' @param x \code{data.frame}, \code{list} or \code{logical matrix}. Input
#'   object(s) to convert to \code{LinkMap} or \code{MultiFactor}.
#'
#' @param y \code{Character vector}. The vector of elements to use as
#'   feature names along with \code{x} if the latter is an unnamed list.
#'   (Default: \code{NULL}).
#'
#' @param edge.names \code{Character vector}. A vector of two elements
#'   specifying the names of the edges in the output \code{LinkMap}.
#'   (Default: \code{NULL}).
#'
#' @returns
#' \code{as.LinkMap} returns a \code{LinkMap} where each row contains a unique
#' combination of the elements in \code{x} (and \code{y} for an unnamed list).
#' \code{as.MultiFactor} returns a \code{MultiFactor}
#'
#' @examples
#' # Create list with random linkage
#' lst <- lapply(1:3, function(x) sample(letters[seq(3)], 3, replace = TRUE))
#' names(lst) <- LETTERS[seq(3)]
#'
#' # Convert to LinkMap
#' a2b <- as.LinkMap(lst, edge.names = c("a", "b"))
#'
#' # Create adjacency matrix
#' mat <- matrix(sample(c(TRUE, FALSE), 3 * 3, replace = TRUE), nrow = 3)
#' rownames(mat) <- LETTERS[seq(3)]
#' colnames(mat) <- c("x", "y", "z")
#'
#' # Convert adjacency matrix to LinkMap
#' b2c <- as.LinkMap(mat, edge.names = c("b", "c"))
#'
#' # Convert list of lists, matrices or data.frames to MultiFactor
#' mf <- as.MultiFactor(list(X1 = lst, X2 = mat))
#'
NULL

S7::method(as.LinkMap, LinkMap) <- function(x) x


S7::method(as.LinkMap, S7::class_data.frame) <- function(
        x, edge.names = NULL
){
    if( NCOL(x) >= 3L ) {
        metadata <- x[, -seq_len(2L)]
        x <- x[, seq_len(2L)]
    } else {
        metadata <- data.frame(row.names = seq_len(NROW(x)))
        }
    # Assign custom edge names
    if( !is.null(edge.names) ){
        colnames(x) <- edge.names
    }
    # Convert to LinkMap
    x <- LinkMap(x, metadata)
    return(x)
}

S7::method(as.LinkMap, S7::class_list) <- function(
    x, y = NULL, edge.names = NULL ){
    # Use list names
    if( is.null(y) ){
        y <- names(x)
    }
    # Create linkMap
    x2y <- data.frame(
        x = unlist(x, recursive = TRUE, use.names = FALSE),
        y = rep(y, lengths(x))
    )
    # Assign custom edge names
    if( !is.null(edge.names) ){
        names(x2y) <- edge.names
    }
    # Convert to LinkMap
    x2y <- LinkMap(x2y)
    return(x2y)
}

S7::method( as.LinkMap, S7::class_logical) <- function(x, edge.names = NULL){
        # Check that x is a matrix
        if( !is.matrix(x) ){
            stop("'x' must be a matrix.", call. = FALSE)
        }
        if( is.null(rownames(x)) || is.null(colnames(x)) ){
            stop("'x' must have rownames and colnames.", call. = FALSE)
        }
        # Find link indices
        idx <- which(x, arr.ind = TRUE)
        # Find link pairs
        x2y <- data.frame(
            x = rownames(x)[idx[, 2]],
            y = colnames(x)[idx[, 1]]
        )
        # Assign custom edge names
        if( !is.null(edge.names) ){
            names(x2y) <- edge.names
        }
        # Convert to LinkMap
        x2y <- LinkMap(x2y)
        return(x2y)
    }

S7::method(as.MultiFactor, S7::class_any) <- function(x, edge.names = NULL){
        if( is.null(edge.names) ){
        edge.names <- lapply(seq_along(x), function(i) letters[c(i, i + 1)])
    }
    # Convert each element to LinkMap
    mf <- mapply(as.LinkMap, x = x, edge.names = edge.names, SIMPLIFY = FALSE)
    # Convert to MultiFactor
    mf <- MultiFactor(mf)
    return(mf)
}
