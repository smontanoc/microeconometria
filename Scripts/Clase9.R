#Limpiar espacio de trabajo
rm(list = ls())
#install.packages('haven')
#install.packages("modelsummary")
#install.packages("ggplot2")
library(modelsummary)
library(haven)
library(ggplot2)

#Cargar datos
link_datos <- 'https://www.dropbox.com/scl/fi/2heo07p9pb6gzdg336o7x/LaborForce_1973_2005.dta?rlkey=rsusppjqzywq5kvpvm5j97sbr&dl=1'
datos <- read_dta(link_datos)
datos$d1973 <- ifelse(datos$year == 1973, 1, 0)
datos$d1985 <- ifelse(datos$year == 1985, 1, 0)
datos$d1993 <- ifelse(datos$year == 1993, 1, 0)
datos$d2005 <- ifelse(datos$year == 2005, 1, 0)
attach(datos)

################################################################################
#PARTE 1. ANALISIS DE ESTADISTICAS EN EL TIEMPO
################################################################################

#-------------------------------------------------------------------------------
#Modelo sin intercepto
#-------------------------------------------------------------------------------
model1 <- lm(married ~ 0 + d1973 + d1985 + d1993 + d2005)
summary(model1)

B <- data.frame(year = c(1973, 1985, 1993, 2005),
                coeff = coef(model1),
                se =coef(summary(model1))[, "Std. Error"]
                )

n <- length(datos$married)
k <- length(coef(model1))

#Intervalos de confianza al 99%
alpha = 0.01
B$up_ci  <- B$coeff + B$se*abs(qt(alpha/2, n-k))
B$low_ci <- B$coeff - B$se*abs(qt(alpha/2, n-k))

#Coeficientes
ggplot(B, aes(x = year, y = coeff)) +
  geom_point() +
  geom_errorbar(aes(ymin = low_ci, ymax = up_ci), width = 0.2) +
  labs(y = "% Casados", x = "Año") +
  scale_x_continuous(breaks = c(1973, 1985, 1993, 2005)) +
  theme_minimal()

#-------------------------------------------------------------------------------
#Modelo con intercepto
#-------------------------------------------------------------------------------
model2 <- lm(married ~ d1985 + d1993 + d2005)
summary(model2)

B <- data.frame(year = c(1985, 1993, 2005),
                coeff = coef(model2)[2:4],
                se =coef(summary(model2))[2:4, "Std. Error"]
)

n <- length(datos$married)
k <- length(coef(model2))

#Intervalos de confianza al 99%
alpha = 0.01
B$up_ci  <- B$coeff + B$se*abs(qt(alpha/2, n-k))
B$low_ci <- B$coeff - B$se*abs(qt(alpha/2, n-k))

#Coeficientes
ggplot(B, aes(x = year, y = coeff)) +
  geom_point() +
  geom_errorbar(aes(ymin = low_ci, ymax = up_ci), width = 0.2) +
  labs(y = "% Casados", x = "Año") +
  geom_hline(yintercept=0, linetype="dashed", color = "red", size=0.5) +
  scale_x_continuous(breaks = c(1985, 1993, 2005)) +
  theme_minimal()

#-------------------------------------------------------------------------------
#Modelo con intercepto y controles
#-------------------------------------------------------------------------------
model3 <- lm(married ~ d1985 + d1993 + d2005 + 
              female + age + primary + secondary + tertiary)
summary(model3)

B <- data.frame(year = c(1985, 1993, 2005),
                coeff = coef(model3)[2:4],
                se =coef(summary(model3))[2:4, "Std. Error"]
)

n <- length(datos$married)
k <- length(coef(model3))

#Intervalos de confianza al 99%
alpha = 0.01
B$up_ci  <- B$coeff + B$se*abs(qt(alpha/2, n-k))
B$low_ci <- B$coeff - B$se*abs(qt(alpha/2, n-k))

#Coeficientes
ggplot(B, aes(x = year, y = coeff)) +
  geom_point() +
  geom_errorbar(aes(ymin = low_ci, ymax = up_ci), width = 0.2) +
  labs(y = "% Casados", x = "Año") +
  geom_hline(yintercept=0, linetype="dashed", color = "red", size=0.5) +
  scale_x_continuous(breaks = c(1985, 1993, 2005)) +
  theme_minimal()

#-------------------------------------------------------------------------------
#Comparación entre modelos
#-------------------------------------------------------------------------------
models <- list("Modelo 1" = model1, "Modelo 2" = model2, "Modelo 3" = model3)

#Errores estandar robustos
modelsummary(models, vcov = "HC1", gof_map = c("nobs"))

################################################################################
#PARTE 2. COMPARACIÓN ENTRE GRUPOS
################################################################################

#Participacion laboral para mujeres
model_m <- lm(labforce ~ 0 + d1973 + d1985 + d1993 + d2005, 
             data = datos[datos$female == 1,])

#Participacion laboral para hombres
model_h <- lm(labforce ~ 0 + d1973 + d1985 + d1993 + d2005, 
              data = datos[datos$female == 0,])

