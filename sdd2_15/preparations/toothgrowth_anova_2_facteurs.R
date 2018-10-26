SciViews::R
tooth <- read("ToothGrowth", package = "datasets", lang ="fr")

tooth$dose <- as.factor(tooth$dose)
tooth$dose1 <-as.ordered(tooth$dose)

tooth %>.%
  group_by(., supp, dose) %>.%
  summarise(., mean = mean(len), sd = sd(len), count = sum(!is.na(len)))

chart(data = tooth, len ~ supp %col=% dose) +
  geom_jitter(alpha = 0.4, position = position_dodge(0.4)) +
  stat_summary(geom = "point", fun.y = "mean", position = position_dodge(0.4)) +
  stat_summary(geom = "errorbar", width = 0.1, position = position_dodge(0.4),
    fun.data = "mean_cl_normal", fun.args = list(conf.int = 0.95))

anova(anova. <- lm(data = tooth, len ~ supp * dose))
#anova(anova. <- lm(data = tooth, len ~ supp * dose1))

bartlett.test(len ~ supp, data = tooth)
bartlett.test(len ~ dose, data = tooth)
# homogénéité des variances au seuil de significativité alpha = 5%


summary(anovaComp. <- confint(multcomp::glht(anova.,
  linfct = multcomp::mcp(dose = "Tukey", supp = "Tukey")))) # Add a second factor if you want
.oma <- par(oma = c(0, 5.1, 0, 0)); plot(anovaComp.); par(.oma); rm(.oma)

plot(anova., which = 2)

# anova. %>.%
#   chart(broom::augment(.), aes(sample = .std.resid)) +
#   geom_qq() +
#   geom_qq_line(colour = "darkgray") +
#   labs(x = "Theoretical quantiles", y = "Standardized residuals") +
#   ggtitle("Normal Q-Q")


car::qqPlot(residuals(anova.), distribution = "norm",
            envelope = 0.95, col = "Black", ylab = "residuals")


