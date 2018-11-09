# Analyse du jeu de données eucalyptus

## Load package ----
SciViews::R
library(forcats)
## Import data ----
eucalyptus <- read.table("sdd2_15/data/eucalyptus.txt",header=T,sep=";")
eucalyptus$bloc <- as.factor(eucalyptus$bloc)


eucalyptus %>.%
  rename(., id = numero, height = ht, circumference = circ) %>.%
  mutate(., circumference = circumference/100) %>.%
  select(., -clone)-> eucalyptus

eucalyptus <- labelise(eucalyptus, self = FALSE,
                     label = list(
                       id = "Code d'identification",
                       height = "Hauteur",
                       circumference = "Circonférence à 1.50 m du sol",
                       bloc = "Zone d'échantillonage"),
                     units = list(
                       id = NA,
                       height = "m",
                       circumference = "m",
                       bloc = NA),
                     as_labelled = as_labelled)


## short table

knitr::kable(eucalyptus[ c(1, 110, 210, 610, 1010, 1410), ], col.names = c("Id", "Hauteur", "Circonférence", "Bloc"),align = 'c', caption = "Quelques lignes du tableau de données eucalyptus")

eucalyptus %>.%
  filter(., bloc == "1") -> test


## write data in rds file ---
getOption("read_write") # choose the best format to save data
# ?readr::write_rds # I choose rds and i compress with xz
# write(x = eucalyptus, file = "sdd2_15/data/eucalyptus.rds" , type = "rds", compress = "xz")

## import rds
rm(eucalyptus)
eucalyptus <- read(file = "sdd2_15/data/eucalyptus.rds") ## You must be specify type read$rds

## correlation
correlation(eucalyptus[, 2:3], use = "complete.obs", method = "pearson")

## Visu
chart(eucalyptus, height~ circumference)+
  geom_point()

chart(eucalyptus, height~ log(circumference))+
  geom_point()

##  linear models 1 ----

summary(lm1 <- lm(data = eucalyptus, height ~ circumference))
lm1 %>.% (function (lm, model = lm[["model"]], vars = names(model))
  chart(model, aes_string(x = vars[2], y = vars[1])) +
  geom_point() +
  stat_smooth(method = "lm", formula = y ~ x))(.)
### Check the normality and residus
lm1 %>% qplot(.fitted, .resid, data = .) +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab("Residuals") +
  ggtitle("Residuals vs Fitted")

lm1 %>% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

lm1 %>% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")


##  linear models 2 ----

eucalyptus$circumference_log <- log(eucalyptus$circumference)

summary(lm2 <- lm(data = eucalyptus, height ~ circumference_log))
lm2 %>.% (function (lm, model = lm[["model"]], vars = names(model))
  chart(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() +
    stat_smooth(method = "lm", formula = y ~ x))(.)

### Check the normality and residus
lm2 %>% qplot(.fitted, .resid, data = .) +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab("Residuals") +
  ggtitle("Residuals vs Fitted")

lm2 %>% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

lm2 %>% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

## linear model 3 ---
summary(lm3 <- lm(data = eucalyptus, height ~ circumference +I(sqrt(circumference))))
lm3 %>.% (function (lm, model = lm[["model"]], vars = names(model))
  chart(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() +
    stat_smooth(method = "lm", formula = y ~ x +I(sqrt(x))))(.)

### Check the normality and residus
lm3 %>% qplot(.fitted, .resid, data = .) +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab("Residuals") +
  ggtitle("Residuals vs Fitted")

lm3 %>% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

lm3 %>% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

## AIC ----
AIC(lm1, lm2, lm3) ### check the smallest values