Bm <- data.frame(year = c(1973, 1985, 1993, 2005), female = c(1,1,1,1), coeff = coef(model_m), se =coef(summary(model_m))[, "Std. Error"])
Bh <- data.frame(year = c(1973.5, 1985.5, 1993.5, 2005.5), female = c(0,0,0,0), coeff = coef(model_h), se =coef(summary(model1))[, "Std. Error"])

alpha = 0.01
k <- length(coef(model_m))
nm <- length(datos$labforce[datos$female ==1])
nh <- length(datos$labforce[datos$female ==0])
Bm$up_ci  <- Bm$coeff + Bm$se*abs(qt(alpha/2, nm-k))
Bm$low_ci <- Bm$coeff - Bm$se*abs(qt(alpha/2, nm-k))
Bh$up_ci  <- Bh$coeff + Bh$se*abs(qt(alpha/2, nh-k))
Bh$low_ci <- Bh$coeff - Bh$se*abs(qt(alpha/2, nh-k))
B <- rbind(Bm, Bh)

ggplot(B, aes(x = year, y = coeff, color = female)) + ylim(0.2, 1) +
  geom_point(aes(shape=factor(female))) +
  geom_line(data = subset(B, female == 1), aes(color = female)) + 
  geom_line(data = subset(B, female == 0), aes(color = female)) +   
  geom_errorbar(aes(ymin = low_ci, ymax = up_ci), width = 0.2) +
  labs(y = "% Fuerza Laboral", x = "Año") +
  scale_x_continuous(breaks = c(1973, 1985, 1993, 2005)) +
  theme_minimal() + theme(legend.position = "none")

#-------------------------------------------------------------------------------
#Modelo 1: Comparación entre grupos
#-------------------------------------------------------------------------------
datos$f1973 <- datos$d1973*ifelse(datos$female == 1, 1, 0)
datos$f1985 <- datos$d1985*ifelse(datos$female == 1, 1, 0)
datos$f1993 <- datos$d1993*ifelse(datos$female == 1, 1, 0)
datos$f2005 <- datos$d2005*ifelse(datos$female == 1, 1, 0)

model1 <- lm(labforce ~ 0 + f1973 + f1985 + f1993 + f2005 +
               d1973 + d1985 + d1993 + d2005)
summary(model1)

B <- data.frame(year = c(1973, 1985, 1993, 2005),
                coeff = coef(model1)[1:4],
                se =coef(summary(model1))[1:4, "Std. Error"]
)

n <- length(datos$labforce)
k <- length(coef(model1))

#Intervalos de confianza al 99%
alpha = 0.01
B$up_ci  <- B$coeff + B$se*abs(qt(alpha/2, n-k))
B$low_ci <- B$coeff - B$se*abs(qt(alpha/2, n-k))

ggplot(B, aes(x = year, y = coeff)) + ylim(-0.65, -0.4) +
  geom_point() +
  geom_errorbar(aes(ymin = low_ci, ymax = up_ci), width = 0.2) +
  labs(y = "Brecha de Genero (% Fuerza Laboral)", x = "Año") +
  scale_x_continuous(breaks = c(1985, 1993, 2005)) +
  theme_minimal()

#-------------------------------------------------------------------------------
#Modelo 1: Comparación entre grupos + controles
#-------------------------------------------------------------------------------
model2 <- lm(labforce ~ 0 + f1973 + f1985 + f1993 + f2005 +
               d1973 + d1985 + d1993 + d2005 + 
               age + primary + secondary + tertiary + literate +
               married + divorced + widowed_ukn)
summary(model2)

B <- data.frame(year = c(1973, 1985, 1993, 2005),
                coeff = coef(model1)[1:4],
                se =coef(summary(model1))[1:4, "Std. Error"]
)

n <- length(datos$labforce)
k <- length(coef(model1))

#Intervalos de confianza al 99%
alpha = 0.01
B$up_ci  <- B$coeff + B$se*abs(qt(alpha/2, n-k))
B$low_ci <- B$coeff - B$se*abs(qt(alpha/2, n-k))

ggplot(B, aes(x = year, y = coeff)) + ylim(-0.65, -0.4) +
  geom_point() +
  geom_errorbar(aes(ymin = low_ci, ymax = up_ci), width = 0.2) +
  labs(y = "Brecha de Genero (% Fuerza Laboral)", x = "Año") +
  scale_x_continuous(breaks = c(1985, 1993, 2005)) +
  theme_minimal()

#-------------------------------------------------------------------------------
#Comparación entre modelos
#-------------------------------------------------------------------------------
models <- list("Modelo 1" = model1, "Modelo 2" = model2)

#Errores estandar robustos
my_coef_map <- c("f1973" = "Brecha 1973", "f1985" = "Brecha 1985", "f1993" = "Brecha 1993", "f2005" = "Brecha 2005")
modelsummary(models, vcov = "HC1", coef_map = my_coef_map, gof_map = c("nobs"))