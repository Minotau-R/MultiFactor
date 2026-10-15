# Convert common classes to linkmap or multifactor

`as_linkmap` and `as_multifactor `convert the input object(s) to a
`linkmap` and a `multifactor`, respectively.

## Arguments

- x:

  `data.frame`, `list` or `logical matrix`. Input object(s) to convert
  to `linkmap` or `multifactor`.

- y:

  `Character vector`. The vector of elements to use as feature names
  along with `x` if the latter is an unnamed list. (Default: `NULL`).

- edge.names:

  `Character vector`. A vector of two elements specifying the names of
  the edges in the output `linkmap`. (Default: `NULL`).

## Value

`as_linkmap` returns a `linkmap` where each row contains a unique
combination of the elements in `x` (and `y` for an unnamed list).
`as_multifactor` returns a `multifactor`

## Examples

``` r
# Create list with random linkage
lst <- lapply(1:3, function(x) sample(letters[seq(3)], 3, replace = TRUE))
names(lst) <- LETTERS[seq(3)]

# Convert to linkmap
a2b <- as_linkmap(lst, edge.names = c("a", "b"))

# Create adjacency matrix
mat <- matrix(sample(c(TRUE, FALSE), 3 * 3, replace = TRUE), nrow = 3)
rownames(mat) <- LETTERS[seq(3)]
colnames(mat) <- c("x", "y", "z")

# Convert adjacency matrix to linkmap
b2c <- as_linkmap(mat, edge.names = c("b", "c"))

# Convert list of lists, matrices or data.frames to multifactor
mf <- as_multifactor(list(X1 = lst, X2 = mat))
```
