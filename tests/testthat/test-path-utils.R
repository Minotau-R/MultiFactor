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





# Only two formats (formula & list) can express complex paths
c_fm <- a + b ~ c + d ~ d + e
c_ls <- list(c("a", "b"), c("c", "d"), c("d", "e"))

c_list <- list(c_fm, c_ls)


