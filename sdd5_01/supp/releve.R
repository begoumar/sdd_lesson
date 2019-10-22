# Jeu de données releve du package pastecs
# Ecrire une fonction qui:
# - fait deux graphiques l'un au dessus de l'autre de deux des colonnes du
#   tableau avec les graphes de base. Utiliser plot(, type = "l")
# - permettre de modifier la couleur, et l'épaisseur du trait sur les deux
#   graphiques simultanément, voire d'autres paramètres graphiques
# - restaurer le système en sortie avec on.exit()
# - trouver un nom adéquat à la fonction
library(pastecs)
data(releve)
head(releve)
# ?par  mfrow
plot(releve$Day, releve$Astegla, type = "l")

dual_plot <- function(data, x_lab = "Day", y_lab1, y_lab2, ...) {
  # Check the arguments
  if (!is.data.frame(data))
    stop("'data' doit être un data.frame")
  x_lab <- as.character(x_lab)[1] # Keep only first item
  y_lab1 <- as.character(y_lab1)[1]
  y_lab2 <- as.character(y_lab2)[1]
  if (!all(c(x_lab, y_lab1, y_lab2) %in% names(data)))
    stop("'x_lab', 'y_lab1' et 'y_lab2' doivent être des variables de 'data'")

  # Change system, but make sure to restore it on exit
  opar <- par(mfrow = c(2, 1))
  on.exit(par(opar)) # Retore the system on exit

  # Create the two plots
  plot(data[[x_lab]], data[[y_lab1]], xlab = x_lab, ylab = y_lab1, type = "l", ...)
  plot(data[[x_lab]], data[[y_lab2]], xlab = x_lab, ylab = y_lab2, type = "l", ...)
}

dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Chae")
dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Chae", col = "red")
dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Chae", lwd = 2, col = "red")
dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Chae", strange_arg = TRUE)
dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Nonexist")

# Système restauré?
plot(releve$Day, releve$Astegla, type = "l") # OK

# Ajouter un titre principal (autre argument)
dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Chae", main = "Phytoplancton")

# - Comment ne mettre un titre qu'au dessus du premier graphique?
dual_plot <- function(data, x_lab = "Day", y_lab1, y_lab2, main = "", ...) {
  # Check the arguments
  if (!is.data.frame(data))
    stop("'data' doit être un data.frame")
  x_lab <- as.character(x_lab)[1] # Keep only first item
  y_lab1 <- as.character(y_lab1)[1]
  y_lab2 <- as.character(y_lab2)[1]
  if (!all(c(x_lab, y_lab1, y_lab2) %in% names(data)))
    stop("'x_lab', 'y_lab1' et 'y_lab2' doivent être des variables de 'data'")

  # Change system, but make sure to restore it on exit
  opar <- par(mfrow = c(2, 1))
  on.exit(par(opar)) # Retore the system on exit

  # Create the two plots
  plot(data[[x_lab]], data[[y_lab1]], xlab = x_lab, ylab = y_lab1, type = "l",
    main = main, ...)
  plot(data[[x_lab]], data[[y_lab2]], xlab = x_lab, ylab = y_lab2, type = "l", ...)
}

dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Chae")
dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Chae", main = "Pythoplancton")

# - argument cols qui précise les deux couleurs
dual_plot <- function(data, x_lab = "Day", y_lab1, y_lab2,
cols = c("red", "blue"), main = "", ...) {
  # Check the arguments
  if (!is.data.frame(data))
    stop("'data' doit être un data.frame")
  x_lab <- as.character(x_lab)[1] # Keep only first item
  y_lab1 <- as.character(y_lab1)[1]
  y_lab2 <- as.character(y_lab2)[1]
  if (!all(c(x_lab, y_lab1, y_lab2) %in% names(data)))
    stop("'x_lab', 'y_lab1' et 'y_lab2' doivent être des variables de 'data'")

  # Change system, but make sure to restore it on exit
  opar <- par(mfrow = c(2, 1))
  on.exit(par(opar)) # Retore the system on exit

  # Make sure to have two colors
  cols <- rep(cols, len = 2)
  # Create the two plots
  plot(data[[x_lab]], data[[y_lab1]], xlab = x_lab, ylab = y_lab1, type = "l",
    col = cols[1], main = main, ...)
  plot(data[[x_lab]], data[[y_lab2]], xlab = x_lab, ylab = y_lab2, type = "l",
    col = cols[2], ...)
}

dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Chae")
dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Chae", cols = c("green", "violet"))
dual_plot(releve, y_lab1 = "Astegla", y_lab2 = "Chae", cols = "green")
