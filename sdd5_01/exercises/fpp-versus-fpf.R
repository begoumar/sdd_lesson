SciViews::R

seek_sequence <- function(sequence, n = 1e4, m = 100) {
  sample(c("F", "P"), n * m, replace = TRUE) %>.%
    matrix(., ncol = m, nrow = n) %>.%
    apply(., 1, paste, collapse = "") %>.%
    regexpr(sequence, .) %>.%
    mean(.) %>.%
    round(.) + nchar(sequence) - 1
}

set.seed(4363)
seek_sequence("FPP")
seek_sequence("FPF")




# Optimisation de la place en mémoire
# ... on repart d'où on était dans la série!
seek_sequence2 <- function(sequence, n = 1e6) {
  sample(c("F", "P"), n, replace = TRUE) %>.%
    paste(., collapse = "") %>.%
    gregexpr(sequence, .)[[1]] %>.%
    diff(.) %>.%
    mean(.) %>.%
    round(.)
}

set.seed(3631)
seek_sequence2("FPP")
seek_sequence2("FPF")

