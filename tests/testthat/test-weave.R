test_that("weaving content is equivalent", {

    x <- randomMultiFactor()

    x1 <- weave(x, a ~ c)
    x2 <- weave(x, c ~ a)

    # Same pairs, different order:
    expect_identical(
        lapply(x1, table),
        rev( lapply(x2, table) )
    )

})

