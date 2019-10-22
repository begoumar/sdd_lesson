# R pour les Data Sciences, exercice 3, Chap 15, p.277
# Ecrivez une function `fizzbuzz()` qui prend un seul nombre en entrée. S'il
# est divisible par 3, renvoyer "fizz", par 5 renvoyer "buzz", par 3 et par 5
# renvoyer "fizzbuzz", sinon renvoyer le nombre.
fizzbuzz <- function(n) {
  if (!length(n) == 1)
    stop("Un et un seul nombre peut être fourni dans `n`")
  if (is.na(n))
    stop("Valeurs manquantes non autorisées dans 'n'")
  if (!is.numeric(n))
    stop("'n' doit être un nombre")
  if (!is.finite(n))
    stop("'n' doit être un nombre fini")

  res <- ""
  if (n %% 3 == 0)
    res <- "fizz"
  if (n %% 5 == 0)
    res <- paste0(res, "buzz")
  if (nchar(res) < 4)
    res <- n
  res
}


fizzbuzz <- function(n) {
  res <- paste(c("fizz", "buzz")[!as.logical(n %% c(3, 5))], collapse = "")
  if (nchar(res)) res else n
}
fizzbuzz(6)
fizzbuzz(10)
fizzbuzz(15)
fizzbuzz(7)

fizzbuzz(2:3)
fizzbuzz(0)
fizzbuzz(-7)
fizzbuzz(-6)
fizzbuzz(-10)
fizzbuzz(-15)
fizzbuzz(Inf)
fizzbuzz(-Inf)
fizzbuzz(NA)
fizzbuzz(NaN)

fizzbuzz(TRUE)
fizzbuzz("3")
fizzbuzz(ls)

