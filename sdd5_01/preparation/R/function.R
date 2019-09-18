# Fonction qui permet de calculer les trimestres à partir de mois
trimester2 <- function(x){
  if (!is.numeric(x))
    stop("x must be a numeric")
  if(any(x < 1  | x > 12))
    # au moins un résultat est vrai : any
    # tous vrai : all
    stop("x must be between 1 and 12")

  x2 <- as.integer(x)
  if(any(x !=x2))
    warning("non integer values (rounded down)")
  x <- x2

  res <- integer(length(x))
  # détermine si les élements de gauche se trouve dans la liste de droite
  res[x %in% 1:3] <- 1
  res[x %in% 4:6] <- 2
  res[x %in% 7:9] <- 3
  res[x %in% 10:12] <- 4
  res
}

## Exemple
# V <- c(1,3,6,4,8,10,8,9)
# V2 <- sample(1:12, size = 1000, replace = TRUE)
# trimester2(V)
# trimester2(V2)
#

# moyenne

# CV
cv <- function(x){

  if(any(is.na(x)))
    warning("Vector contains NA")

  x <- na.omit(x)
  sd(x)/ mean(x)
}

# CV1

cv1 <- function(x){
  x <- na.omit(x)
  sum(x)/length(x) -> y # calcul de la moyenne
  sum((x-y)^2)/(length(x)-1) -> var
  sqrt(var)/y
}

# CV2
cv2 <- function(x, na.rm = FALSE){
  sd(x, na.rm = na.rm)/ mean(x, na.rm = na.rm)
}


