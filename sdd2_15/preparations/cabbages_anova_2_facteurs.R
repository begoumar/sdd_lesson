SciViews::R

## Import data

cabbages <- read("cabbages", package = "MASS", lang = "fr")

.?cabbages
skimr::skim(cabbages)

cabbages %>.%
  rename(., cultivar = Cult, date = Date, head_wt = HeadWt, vit_c = VitC) -> cabbages

## Add labels and units
cabbages <- labelise(cabbages, self = FALSE,
                       label = list(
                         cultivar = "Cultivar",
                         date = "Date de plantation",
                         head_wt = "Masse du choux",
                         vit_c = "Teneur en acide ascorbique"),
                       units = list(
                         cultivar = NA,
                         date = NA,
                         head_wt = "kg",
                         vit_c = NA),
                       as_labelled = as_labelled)

# Anova 2 factors ---
anova(anova. <- lm(data = cabbages, head_wt ~ cultivar * date))
#plot(anova., which = 2)
#residuals(anova.)
car::qqPlot(residuals(anova.), distribution = "norm",
            envelope = 0.95, col = "Black", ylab = "residuals")

# homoscedasticite - HeadWt
bartlett.test(head_wt ~ cultivar, data = cabbages)
bartlett.test(head_wt ~ date, data = cabbages)

# HeadWt
summary(anovaComp. <- confint(multcomp::glht(anova.,
                                             linfct = multcomp::mcp(cultivar = "Tukey", date = "Tukey")))) # Add a second factor if you want
.oma <- par(oma = c(0, 5.1, 0, 0)); plot(anovaComp.); par(.oma); rm(.oma)

## Next step  filter data by cultivar
#TODO
