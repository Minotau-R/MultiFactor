# Convert common classes to LinkMap or MultiFactor

`as.LinkMap` and `as.MultiFactor `convert the input object(s) to a
`LinkMap` and a `MultiFactor`, respectively.

## Arguments

- x:

  `data.frame`, `list` or `logical matrix`. Input object(s) to convert
  to `LinkMap` or `MultiFactor`.

- y:

  `Character vector`. The vector of elements to use as feature names
  along with `x` if the latter is an unnamed list. (Default: `NULL`).

- edge.names:

  `Character vector`. A vector of two elements specifying the names of
  the edges in the output `LinkMap`. (Default: `NULL`).

## Value

`as.LinkMap` returns a `LinkMap` where each row contains a unique
combination of the elements in `x` (and `y` for an unnamed list).
`as.MultiFactor` returns a `MultiFactor`

## Examples

``` r
# Create list with random linkage
lst <- lapply(1:3, function(x) sample(letters[seq(3)], 3, replace = TRUE))
names(lst) <- LETTERS[seq(3)]

# Convert to LinkMap
a2b <- as.LinkMap(lst, edge.names = c("a", "b"))

# Create adjacency matrix
mat <- matrix(sample(c(TRUE, FALSE), 3 * 3, replace = TRUE), nrow = 3)
rownames(mat) <- LETTERS[seq(3)]
colnames(mat) <- c("x", "y", "z")

# Convert adjacency matrix to LinkMap
b2c <- as.LinkMap(mat, edge.names = c("b", "c"))

# Convert list of lists, matrices or data.frames to MultiFactor
mf <- as.MultiFactor(list(X1 = lst, X2 = mat))
```
