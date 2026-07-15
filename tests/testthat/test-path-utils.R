# Create equivalent paths in different formats
p_fm <- a ~ b ~ c ~ b ~ a
p_ch <- c("a", "b", "c", "b", "a")
p_ls <- as.list(p_ch)
p_df <- data.frame(
    c("a", "b", "c", "b"),
    c("b", "c", "b", "a"),
    fix.empty.names = FALSE
)

p_list <- list(p_fm, p_ch, p_ls, p_df)


test_that("Ordinary .check_path() classes are equivalent", {
    res <- do.call(rbind.data.frame, lapply(p_list, .check_path))

    expect_all_true(res$info == "detailed")
    expect_all_false(res$complex)
    expect_identical(res$class, c("formula", "character", "list", "data.frame"))
})


# Only two formats (formula & list) can express complex paths
c_fm <- a + b ~ c + d ~ d + e
c_ls <- list(c("a", "b"), c("c", "d"), c("d", "e"))

c_list <- list(c_fm, c_ls)

test_that("Complex .check_path() classes are equivalent", {
    res <- do.call(rbind.data.frame, lapply(c_list, .check_path))
    expect_all_true(res$info == "detailed")
    expect_all_true(res$complex)
    expect_identical(res$class, c("formula", "list"))
})
