#' Methods for path_frame S7 container class
#' @name path_frame-methods
#' @rdname path_frame-methods
#'
#' @examples
#' x <- random_multifactor()
#'
#' # Generate a path_frame
#' p <- select_path(x, a ~ d)
#'
#' # Get formula notation for the full path:
#' formula(p)
#'
#' @param x,object `path_frame` on which the method should be applied.
#' @returns A `path_frame` or method-appropriate value.
NULL

S7::method(formula, path_frame) <- function(x) `formula.multifactor::path_frame`(x)

#' @export
#' @importFrom stats formula as.formula
#'
`formula.multifactor::path_frame` <- function(x, ...) {
  out_len <- 1 + 2 * NROW(x)
  res <- rep("~", out_len)
  res[seq_len(out_len) %% 2 == 1L] <- `terms.multifactor::path_frame`(x)

  if (.check_path_frame_uses_coverage(x)) {
    res[seq_len(out_len) %% 2 == 0L][x[["use_cov"]]] <- ":"

    if (any(spec <- x[["cov_req"]] %notin% c(">= 0", ">= 1"))) {
      res[2 * which(spec) + 1L] <- paste(
        res[2 * which(spec) + 1L], x[["cov_req"]][spec]
      )
    }
  }

  res <- paste0(res, collapse = "")

  stats::as.formula(res, globalenv())
}

S7::method(terms, path_frame) <- function(x) `terms.multifactor::path_frame`(x)

#' @export
`terms.multifactor::path_frame` <- function(x, ...) as.character(
  c(x[[1L]], x[[2L]][NROW(x)])
)

S7::method(print, path_frame) <- function(x, ...) {
  from_to <- terms(x)[c(1, NROW(x) + 1L)]

  if (has_comps <- "components" %in% colnames(x)) {
    p <- tapply(
      x, ~components, `formula.multifactor::path_frame`,
      simplify = FALSE
    )
  } else {
    p <- list(formula(x))
  }

  cat(
    "A ", paste(setdiff(class(x), "data.frame"), collapse = " "),
    ".\n  A path from `", from_to[[1L]], "` to `", from_to[[2L]], "`",
    sep = ""
  )
  if (length(p) == 1L) {
    cat(":\n")
  } else {
    cat(" with ", length(p), " sub-paths:\n", sep = "")
  }
  for (i in length(p)) {
    print(p[[1]])
    cat("\n")
  }
  print.data.frame(x)
}
