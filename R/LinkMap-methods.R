
S7::method(str, LinkMap) <- function(object, ...) {
    str(`class<-`(S7::S7_data(object), "data.frame"))
}


S7::method(levels, LinkMap) <- function(x) {
    lapply(x, levels)
}
