#import packages
SciViews::R
# use githubclass room management to import all "urchin_bio" repository
# take each name of the repository
direction <- "~/Documents/assistanat/depot/sdd1_urchin_bio-11-12-2018-04-56-42"
dir(path = direction, full.names = FALSE) -> test
# create a data frame for the exercices
set.seed(284)
organisation <- data_frame(etudiant = sample(test) , correcteur = lag(etudiant))
organisation[1,2] <- organisation[38,1]
# write dataframe

write(organisation, file = "sdd1_08/data/organisation.rds", type = "rds", compress = "xz")
