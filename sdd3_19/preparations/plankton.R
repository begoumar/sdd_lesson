# plankton analysis
# package-----
SciViews::R
library(MASS)

#plankton <- readr::read_csv("sdd3_19/data/plankton_set.csv")
test <- data.io::read("sdd3_19/data/plankton_set.csv")

test$Class <- as.factor(test$Class)

n <- nrow(test)
n_learning <- round(n * 2/3)
set.seed(164)

learning <- sample(1:n, n_learning)
learning
test_learn <- test[learning, ]
nrow(test_learn)
summary(test_learn)
test_test <- test[-learning, ]
nrow(test_test)
summary(test_test)

# Ou plus court si on utilise toutes les variables du tableau
test_lda <- lda(formula = Class ~ ., data = test_learn)
test_lda
plot(test_lda, col = as.numeric(test_learn$Class))


## Phase 2 : test - Matrice de confusion et métriques
# Obtenir les coordonnées des points pour les composantes de l'ADL
test_test_pred <- predict(test_lda, test_test)
plot(test_test_pred$x[, 1], test_test_pred$x[, 2], col = test_test$Class)

# Obtenir les classes prédites par l'ADL
test_test_class <- predict(test_lda, test_test)$class
test_test_class

# Matrice de confusion
test_conf <- table(Manuel = test_test$Class, Auto = test_test_class)
test_conf

# Taux global de reconnaissance
acc_test <- (sum(diag(test_conf)) / sum(test_conf)) * 100
acc_test

# Taux d'erreur
100 - acc_test
