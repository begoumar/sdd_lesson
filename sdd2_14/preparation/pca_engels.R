SciViews::R


# crabs #######
crabs <- read("crabs", package = "MASS", lang = "fr")

crab1 <- pcomp(crabs[ , c(4:8)], scale = TRUE)


summary(crab1, loadings = FALSE)
screeplot(crab1, type = "barplot", col = "Grey")

plot(crab1,which = "load")
plot(crab1,which = "scores")

## all variances is covered by dominant axis. I choose to mutate variable.
.? crabs

crabs%>.%
  mutate(., front2 = front/length, rear2 = rear/length, width2 = width/length,
         depth2 = depth/length) -> crabs

crab2 <-pcomp(crabs[, c(9:12)], scale = TRUE)

summary(crab2, loadings = FALSE)

plot(crab2, which = "cor", choices = 1:2)
plot(crab2, which = "scores", choices = 1:2)
screeplot(crab2, type = "barplot", col = "Grey")

plot(crab2, which = "scores", col = as.integer(crabs$species))

crabs %>% unite(col = groups, species, sex, sep = "_", remove = FALSE) -> crabs
crabs$groups <- as.factor(crabs$groups)

plot(crab2,which = "scores", col = as.integer(crabs$groups))

# Marphy #####
marphy <- read("marphy", package = "pastecs")

marphy_acp <- pcomp(marphy, scale = TRUE)
summary(marphy_acp, loadings = FALSE)

screeplot(marphy_acp)
plot(marphy_acp, which = "load", choices = 1:2)
plot(marphy_acp, which = "scores", choices = 1:2)

# Marbio ####

marbio <- read("marbio", package = "pastecs")

marbio_acp <- pcomp(marbio, scale = TRUE)
summary(marbio_acp, loadings = FALSE)
screeplot(marbio_acp)
plot(marbio_acp, which = "load", choices = 1:2)
plot(marbio_acp, which = "scores",  choices = 1:2)
