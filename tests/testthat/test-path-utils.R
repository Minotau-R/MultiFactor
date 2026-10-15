# Create equivalent paths in different formats
p_fm <- a ~ b ~ c : d ~ e : f < 0.5 ~ b ~ a
path_frame(p_fm)

p_list <- list(p_fm, p_ch, p_ls, p_df)

lapply(p_list, path_frame)



# Only two formats (formula & list) can express complex paths
c_fm <- a + b ~ c + d ~ d + e
c_ls <- list(c("a", "b"), c("c", "d"), c("d", "e"))

c_list <- list(c_fm, c_ls)


