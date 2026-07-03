#' @import S7
#' @rawNamespace if (getRversion() < "4.3.0") importFrom("S7", "@")
NULL



.onLoad <- function(...) {
    S7::methods_register()
}

