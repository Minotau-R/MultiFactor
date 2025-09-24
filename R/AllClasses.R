
LinkMap <- S7::new_class(
    "LinkMap",
    package = "MultiFactor",
    parent = S7::class_data.frame,
    properties  = list(
        levels   = S7::new_property(getter = function(self) lapply(self, levels)),
        value    = S7::class_numeric | S7::class_logical,
        is_bool  = S7::new_property(getter = function(self) isTRUE(self@value))
    ),
    constructor = function(x) {
        if(S7::S7_inherits(x, LinkMap)) return(x)
        stopifnot(.check_input_df(x))
        is_bool    <- length(colnames(x)) == 2L

        value      <- if(is_bool) TRUE else x[,3L]
        edgelist   <- .factorize_df(x, is_bool)

        S7::new_object(
            .parent = edgelist[[1L]],
            value   = edgelist[[2L]]
        )
    }
)



MultiFactor <- S7::new_class(
    "MultiFactor",
    package = "MultiFactor",
    parent = S7::class_list,
    properties  = list(
        levels = S7::new_property(getter = function(self) lapply(self, levels)),
        value = S7::class_list,
        map = S7::new_property(
            getter = function(self) .mapMultiFactor(self, mode = "counts")
        )
    ),
    constructor = function(x) {
        # check input
        if(is.data.frame(x)) x <- LinkMap(x)
        if(S7::S7_inherits(x, LinkMap)) x <- list(x)
        stopifnot(
            "x must be a LinkMap or list of LinkMaps. " =
                all(vapply(x, .check_input_df, FALSE))
        )
        x <- lapply(x, LinkMap)
        # extract levels
        x   <- .unify_levels(x)
        value      <- lapply(x, \(x) x@value)


        S7::new_object(
            .parent = x,
            value   = value
        )
    }
)



# LinkMap utils

.check_input_df <- function(x) {
    stopifnot("x must be a data.frame" = is.data.frame(x))
    stopifnot(
        "x must be a data.frame with exactly two or three columns" =
            NCOL(x) %in% c(2L, 3L)
    )
    stopifnot(
        "The first two columns of x must be named" =
            length(colnames(x)) %in% c(2L, 3L)
    )
    return(TRUE)
}

.factorize_df <- function(x, is_bool) {
    value <- if(is_bool) TRUE else x[[3L]]
    x[[3L]] <- NULL
    x  <- `[<-.data.frame`(x, , value = lapply(x, as.factor))
    out <- list(x, value)
    return(out)
}

# MultiFactor utils ----

.mapMultiFactor <- function(x, mode = "counts") {
    # Some flexibility in input
    mode <- match.arg(mode, choices = c("counts", "binary", "pattern"))
    all_names <- lapply(x, base::names)
    i <- factor(
        rep( names(all_names), vapply(all_names, length, 1, USE.NAMES = FALSE) ),
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



