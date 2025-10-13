# Generate some random linkage input
a2b <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    b = sample(LETTERS[seq(3)], 10, replace = TRUE)
)
a2c <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    c = sample(LETTERS[seq(3)], 10, replace = TRUE)
)
x <- MultiFactor(list(a2b, a2c))

test_that("weaving content is equivalent", {

    x1 <- weave(x, a ~ c)
    x2 <- weave(x, c ~ a)

    # Same pairs, different order:
    expect_identical(
        `row.names<-.data.frame`(x1[order(x1$c, x1$a),c("c", "a")], NULL),
        `row.names<-.data.frame`(x2[order(x2$c, x2$a),c("c", "a")], NULL)
    )

})

