SciViews::R

# Jeu de données trees
# diametre du tronc à 1,4m de haut (en cm), hauteur (en m), volume de bois (en m^3)

trees <- read("trees", package = "datasets", lang = "fr")

# Description des données
summary(trees)
cor(trees, use = "complete.obs", method = "pearson")

# Représentation graphique
GGally::ggscatmat(trees)
corrplot::corrplot(cor(trees,
  use = "pairwise.complete.obs"), method = "ellipse")

# Regression linéaire simple du volume en fonction du diamètre
summary(lm.1 <- lm(data = trees, volume ~ diameter))
lm.1 %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() + stat_smooth(method = "lm", formula = y ~ x))

# ANOVA associée à la régression
anova(lm.1)


# Régression multiple -----------------------------------------------------
summary(lm.2 <- lm(data = trees, volume ~ diameter + height))

# Représentation graphique: nécessite 3D, ne fonctionne pas à partir de R Studio Server!)
#car::scatter3d(trees$diameter, trees$volume, trees$height, fit = "linear",
#  residuals = TRUE, bg = "white", axis.scales = TRUE, grid = TRUE,
#  ellipsoid = FALSE, xlab = "Diametre", ylab = "Volume", zlab = "Hauteur")

# Modèle plus complexe multiple et polynomial
summary(lm.3 <- lm(data = trees, volume ~ diameter + I(diameter^2)))
lm.3 %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
  geom_point() + stat_smooth(method = "lm", formula = y ~ x + I(x^2)))


# En utilisant les deux variables
lm.4 <- lm(data = trees, volume ~ diameter + I(diameter^2) + height + I(height^2))
summary(lm.4, correlation = FALSE, symbolic.car = FALSE)

# Attention: ne fonctionne pas dans R Studio Server!
#car::scatter3d(trees$diameter, trees$volume, trees$height, fit = "quadratic",
#  residuals = TRUE, bg = "white", axis.scales = TRUE, grid = TRUE,
#  ellipsoid = FALSE, xlab = "Diametre", ylab = "Volume", zlab = "Hauteur")

# Simplification du modèle
trees_simple <- lm(data = trees, volume ~ I(diameter^2) + 0)
summary(trees_simple)

# Autre possibilité
trees %>% mutate(diameter2 = diameter^2) -> trees
summary(lm.5 <- lm(data = trees, volume ~ diameter2 + 0))
lm.5 %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
  geom_point() + stat_smooth(method = "lm", formula = y ~ x + 0))


# Graphe et analyse des résidus du modèle 4
#plot(lm.4, which = 1)
lm.4 %>% qplot(.fitted, .resid, data = .) +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab("Residuals") +
  ggtitle("Residuals vs Fitted")

#plot(lm.4, which = 2)
lm.4 %>% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm.4, which = 3)
lm.4 %>% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

#plot(lm.4, which = 5)
lm.4 %>.%
  chart(broom::augment(.), .std.resid ~ .hat %size=% .cooksd) +
  geom_point() +
  geom_smooth(se = FALSE, size = 0.5, method = "loess", formula = y ~ x) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  labs(x = "Leverage", y = "Standardized residuals") +
  ggtitle("Residuals vs Leverage")

#plot(lm.4, which = 6)
lm.4 %>.%
  chart(broom::augment(.), .cooksd ~ .hat %size=% .cooksd) +
  geom_point() +
  geom_vline(xintercept = 0, colour = NA) +
  geom_abline(slope = seq(0, 3, by = 0.5), colour = "darkgray") +
  geom_smooth(se = FALSE, size = 0.5, method = "loess", formula = y ~ x) +
  labs(x = expression("Leverage h"[ii]), y = "Cook's distance") +
  ggtitle(expression("Cook's dist vs Leverage h"[ii]/(1-h[ii])))


## Choix du modèle avec le critère d'Akaike
AIC(lm.1) # Linéaire simple avec Diamètre
AIC(lm.2) # Linéaire multiple diamètre et Hauteur
AIC(lm.3) # Polynômiale Diamètre
AIC(lm.4) # Polynômiale Diamètre et Hauteur
AIC(lm.5) # Modèle simplifié avec diamètre^2 seulement

AIC(lm.1, lm.2, lm.3, lm.4, lm.5)
