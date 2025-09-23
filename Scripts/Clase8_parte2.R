#Limpiar espacio de trabajo
cat("\014")
rm(list = ls())
options(scipen=0)
options(digits = 4)

link_datos <- 'https://www.dropbox.com/scl/fi/ng7f1qoig9xxesn8lzp9h/GEIH.dta?rlkey=ws58sutee6n5rjev6p36j27su&st=w4ilis6r&dl=1'
datos <- read_dta(link_datos)

#Modelo sin constante
model <- lm(ocupado ~ 0 + factor(mes), data = datos)
summary(model)

#Modelo con constante
model <- lm(ocupado ~ factor(mes), data = datos)
summary(model)

#Diferencia entre hombres y mujeres en el tiempo
mujeres <- aggregate(ocupado ~ mes, data = datos[datos$mujer ==1, ], FUN = mean)
hombres <- aggregate(ocupado ~ mes, data = datos[datos$mujer ==0, ], FUN = mean)
brecha <- mujeres[, 2]-hombres[, 2]
ocupacion <- cbind(mujeres, hombres[, 2], brecha)
names(brecha) <- c('mes', 'mujeres', 'hombres', 'brecha')

model <- lm(ocupado ~ 0 + factor(mes)*mujer, data = datos)
summary(model)
