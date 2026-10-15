
.check_path_frame_is_minimal <- function(.path_map) NROW(.path_map) == 1L

.check_path_frame_uses_stack <- function(.path_map) any(.path_map[["stack"]])

.check_path_frame_uses_coverage <- function(.path_map) any(
    .path_map[["use_cov"]] > 0
    )

.pf_as_stack_path_list <- function(x) strsplit(
    `terms.multifactor::path_frame`(x), " + ", fixed = TRUE
    )

.pf_as_full_path_list <- function(x) unname(
    tapply(x, ~components, `terms.multifactor::path_frame`, simplify = FALSE)
)

.valid_path_input <- function(.path) {
    classes <- c("character", "formula", "data.frame", "list")
    #Some grace for select_path output
    if(is.list(.path) && length(.path) == 1L) { .path <- .path[[1L]] }
    stopifnot(
        "'.path' must be a formula or a (list of) character vector(s)." =
            inherits(.path, classes)
    )
    invisible()
}

.path_to_path_frame <- function(.path) path_frame(
        .path_to_path_frame_df(.path)
)

#' @importFrom stats as.formula
#'
.path_to_path_frame_df <- function(.path) {
    .valid_path_input(.path)

    # Some flexibility if input is in a list of length 1:
    if(is.list(.path) && length(.path) == 1L) {
        .path <- .path[[1L]]
    }
    if(inherits(.path, "character")) {
        .path <- stats::as.formula(paste0(.path, collapse = "~"))
    }

    res <- .cut_fm_to_df(.path)
    return(res)
}

.cut_fm_to_df <- function(x, all_seps = c("~", ":")) {
    # Convert to character
    x <- deparse1(x)

    steps <- paste0(all_seps, collapse = "|")

    # Get all separators and content
    seps     <- strsplit(gsub(paste0("[^", steps, "]"), "", x), "")[[1L]]
    content  <- .drop_trailing_spaces(strsplit(x, steps)[[1L]])
    use_cov  <- seps == ":"
    cov_res  <- .parse_coverage(content, use_cov)
    cov_req  <- cov_res[["cov_req"]]
    content  <- cov_res[["content"]]

    from     <- factor(content[seq_along(seps)],      unique(sort(content)) )
    to       <- factor(content[seq_along(seps) + 1L], unique(sort(content)) )

    stack    <- grepl("+", to, fixed = TRUE) | grepl("+", from, fixed = TRUE)

    data.frame(from, to, stack, use_cov, cov_req)
}

.drop_trailing_spaces <- function(x) gsub("^ | $", "", x)


.parse_coverage <- function(content, use_cov) {
    # Fill in required coverage thresholds
    # case when NO coverage:
    cov_req <- vector("character", length = length(use_cov))
    cov_req[!use_cov] <- ">= 0"

    if( any(use_cov) ) {
        all_ops <- c(">", "<", ">=", "<=", "==", "!=")
        ops <-  paste0(all_ops, collapse = "|")

        # t_cov is an index of coverage values with a specified threshold
        t_cov <- grepl( paste0("[", ops, "]"), content[-1L]) & use_cov

        cov_req[use_cov & !t_cov] <- ">= 1"

        if(any(t_cov)) {
            cov_req[t_cov] <- .drop_trailing_spaces(
                sub(
                    paste0("^([^", ops, "])"),
                    "",
                    content[-1L], perl = TRUE)[t_cov]
            )
            content[-1L][t_cov] <- .drop_trailing_spaces(
                gsub(
                    paste0("[", ops, "].*"), "",
                    content[-1L], perl = TRUE)[t_cov]
            )
        }
    }

    list(cov_req = cov_req, content = content)

}
