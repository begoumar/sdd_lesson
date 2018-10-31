# Analyse du jeu de données schizo.txt
# Guyliann Engels
# 31 octobre 2018

## Metadata ----
## Un test d’activité cérébrale est réalisé sur un patient quotidiennement durant 120jours.
## Au jour 60, les médécins lui prescrivent le médicament.
## Le nouveau médicament a t’il un effet sur l’activité cérébrale du patient étudié ?

## Package ----
library(pastecs)

# Analyse ----
## Import
schizo <- read.table(file = "sdd3_18/data/raw/schizo.txt", header = TRUE)
class(schizo) # c'est un  data.frame
#transformation en time série, donc on sélectionne la variable d'intérêt, donc le pas de temps est de 1 par jour, on ne connait pas le début de l'expérience (start)
schizo.ts <- ts(schizo$schizo, deltat = 1)
class(schizo.ts) #schizo est bien transformé en time serie

# commencer par afficher le graphe de la ts.
plot(schizo.ts, ylab = "activité cérébrale", xlab = "temps (jour)")



start(schizo.ts)
end(schizo.ts)
frequency(schizo.ts)
# C'est un vecteur de nombres de 1 a 120
# avec un attribut tsp depart, fin et fréquence
# unité jour => 1 observation par unité de temps
time(schizo.ts)
acf(schizo.ts)


# statistique glissante
slschizo <- stat.slide(1:120, schizo.ts, deltat = 10)
plot(slschizo, stat = "mean", ylab = "activité cérébrale", xlab = "temps (jour)")
lines(slschizo, stat = "median")

# tendance générale
trend.test(schizo.ts)
trend <- trend.test(tseries = schizo.ts, R = 999)
#rho est la valeur origanal par le test de spearman, si c'est lié au hasard, cela varie autour de zéro
plot(trend)
trend$p.value

# tendance locale
loc_schizo <- local.trend(schizo.ts)
#identify(loc_schizo)

# analyse spectrale
par(mfrow = c(1,2))
spectrum(schizo.ts)
spectrum(schizo.ts, spans = c(3,7))
par(mfrow = c(1,1))

