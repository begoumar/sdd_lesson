SciViews::R

cabbages <- read("cabbages", package = "MASS", lang = "fr")
.?cabbages
skimr::skim(cabbages)

anova(anova. <- lm(data = cabbages, HeadWt ~ Cult * Date))
#plot(anova., which = 2)
#residuals(anova.)
car::qqPlot(residuals(anova.), distribution = "norm",
            envelope = 0.95, col = "Black", ylab = "residuals")

# homoscedasticite - HeadWt
bartlett.test(HeadWt ~ Cult, data = cabbages)
bartlett.test(HeadWt ~ Date, data = cabbages)

# HeadWt
summary(anovaComp. <- confint(multcomp::glht(anova.,
                                             linfct = multcomp::mcp(Cult = "Tukey", Date = "Tukey")))) # Add a second factor if you want
.oma <- par(oma = c(0, 5.1, 0, 0)); plot(anovaComp.); par(.oma); rm(.oma)
