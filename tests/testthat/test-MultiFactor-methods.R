x <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    A = sample(LETTERS[seq(3)], 10, replace = TRUE)
)

test_that("Intermediate LinkMap is identical to immediate MultiFactor", {

mf1 <- x |> LinkMap() |> MultiFactor()
mf2 <- x |> MultiFactor()

  expect_identical(mf1, mf2)
})
