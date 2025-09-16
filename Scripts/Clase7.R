####################################################################
#Heteroscedasticidad y Error de Especificacion
####################################################################

#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())

library(scales)

set.seed(160925)
x <- runif(1000, 0, 10)
e <- rnorm(1000, 0, 1)
#Error de especificación: variable independiente
beta0 <- 10
beta1 <- 0.4
beta2 <- -0.05
y <- beta0 + beta1*x + beta2*x^2 + e 
u <- e + beta2*x^2

plot(x, e, col = alpha("ivory4", 0.5), ylim = c(-9, 3), pch = 19, xlab = "x", ylab = " ")
points(x, u, col = alpha("maroon", 0.5), pch = 18) 
legend("bottomleft", legend=c("e", "u"), col=c("ivory4", "maroon"), pch=c(19, 18), cex=0.8)

#Error de especificación: variable dependiente
x <- runif(1000, 0, 1)
e <- runif(1000, 0, 2)
beta0 <- 0
beta1 <- 1
y <- exp(beta0 + beta1*x + e)
summary(y)

plot(x, log(y), col = alpha("ivory4", 0.5), pch = 19, 
     ylim = c(-10, 20), xlab = "x", ylab = " ")
points(x, y, col = alpha("maroon", 0.5), pch = 18) 
legend("topleft", legend=c("log(y)", "y"), col=c("ivory4", "maroon"), pch=c(19, 18), cex=0.8)

####################################################################
#Errores Estandar Robustos
####################################################################

#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())

#Datos
install.packages('haven')
install.packages("sandwich")
install.packages("lmtest")
library('haven')
library('sandwich')
library('lmtest')

link_datos <- 'https://www.dropbox.com/scl/fi/vy1cw4zkgm3op6pzd7lau/skills_data.dta?rlkey=p11n80lk68nzkqigt2dhbtyl9&dl=1'
datos <- read_dta(link_datos)

attach(datos)

# Ejemplo: ajustar un modelo de regresión lineal
model <- lm(ln_fst_wage ~ lit + num + eng
            + program_type_1 + program_type_4 + program_type_3
            + female + age + age_2 + factor(stratum) + factor(educ_madre) + factor(study_field) + factor(test_edition) + factor(grad_year))

summary(model)

matriz_cov_robusta <- vcovHC(model)

coeftest(model, vcov = matriz_cov_robusta)