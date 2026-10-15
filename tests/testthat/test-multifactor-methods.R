x <- data.frame(
    a = sample(letters[seq(3)], 10, replace = TRUE),
    A = sample(LETTERS[seq(3)], 10, replace = TRUE)
)

test_that("Intermediate linkmap is identical to immediate multifactor", {

mf1 <- x |> linkmap() |> multifactor()
mf2 <- x |> multifactor()

  expect_identical(mf1, mf2)
})


df_a <- linkmap( data.frame(a = c("a_2", "a_1"), b = c("b_5", "b_4")) )
df_b <- linkmap( data.frame(b = c("b_3", "b_2"), a = c("a_4", "a_3")) )
df_c <- linkmap( data.frame(a = c("a_5"), b = c("b_1")) )

x <- list(df_a, df_b, df_c)


test_that("multifactor correctly merges conflicting linkmaps, orders levels", {

  expect_identical(levels(multifactor(x)),
                   list(
                     a = c("a_1", "a_2", "a_3", "a_4", "a_5"),
                     b = c("b_1", "b_2", "b_3", "b_4", "b_5"))
  )


  expect_identical(levels(c(multifactor(x),  multifactor(rev(x)))),
                   list(
                     a = c("a_1", "a_2", "a_3", "a_4", "a_5"),
                     b = c("b_1", "b_2", "b_3", "b_4", "b_5"))
  )


}
)
