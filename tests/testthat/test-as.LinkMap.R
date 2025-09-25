test_that("utils", {
    
    lst <- list(A = c("a", "b"), B = c("a", "b", "c"), C = c("b"))
    
    a2b <- as.LinkMap(lst)
    
    expect_contains(levels(a2b)$x, c("a", "b", "c"))
    expect_equal(dim(a2b), c(6, 2))
    
    y <- names(lst)
    lst2 <- unname(lst)
    
    a2b <- as.LinkMap(lst2, y, edge.names = c("a", "b"))
    
    expect_equal(names(a2b), c("a", "b"))
    expect_equal(levels(a2b)$b, y)
    
    mat <- matrix(c(TRUE, FALSE, TRUE), nrow = 3, ncol = 3)
    rownames(mat) <- LETTERS[seq(3)]
    colnames(mat) <- c("x", "y", "z")
    
    b2c <- as.LinkMap(mat, edge.names = c("b", "c"))
    
    expect_equal(names(b2c), c("b", "c"))
    expect_equal(levels(b2c)$c, c("x", "z"))
    
    mf <- as.MultiFactor(list(X1 = lst, X2 = mat))
    
    expect_equal(dim(mf), c(2, 3))
    expect_equal(levels(mf)$c, c("x", "z"))
     
})
