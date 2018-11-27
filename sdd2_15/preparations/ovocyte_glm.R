# Maturation d'obovyte
cont <-  c(rep("4", 40), rep("3", 40), rep("2", 40),rep("1", 40), rep("0.5", 40), rep("0.25", 40),rep("0", 40))
vec <- c(rep("1", 40), rep("2", 40), rep("3", 40),rep("4", 40), rep("5", 40), rep("6", 40),rep("7", 40))
mature <-c(rep("1", 40),
           rep("1", 24), rep("0", 16),
           rep("1", 17), rep("0", 23),
           rep("1", 12), rep("0", 28),
           rep("1", 9), rep("0", 31),
           rep("1", 4), rep("0", 36),
           rep("0", 40))

ovoini <- data.frame(conc = cont, ind = vec , mat = mature)
ovoini$conc <- as.numeric(as.character(ovoini$conc))
ovoini$mat <- as.numeric(as.character(ovoini$mat))
ovoini$ind <- as.character(ovoini$ind)

ovoini <- labelise(ovoini, self = FALSE,
                   label = list(
                     ind = "Individus",
                     conc = "Concentration en hypoxantine",
                     mat = "Maturation"),
                   as_labelled = as_labelled)

write(ovoini, file = "sdd2_15/data/ovocyte.rds", type = "rds", compress = "xz")

ovoini <- read(file = "sdd2_15/data/ovocyte.rds")

ovoini%>.%
  group_by(., ind, conc) %>%
  summarise(.,  prop = sum(mat)/length(mat), nombre = length(mat))-> ovoini

ovo_glm <- glm(prop ~ conc, family = binomial(link = "logit"), weights = nombre, data = ovoini)
summary(ovo_glm)

plot(ovoini$conc,ovoini$prop)
lines(ovoini$conc,predict(ovo_glm,type="response"), col="red")

ggplot(ovoini, mapping = aes( x = conc, y = prop)) +
  geom_point() +
  geom_line(mapping = aes( x =  conc , y = predict(ovo_glm,type="response")) )
