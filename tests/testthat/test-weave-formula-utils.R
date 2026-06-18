test_that("complex formula is parsing works", {
    f <- a ~ b + c  ~ d + e + f ~ g
    res <- lapply(.path_prep_complex_call(f), deparse1)
    expect_identical(
        res, list("a ~ b + c", "b + c ~ d + e + f", "d + e + f ~ g")
    )

})
