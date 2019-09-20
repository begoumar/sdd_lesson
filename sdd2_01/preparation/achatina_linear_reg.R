# Analyse Achatina achatina (voir Van Osselaer & Grosjean, 2000, Fig. 9)
# coils = nombre de tours de coquille (sans unité)
# radius = rayon de la suture mesuré depuis le point de référence (apex) en mm
# shell = type de coquille, juvénile (protoconch) ou adulte (teleoconch)
SciViews::R
achatina <- read_csv("sdd2_15/data/achatina.csv")
achatina$shell <- as.factor(achatina$shell)

library("tidyverse")
achatina %>% ggplot() +
  geom_point(mapping = aes(x = coils, y = radius, col = shell)) +
  ylab("radius (mm)")

achatina %>% ggplot() +
  geom_point(mapping = aes(x = coils, y = log10(radius), col = shell)) +
  ylab("log(radius in mm)")

# Utiliser deux régressions différentes pour proto et téléo,
# et noter la composante sinusoidale dans les résidus
# ...

achatina1 <-filter(achatina, shell == "protoconch")
achatina2 <-filter(achatina, shell == "teleoconch")

achatina1 %>% ggplot() +
  geom_point(mapping = aes(x = coils, y = radius, col = shell)) +
  ylab("radius (mm)")

library("dplyr")
summary(lm <- lm(radius ~ coils, data = achatina1))
lm %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() + stat_smooth(method = "lm", formula = y ~ x))



reg <- lm(radius~coils,data=achatina)
summary(reg)

library("dplyr")
summary(lm <- lm(radius~coils, data = achatina))
lm %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() + stat_smooth(method = "lm", formula = y ~ x))


reg <- lm(radius~coils,data=achatina1)
summary(reg)

library("dplyr")
summary(lm <- lm(radius~coils, data = achatina1))
lm %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() + stat_smooth(method = "lm", formula = y ~ x))

library("dplyr")
summary(lm <- lm(radius~coils, data = achatina1))
lm %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() + stat_smooth(method = "lm", formula = y ~ x))

reg <- lm(radius~coils,data=achatina2)
summary(reg)

library("dplyr")
summary(lm <- lm(radius~ coils + I(coils^2), data = achatina2))
lm %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() + stat_smooth(method = "lm", formula = y ~ x+I(x^2)))

ggplot(achatina)+
  geom_point(mapping = aes(x = coils, y= radius, color = shell))+
  geom_smooth(data = achatina1, mapping = aes(x = coils, y= radius), method = "lm", formula = y ~ x) +
  geom_smooth(data = achatina2, mapping = aes(x = coils, y= radius), method = "lm", formula = y ~ x+I(x^2))


achatina2 %>% ggplot() +
  geom_point(mapping = aes(x = coils, y = radius, col = shell)) +
  ylab("radius (mm)")
