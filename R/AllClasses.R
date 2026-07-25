#' LinkMap S7 container class
#' @name LinkMap
#' @rdname LinkMap-class
#' @description
#' `LinkMap` is an S7 class to organize and manage multiple sets of factors,
#' for instance when tracing or converting feature IDs across databases. Methods
#' for `LinkMap` aim to follow `factor` behaviour.
#'
#' @slot levels `Named list` of character vectors depicting levels.
#' @slot metadata `data.frame`. Optional. Used to store additional data or
#'     application-specific tags.
#' @param x `data.frame` with two named columns that can be coerced to factors.
#'     Optionally, additional columns will be stored as metadata.
#' @param metadata Optional `data.frame` with same number of rows as x. Contains
#'     information about the feature link in that row.
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
#' @importFrom forcats as_factor
#' @export
#'
LinkMap <- S7::new_class(
    "LinkMap",
    package = "MultiFactor",
    parent = S7::class_data.frame,
    properties = list(
        levels = S7::new_property(
            getter = function(self) lapply(S7::S7_data(self), levels),
            setter = function(self, value) {
                x <- `class<-`(S7::S7_data(self), "data.frame")
                S7::S7_data(self) <- .unify_levels_LinkMap(x, value)
                return(self)
            }
        ),
        metadata = S7::new_property(
            class = S7::class_data.frame,
            getter = function(self) self@metadata
        )
    ),
    constructor = function(x, metadata = NULL) {
        # Check input
        stopifnot( .check_input_df(x) )

        if(S7::S7_inherits(x, LinkMap)) {
            if( !NCOL(metadata) ) { metadata <- x@metadata }
            x <- `class<-`(S7::S7_data(x), "data.frame")
        }
        if( !NCOL(metadata) ) {
            metadata <- data.frame(row.names = seq_len(NROW(x)))
        } else {
            stopifnot(
                "Arg 'x' must have the same number of rows as 'metadata'" =
                    NROW(x) == NROW(metadata)
            )
        }
        # Factorize x, preserve order
        x[] <- lapply(x, forcats::as_factor)
        i <- !duplicated(x)
        x <- x[i, , drop = FALSE]
        x <- `row.names<-.data.frame`(x, NULL)
        metadata <- metadata[i, , drop = FALSE]
        metadata <- `row.names<-.data.frame`(metadata, NULL)
        S7::new_object(x, metadata = metadata)
        },
    validator = function(self) {
        if( !is.data.frame(self) ) { "Must be a data.frame." }
        if( NCOL(self) != 2L ) { "Must be a data.frame with two columns." }
        if( length(colnames(self)) != 2L ) { "Both columns must be named." }
        if( !all(vapply(self, is.factor, NA, USE.NAMES = FALSE)) ) {
            "Both columns must be factors."
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
#' @param levels Optional. A `named list of character vectors`, to be used as
#'     levels.
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
        levels = S7::new_property(
            class = S7::class_list,
            getter = function(self) self@levels,
            setter = function(self, value) {
                # If initializing, don't re-unify
                if( !length(levels(self)) ) {
                    self@levels <- value
                } else {
                    self <- .set_levels_MultiFactor(self, value)
                }
                return(self)
            }
            ),
        map = S7::new_property(
            getter = function(self) .mapMultiFactor(self, mode = "counts")
        ),
        metadata = S7::new_property(
            getter = function(self) Reduce(
                function(...) merge(..., all = TRUE), lapply(self, .squash_meta)
            )
        )
    ),
    constructor = function(x, levels = list()) {
        # Check input
        if(is.data.frame(x)) x <- LinkMap(x)
        if(S7::S7_inherits(x, LinkMap)) x <- list(x = x)
        stopifnot(
            "x must be a LinkMap or list of LinkMaps. " =
                all(vapply(x, .check_input_df, FALSE))
        )
        x <- lapply(x, LinkMap)
        # In case of identical pair names, merge.
        names(x) <- paste0("x_", seq_along(x))
        x   <- .merge_linkmaps(x)

        if( !length(levels) )  levels <- .build_levels_from_linkmap_list(x)
        x <- .unify_levels(x, levels)

        names(x) <- vapply(x, .linkmap2name, FUN.VALUE = "", USE.NAMES = FALSE)

        S7::new_object(
            x,
            levels = levels
        )
    },
    validator = function(self) {
        if(!all(vapply(self, .validLinkMap, NA))) {
            "LinkMap content not properly formatted. "
        }

    }

)


#' factor_path S7 class
#' @name factor_path
#' @rdname factor_path-class
#' @description
#' `factor_path` is an S7 class to standardize the various ways in which paths
#' that can be specified across the `MultiFactor` package. This class is mostly
#' for internal use.
#'
#' @param x `Character vector` of length two; `c(<from>, <to>)`.
#' @param include `List of character vectors`. Which elements are included in
#'     the path? Length of the list indicates number of paths.
#' @param exclude `Character vector`. Which elements are excluded from the path?
#' @param exact `Logical`. Should the path be followed as is?
#'     (i.e., no pathfinding required)
#' @returns a `factor_path` object.
#' @importFrom S7 new_class new_property class_character new_object
#' @examples
#' factor_path(x = c("a", "c"), include = list("b"))
#' @export
#'
factor_path <- S7::new_class(
    "factor_path",
    package = "MultiFactor",
    parent = S7::class_character,
    properties  = list(
        include = S7::new_property(
            class = S7::class_list, default = list(character())
        ),
        exclude = S7::new_property(
            class = S7::class_character, default = character()
        ),
        exact   = S7::new_property(
            class = S7::class_logical, default = FALSE
        )
    ),
    constructor = function(
        x, include = list(character()), exclude = character(), exact = FALSE
    ) {
        stopifnot(
            "factor_path input must be length 2." = length(x) == 2L,
            "factor_path input must be a character vector." = is.character(x)
        )
        S7::new_object(
            .parent = x, include = include, exclude = exclude, exact = exact
        )
    },
    validator = function(self) {
        if(length(S7::S7_data(self)) != 2L) {
            "factor_path must have length of two. "
        }
    }
)


##### LinkMap utils --]--

.check_input_df <- function(x) {
    if(! is.data.frame(x) ) {
        stop("Must be a data.frame. ")
    }
    if(! NCOL(x) == 2L ) {
        stop("Must be a data.frame with at least two key columns. ")
    }
    if(! length(colnames(x)) == 2L ) {
        stop("Both key columns must be named. ")
    }
    return( TRUE )
}


#### MultiFactor utils ----

.squash_meta <- function(x) {
    names <- paste(colnames(x), collapse = "2")
    res <- lapply(x@metadata, unique)
    mult <- lengths(res) > 1L
    res[mult] <- lengths(res)[mult]

    res <- c(name = names, res)
    `class<-`(`attr<-`(res, "row.names", names), "data.frame")
}

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
    all_names <- lapply(x, function(x) sort(names(x)))
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

#' @noRd
#' @param x a list in `MultiFactor` formatting.
#' @description Drop features that are not matched in another LinkMap.
#' @returns a subsetted list with `MultiFactor`.formatting.
#' @importFrom Matrix colSums
#'
.trimMultiFactor <- function(x) {
    # Determine positions of feature names that occur in several edge link dfs
    m <- .mapMultiFactor(x, mode = "pattern")
    jj <- colnames(m)[Matrix::colSums(m) > 1]

    # Sequentially subset over feature names
    for (j in jj) {
        # Select all those data frames where that term is mentioned
        ii <- rowsWithCol(m, j, FALSE)
        keep <- Reduce(intersect, lapply(x[ii], base::`[[`, j))

        # Filter feature ids in each df to only universally shared ones.
        x[ii] <- lapply(x[ii], function(df) {
            return(df[df[[j]] %in% keep ])
        })
    }
    return(x)
}

#' @description Subset MultiFactor to only include the features
#'     found in a feature table.
#' @returns a MultiFactor subsetted by relevant features
#' @param x a `MultiFactor` .
#' @param id `Character scalar`, naming the x term to be trimmed
#' @param ft A table containing features of interest, `tableX` or `tableY`.
#' @noRd
#'
.trimByFeatureTable <- function(x, ft, id) {
    lv <- levels(x)[[id]]
    r <- rowsWithCol(x@map, id)
    stopifnot(
        "Feature names appeared in several index elements. " = length(r) == 1L
    )
    # Subset index by table rows
    xr <- x[[r]]
    x.names <- match(row.names(ft), lv)
    xr <- xr[xr[, id] %in% x.names, ]
    xr.id <- xr[, id]

    # Subset levels
    x@levels[[id]] <- lv[sort(unique(xr.id))]
    # Reorder and replace indices
    xr[, id] <- match(xr.id, sort(unique(xr.id)))
    x[[r]] <- xr

    return(x)
}

#' Given a list of linkmaps x, return a unified and sorted list of levels.
#' @noRd
.build_levels_from_df_list <- function(x) {
    all_lvs <- unique(unlist(lapply(x, colnames), FALSE, FALSE))
    lvs <- .gather_all_levels(x, all_lvs)
    return(lvs)
}

#' Given a list of linkmaps x, return a unified and sorted list of levels.
#' @noRd
.build_levels_from_linkmap_list <- function(x) {
    all_lvs <- unique(unlist(lapply(x, colnames), FALSE, FALSE))
    lvs <- .gather_all_levels(x, all_lvs)
    return(lvs)
}

#' @importFrom forcats lvls_union
#' @noRd
#'
.gather_all_levels <- function(x, levels) {
    res <- lapply(
        levels,
        function(lv) {
            fct_in <- lapply(x, `[[`, lv)
            fct_in <- fct_in[ !vapply(fct_in, is.null, FUN.VALUE = TRUE) ]
            res <- forcats::lvls_union(fct_in)
            sort(res)
        }
    )
    names(res) <- levels
    return( res )

}

#' Given a list of linkmaps x and named list of chars levels, unify all levels
#' across x.
#' @noRd
.unify_levels <- function(x, levels) {
    is_s7 <- all(vapply(x, S7::S7_inherits, LinkMap, FUN.VALUE = FALSE))
    if(is_s7) {
        res <- lapply(x, .unify_levels_LinkMap, levels)
    } else {
        res <- lapply(x, .unify_levels_data.frame, levels)
    }
    return(res)
}

#' @importFrom forcats lvls_expand
#'
.unify_levels_data.frame <- function(x, levels) {
    x <- mapply(
        forcats::lvls_expand, x,
        levels, SIMPLIFY = FALSE
    )
    return(x)
}


# TODO metadata and .data are now separate props. Use lapply for indexing?
# FIXME
#' @importFrom forcats lvls_expand
#'
.unify_levels_LinkMap <- function(x, levels) {

    x[] <- mapply(
        forcats::lvls_expand,
        x,
        levels[colnames(x)],
        SIMPLIFY = FALSE
    )
    #S7::S7_data(x) <- `class<-`(old, "data.frame")
    return(x)
}

.validLinkMap <- function(x) {
    is.data.frame(x) &&
        NCOL(x) == 2L &&
        length(colnames(x)) == 2L &&
        all(vapply(x, is.factor, NA, USE.NAMES = FALSE))
}

