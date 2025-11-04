#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())

#Instalar librerias
#install.packages('haven')
#install.packages('plm')
#install.packages('tidyverse')

#Cargar librerias
library(haven)
library(plm) 
library(tseries) # for `adf.test()`
library(dynlm) #for function `dynlm()`
library(vars) # for function `VAR()`
library(nlWaldTest) # for the `nlWaldtest()` function
library(lmtest) #for `coeftest()` and `bptest()`.
library(broom) #for `glance(`) and `tidy()`
library(car) #for `hccm()` robust standard errors
library(sandwich)
library(knitr) #for `kable()`
library(forecast) 
library(systemfit)
library(xtable)

link <- 'https://www.dropbox.com/scl/fi/ehrr0alo2i1e28l6r9b2d/NLSY79_Panel.dta?rlkey=n9p2ictq0yw599r1741jgx2bj&dl=1'
datos <- read_dta(link)
ids <- c(875, 4260, 2796, 3753, 2704, 3735, 6257, 191, 6035, 1879, 1895, 4969, 1082, 4028, 2510, 1547,2161)
smpl <- datos[datos$id %in% ids,c(1:14)]

#Declarar datos como panel
datos <- pdata.frame(datos, index=c("id", "year"))
pdim(datos) #Dimensiones del panel

#-----------------------------------------------------------------------------
#Modelo Pooling
#-----------------------------------------------------------------------------
options(scipen=999)
model <- lm(ln_wage ~ age + I(age^2) + gender + race + hgrade + afqt, data = datos)
print(summary(model), digits=3)

wage.pooled <- plm(ln_wage ~ age + I(age^2) + gender + race + hgrade + afqt, 
                   model="pooling", data=datos)
kable(tidy(wage.pooled), digits=3, caption="Modelo Pooling")

#Correccion de los errores estandar
tbl <- tidy(coeftest(wage.pooled, vcov=vcovHC(wage.pooled, type="HC0",cluster="group")))
kable(tbl, digits=3, caption="Modelo Pooling con Errores Clusterizados")

#-----------------------------------------------------------------------------
#Modelo de Primeras Diferencias
#-----------------------------------------------------------------------------
wage.fd <- plm(ln_wage ~ age + I(age^2) + gender + race + hgrade + afqt, 
                   model="fd", data=datos)
kable(tidy(wage.fd), digits=3, caption="Modelo de Primeras Diferencias")

tbl <- tidy(coeftest(wage.fd, vcov=vcovHC(wage.fd, type="HC0",cluster="group")))
kable(tbl, digits=3, caption="Modelo de Primeras Diferencias con Errores Clusterizados")

#-----------------------------------------------------------------------------
#Modelo de Efectos Fijos
#-----------------------------------------------------------------------------
wage.fe <- plm(ln_wage ~ age + I(age^2) + gender + race + hgrade + afqt, 
               model="within", data=datos)
kable(tidy(wage.fe), digits=3, caption="Modelo de Efectos Fijos")

tbl <- tidy(coeftest(wage.fe, vcov=vcovHC(wage.fe, type="HC0",cluster="group")))
kable(tbl, digits=3, caption="Modelo de Efectos Fijos con Errores Clusterizados")

#Incluir efectos de tiempo
wage.fe <- plm(ln_wage ~ age + I(age^2) + gender + race + hgrade + afqt + factor(year), 
               model="within", effect = "twoways",  data=datos)
kable(tidy(wage.fe), digits=3, caption="Modelo de Efectos Fijos")

#-----------------------------------------------------------------------------
#Modelo de Efectos Aleatorios
#-----------------------------------------------------------------------------
wage.re <- plm(ln_wage ~ age + I(age^2) + gender + race + hgrade + afqt, 
               model="within", data=datos)
kable(tidy(wage.re), digits=3, caption="Modelo de Efectos Aleatorios")

#Prueba de Breusch–Pagan: Efectos Aleatorios vs Pooling
BPtest <- plmtest(wage.pooled, effect="individual")
kable(tidy(BPtest), caption="Prueba de B-P para Efectos Aleatorios")

#Prueba de Hausman: Efectos Aleatorios vs Efectos Fijos
Htest <- phtest(wage.fe, wage.re)
kable(tidy(Htest), caption="Prueba de B-P para Efectos Aleatorios")