# Analyse du jeu de données earthq
# Guyliann Engels
# 31 octobre 2018

## Metadata ----
## Les tremblements de terre d’une magnitude supérieur à 7
## sont comptabilisé dans le monde entre 1900 et 1998


## Package ----

library(pastecs)

## analyse ----
earthq<- read.table(file = "sdd3_18/data/raw/earthq.txt", header = TRUE)

earthq.ts <- ts(earthq$earthquake,start = 1900, end = 1998,frequency = 1,  deltat = 1)
class(earthq.ts)
plot(earthq.ts, ylab = "nombre de tremblement de terre", xlab = "temps (année)")


start(earthq.ts)
end(earthq.ts)

slearthq <- stat.slide(time(earthq.ts), earthq.ts, deltat = 5)

slearthq$stat
slearthq$y
slearthq$x
slearthq$xcut

plot(slearthq, stat = "mean", ylab = "nombre de tremblement de terre", xlab = "temps (année)")
lines(slearthq, stat = "median", col = "green")
legend(x = 80, y =  40, c("series", "mean", "median"), col=1:3, lty=1)

## Autocorrélation
acf(earthq.ts)

# Les sommes cumulées avec local.trend()
# Etude de la tendance locale

## tendance locale
loc_earthq <- local.trend(earthq.ts)
## tendance générale
trend <- trend.test(earthq.ts, R = 999)

plot(trend)
trend$p.value

## Analyse spectrale
par(mfrow = c(1,2))
spectrum(earthq.ts)
spectrum(earthq.ts, spans = c(3,7))
par(mfrow = c(1,1))

# Find a bug
library(data.io)

earthq2.ts <- as.matrix(earthq.ts)
tsp(earthq2.ts) <- tsp(earthq.ts)
class(earthq2.ts) <- c("mts", "ts")
trend <- trend.test(earthq2.ts, R = 999)
plot(trend)
trend$p.value
