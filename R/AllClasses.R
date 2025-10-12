#' LinkMap S7 container class
#' @name LinkMap
#' @rdname LinkMap-class
#' @description
#' `LinkMap` is an S7 class to organize and manage multiple sets of factors,
#' for instance when tracing or converting feature IDs across databases. Methods
#' for `LinkMap` aim to follow `factor` behaviour.
#'
#' @slot levels `Named list` of character vectors depicting levels.
#' @slot metadata `list`. Optional. May be used to store additional data or
#'     application-specific tags.
#' @param x `data.frame` with two named columns that can be coerced to factors.
#' @param metadata `list`. Optional. May be used to store additional data or
#'     application-specific tags.
#' @returns a `LinkMap` object.
#' @examples
#' # Generate random linkage input
#' x <- data.frame(
#'     a = sample(letters[seq(3)], 10, replace = TRUE),
#'     A = sample(LETTERS[seq(3)], 10, replace = TRUE)
#' )
#'
#' # Create LinkMap
#' LinkMap(x)
#'
#' @seealso [MultiFactor()]
#' @export
#'
LinkMap <- S7::new_class(
    "LinkMap",
    package = "MultiFactor",
    parent = S7::class_data.frame,
    properties  = list(
        levels   = S7::new_property(getter = function(self) lapply(self, levels)),
        metadata = S7::class_list
    ),
    constructor = function(x, metadata = list()) {
        if(S7::S7_inherits(x, LinkMap)) return(x)
        stopifnot(.check_input_df(x))

        # Factorize x
        x  <- `[<-.data.frame`(x, , value = lapply(x, as.factor))

        S7::new_object(
            .parent  = x,
            metadata = metadata
        )
    },
    validator = function(self) {
        if(!is.data.frame(self)) {
            "Must be a data.frame. "
        }
        if(! NCOL(self) == 2L) {
            "Must be a data.frame with exactly two columns. "
        }
        if(!length(colnames(self)) == 2L) {
            "Both columns must be named. "
        }
        if(!all(vapply(self, is.factor, NA, USE.NAMES = FALSE))){
            "Both columns must be factors. "
        }
    }
)


#' MultiFactor S7 container class
#' @name MultiFactor
#' @rdname MultiFactor-class
#' @description
#' `MultiFactor` is an S7 class to organize and manage multiple sets of factors,
#' for instance when tracing or converting feature IDs across databases. Methods
#' for `MultiFactor` aim to follow `factor` behaviour.
#'
#' @details
#' The most straightforward way to construct a `MultiFactor` object is as a
#' named list of named data.frames. The columns of the data.frames indicate the
#' category of factor in that column.
#'
#' A `MultiFactor` object presents itself similar to a `data.frame`, in the
#' sense that level types can be called as columns and individual data.frame
#' components can be called as rows.
#' `MultiFactor` inherits from `list`; Content can be accessed through regular
#' list methods (e.g., `[`, `[[`).
#' @slot levels `Named list of character vectors`. Accessed through `levels(x)`
#' @slot map `(sparse) Matrix` specifying which elements contain which levels.
#' @param x a `LinkMap`, or named list of `LinkMap` objects.
#' @returns a `MultiFactor` object.
#' @seealso [MultiFactor-methods()]
#' @importFrom S7 new_class new_property
#' @examples
#' # Generate some random linkage input
#' a2b <- data.frame(
#'     a = sample(letters[seq(3)], 10, replace = TRUE),
#'     b = sample(LETTERS[seq(3)], 10, replace = TRUE)
#' )
#' a2c <- data.frame(
#'     a = sample(letters[seq(3)], 10, replace = TRUE),
#'     c = sample(LETTERS[seq(3)], 10, replace = TRUE)
#' )
#' x <- MultiFactor(list(a2b, a2c))
#'
#' @seealso [LinkMap()]
#' @export
#'
MultiFactor <- S7::new_class(
    "MultiFactor",
    package = "MultiFactor",
    parent = S7::class_list,
    properties  = list(
        levels = S7::new_property(getter = function(self) lapply(self, levels)),
        map = S7::new_property(
            getter = function(self) .mapMultiFactor(self, mode = "counts")
        ),
        metadata = S7::new_property(
            getter = function(self) lapply(self, function(x) x@metadata)
        )
    ),
    constructor = function(x) {
        # Check input
        if(is.data.frame(x)) x <- LinkMap(x)
        if(S7::S7_inherits(x, LinkMap)) x <- list(x = x)
        stopifnot(
            "x must be a LinkMap or list of LinkMaps. " =
                all(vapply(x, .check_input_df, FALSE))
        )
        x <- lapply(x, LinkMap)
        names(x) <- paste0("x_", seq_along(x))
        # Extract levels
        x   <- .merge_linkmaps(x)
        x   <- .unify_levels(x)
        names(x) <- vapply(
            x,
            function(x) paste(names(x), collapse = "2"),
            FUN.VALUE = "", USE.NAMES = FALSE
        )

        S7::new_object(
            .parent = x
        )
    },
    validator = function(self) {
        if(!all(vapply(self, .validLinkMap, NA))) {
            "LinkMap content not properly formatted. "
        }

    }

)

