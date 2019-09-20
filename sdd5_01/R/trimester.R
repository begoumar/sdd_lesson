# Fonction pour calculer les trimestres depuis les mois
# Philippe Grosjean (philippe.grosjean@umons.ac.be), licence MIT
#
# TODO: ...

V <- c(1, 3, 6, 4, 8, 10, 8, 9)
V2 <- 1:12


# Fonction avec boucles et if ---------------------------------------------

trimester <- function(x) {
  res <- integer(0)
  for (i in 1:length(x)) {
    if (x[i] < 4) {
      res[i] <- 1
    } else if (x[i] < 7) {
      res[i] <- 2
    } else if (x[i] < 10) {
      res[i] <- 3
    } else res[i] <- 4
  }
  res
}
trimester(V)
trimester(V2)

trimester1 <- function(x) {
  ifelse(x < 4, 1,
    ifelse(x < 7, 2,
      ifelse(x < 10, 3, 4)
    )
  )
}
trimester1(V)

# Fonction avec %in% ------------------------------------------------------

trimester2 <- function(x) {
  res <- integer(length(x))
  # %in% détermine si les éléments de gauche se trouvent dans
  # la liste de droite
  res[x %in% 1:3] <- 1
  res[x %in% 4:6] <- 2
  res[x %in% 7:9] <- 3
  res[x %in% 10:12] <- 4
  res
}
trimester2(V)
trimester2(V2)


# Benchmark ---------------------------------------------------------------

set.seed(7434989)
V3 <- sample(1:12, 10000, replace = TRUE)

bench::mark(trimester(V3), trimester2(V3))


# Par calcul --------------------------------------------------------------

trimester3 <- function(x) {
  (x + 2) %/% 3
}
trimester3(V)

bench::mark(trimester(V3), trimester2(V3), trimester3(V3))



# Par indiçage ------------------------------------------------------------

trimester4 <- function(x) {
  rep(1:4, each = 3)[x]
}
trimester4(V)

bench::mark(trimester(V3), trimester1(V3), trimester2(V3), trimester3(V3), trimester4(V3))


# Tests et programmation défensive ----------------------------------------

trimester2 <- function(x) {
  if (!is.numeric(x))
    stop("'x' must be numeric")
  if (any(x < 1 | x > 12))
    stop("'x' must be between 1 and 12")
  x2 <- as.integer(x)
  if (any(x != x2))
    warning("Non integer values (rounded down)")
  x <- x2

  res <- integer(length(x))
  # %in% détermine si les éléments de gauche se trouvent dans
  # la liste de droite
  res[x %in% 1:3] <- 1
  res[x %in% 4:6] <- 2
  res[x %in% 7:9] <- 3
  res[x %in% 10:12] <- 4
  res
}


library(testthat)
expect_equal(trimester2(1:12),
  c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4))
# N'accepte pas autre chose que des nombres
expect_error(trimester2("a"))
# Nombres qui ne sont pas entre 1 et 12 ne sont pas acceptés
expect_error(trimester2(-1))
expect_error(trimester2(13))
# Nombres non entiers acceptés avec warning
expect_equal(trimester2(c(1.5, 3.9, 4.1)),
  c(1, 1, 2))
expect_warning(trimester2(c(1.5, 3.9, 4.1)))
