test_that("Detailed formula parsing works", {
    f <- a ~ b + c  ~ d + e + f ~ g
    res <- lapply(.path_prep_fm_detailed(f), deparse1)
    expect_identical(
        res, list("a ~ b + c", "b + c ~ d + e + f", "d + e + f ~ g")
    )

})