##### LinkMap utils ----

.check_input_df <- function(x) {
    if(!is.data.frame(x)) {
        stop("Must be a data.frame. ")
    }
    if(! NCOL(x) == 2L) {
        stop("Must be a data.frame with exactly two columns. ")
    }
    if(!length(colnames(x)) == 2L) {
        stop("Both columns must be named. ")
    }
    return(TRUE)
}


#### MultiFactor utils ----

.mapMultiFactor <- function(x, mode = "counts") {
    # Some flexibility in input
    mode <- match.arg(mode, choices = c("counts", "binary", "pattern"))
    all_names <- lapply(x, base::names)
    i <- factor(
        rep( names(all_names), lengths(all_names, use.names = FALSE)),
        levels = names(all_names)
    )
    j <- factor(
        unlist(all_names, use.names = FALSE),
        levels = unique(unlist(all_names, use.names = FALSE))
    )

    # mx is a vector of length i that determines the values of sparse Matrix.
    mx <- switch(mode,
                 "counts" = unlist(
                     lapply(x, function(y) {
                         lapply(y, function(z) length(unique(z)))
                     }),
                     use.names = FALSE
                 ),
                 "binary" = 1L,
                 "pattern" = TRUE
    )

    return(
        Matrix::sparseMatrix(
            i = i,
            j = j,
            x = mx,
            dimnames = list(
                levels(i),
                levels(j)
            )
        )
    )
}


.merge_linkmaps <- function(x) {
    all_names <- lapply(x, \(x) sort(names(x)))
    if(!any(duplicated(all_names))) return(x)

    dup_names <- unique(all_names[duplicated(all_names)])
    merg_list <- vector("list", length = length(dup_names))

    for(dup in seq_along(dup_names)) {
        merg <- unique(do.call(rbind, x[ all_names %in% dup_names[dup] ]))
        row.names(merg) <- NULL
        merg[] <- lapply(merg, \(x) forcats::lvls_reorder(x, order(levels(x))))

        merg_list[[dup]] <- merg
    }
    names(merg) <- lapply(dup_names, paste0, collapse = "2")
    x <- c(x[! all_names %in% dup_names ], merg_list)
    return(x)
}


.unify_levels <- function(x) {
    map <- .mapMultiFactor(x, "pattern")
    repeats <- Matrix::colSums(map) >= 2L
    if(sum(repeats) == 0L) return(x)

    for(id in names(which(repeats))) {
        fct_in <- lapply(x[map[,id]], \(x) x[,id])
        fct_rep <- forcats::fct_unify(fct_in)
        for(fct in seq_along(fct_rep)){
            x[map[,id]][[fct]][,id] <- fct_rep[[fct]]
        }
    }
    x
}

.validLinkMap <- function(x) {
    is.data.frame(x) &&
        NCOL(x) == 2L &&
        length(colnames(x)) == 2L &&
        all(vapply(x, is.factor, NA, USE.NAMES = FALSE))
}

