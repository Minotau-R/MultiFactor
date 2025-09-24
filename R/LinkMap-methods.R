
method(str, LinkMap) <- function(object, ...) {
    str(`class<-`(S7::S7_data(object), "data.frame"))
}


method(levels, LinkMap) <- function(x) {
    lapply(x, levels)
}
