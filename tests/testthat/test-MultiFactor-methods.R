x <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    A = sample(LETTERS[seq(3)], 10, replace = TRUE)
)

test_that("Intermediate LinkMap is identical to immediate MultiFactor", {

mf1 <- x |> LinkMap() |> MultiFactor()
mf2 <- x |> MultiFactor()

  expect_identical(mf1, mf2)
})

df_a <- LinkMap( data.frame(a = c("a_1", "a_2"), b = c("b_5", "b_4")) )
df_b <- LinkMap( data.frame(b = c("b_3", "b_2"), a = c("a_3", "a_4")) )
df_c <- LinkMap( data.frame(a = c("a_5"), b = c("b_1")) )
#
x <- list(df_a, df_b, df_c)

test_that("MultiFactor merges duplicate and conflicting LinkMaps", {

    expect_identical(levels(MultiFactor:::.merge_linkmaps(x)[[1L]]),
                     list(
                         a = c("a_1", "a_2", "a_3", "a_4", "a_5"),
                         b = c("b_4", "b_5", "b_2", "b_3", "b_1")
                     )
    )
}
)

test_that("<Not implemented> MultiFactor Correctly orders duplicated levels", {

# Not impplemented yet
expect_identical(levels(MultiFactor(x)),
                 list(
                     a = c("a_1", "a_2", "a_3", "a_4", "a_5"),
                     b = c("b_1", "b_1", "b_3", "b_4", "b_5"))
                 )

}
)

