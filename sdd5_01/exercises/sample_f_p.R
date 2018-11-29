
sample_seq <- function(n = 100)
  sample(c("F", "P"), n, replace = TRUE)

sample_seq2 <- function(n = 100) {
  x <- rnorm(n, mean = 0)
  ifelse(x < 0, "F", "P")
}

sample_seq3 <- function(n = 100) {
  x <- rnorm(n, mean = 0)
  y <- rep("P", n)
  y[x < 0] <- "F"
  y
}

res <- bench::mark({sample_seq(); 1},
                   {sample_seq2(); 1},
                   {sample_seq3(); 1})
