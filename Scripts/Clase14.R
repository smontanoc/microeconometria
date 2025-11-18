cat("\014")
rm(list = ls())

#--------------------------------------------------------------------------
#Simulacion datos Regresion Discontinua
set.seed(11102025)
x = rnorm(500, 0, 1)
D = I(x >= 0.5)
e = rnorm(500, 0, 1)
tau = 5
y1 = 3*x + tau*D + e
y2 = 3*x + 1.2*x^2 - 0.5*x^3 + tau*D + e
y3 = 3*x + 1.2*x^2 - 0.5*x^3 + 0.15*tau*D + e

plot(x, y1, ylim = c(-10, 15), pch = 19, cex = 0.6, frame = FALSE, 
     xlab = 'Running Var', ylab = 'Y')
abline(0, 3, col = "red", lty = 2, lwd = 2)
abline(tau, 3, col = "blue", lty = 2, lwd = 2)

plot(x, y2, ylim = c(-5, 15), pch = 19, cex = 0.6, frame = FALSE, 
     xlab = 'Running Var', ylab = 'Y')
x0 = x[x<0.5]; fit0 = 3*x0 + 1.2*x0^2 - 0.5*x0^3
x1 = x[x>=0.5]; fit1 = 3*x1 + 1.2*x1^2 - 0.5*x1^3 + tau 
lines(x0[order(x0)], fit0[order(x0)], col = "red", lty = 2, lwd = 2)
lines(x1[order(x1)], fit1[order(x1)], col = "blue", lty = 2, lwd = 2)

plot(x, y3, ylim = c(-5, 15), pch = 19, cex = 0.6, frame = FALSE, 
     xlab = 'Running Var', ylab = 'Y')
x0 = x[x<0.5]; fit0 = 3*x0 + 1.2*x0^2 - 0.5*x0^3; lfit0 = -0.02658 + -0.03562*x0
x1 = x[x>=0.5]; fit1 = 3*x1 + 1.2*x1^2 - 0.5*x1^3 + 0.15*tau; lfit1 = 2.128 + 2.272*x1 
lines(x0[order(x0)], fit0[order(x0)], col = "red", lty = 2, lwd = 2)
lines(x1[order(x1)], fit1[order(x1)], col = "blue", lty = 2, lwd = 2)
lines(x0[order(x0)], lfit0[order(x0)], col = "green", lty = 1, lwd = 2)
lines(x1[order(x1)], lfit1[order(x1)], col = "green", lty = 1, lwd = 2)

#--------------------------------------------------------------------------
#Aplicacion 1

install.packages('haven')
install.packages('rdrobust')
library('haven')
library('rdrobust')

rm(list = ls())
link_datos <- "https://www.dropbox.com/scl/fi/fll8q3cobgvi265ef8b64/SignalingData.dta?rlkey=vbpfxpsa34h9315ax604v8kvi&st=wdg41n74&dl=1"
datos <- read_dta(link_datos)

names(datos)

#Usaremos el bandwidth definido por los autores h = 0.449 

#Verificar balance alrededor del punto de corte
summary(rdrobust(y = datos$female, x = datos$score_sd, c = 0, h = 0.449, all = T))
summary(rdrobust(y = datos$sb11score, x = datos$score_sd, c = 0, h = 0.449, all = T))

#Estimacion del Impacto
summary(rdrobust(y = datos$ln_earningsMW, x = datos$score_sd, c = 0, h = 0.449, all = T))

#Permitir que el bandwidth cambie
summary(rdrobust(y = datos$ln_earningsMW, x = datos$score_sd, c = 0, all = T))